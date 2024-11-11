import numpy as np
import torch
import torch.nn as nn
import torch.nn.functional as F

torch.manual_seed(0)
np.random.seed(0)

# activattion type
act_dict = {
    "tanh": nn.Tanh(),
    "relu": nn.ReLU(),
    "elu": nn.ELU(),
    "softplus": nn.Softplus(),
    "sigmoid": nn.Sigmoid(),
    "idt": nn.Identity(),
    "gelu": nn.GELU()
}

# initiation method
init_dict={
    "xavier_normal": nn.init.xavier_normal_,
    "xavier_uniform": nn.init.xavier_uniform_,
    "uniform": nn.init.uniform_,
    "norm": nn.init.normal_
}

## the input branch and trunk
# ================================================================================
class Branch(nn.Module): # rho
    def __init__(self, width):
        super(Branch, self).__init__()
        self.padding = 8
        self.fc0 = nn.Linear(1, width)

    def forward(self, x):

        x = self.fc0(x)
        x = x.permute(0, 3, 1, 2) # batch_size, width, n1,n2
        x = F.pad(x, [0,self.padding, 0,self.padding]) # padding for last 2 dimensions (n1,n2)
        x = x.permute(0, 2, 3, 1) # batch_size, n1, n2, width

        return x
    
    
class Trunk(nn.Module): # frequency
    def __init__(self, width):
        super(Trunk, self).__init__()
        self.fc0 = nn.Linear(1, width)

    def forward(self, x):
        
        x = self.fc0(x)

        return x

## The wrap of branch-trunk network
# ================================================================================   
class BranchTrunk(nn.Module):
    def __init__(self, width):
        super(BranchTrunk, self).__init__()
        self.branch = Branch(width)
        self.trunk = Trunk(width)

    def forward(self, branch_Rho, trunk_Freq):  
        
        x1 = self.branch(branch_Rho)
        x2 = self.trunk(trunk_Freq)
        n1 = x1.shape[1]
        n2 = x1.shape[2]
        n3 = x1.shape[3]
        x = torch.einsum("bxyz,cz->bcxyz", [x1, x2])
        x = x.view(-1, n1, n2, n3)

        return x

## U-Net
# ================================================================================
class Unet(nn.Module):
    def __init__(self, input_channels, output_channels, kernel_size, dropout_rate):
        super(Unet, self).__init__()
        self.input_channels = input_channels
        self.conv1 = self.conv(input_channels, output_channels, kernel_size=kernel_size, stride=2, dropout_rate = dropout_rate)
        self.conv2 = self.conv(input_channels, output_channels, kernel_size=kernel_size, stride=2, dropout_rate = dropout_rate)
        self.conv2_1 = self.conv(input_channels, output_channels, kernel_size=kernel_size, stride=1, dropout_rate = dropout_rate)
        self.conv3 = self.conv(input_channels, output_channels, kernel_size=kernel_size, stride=2, dropout_rate = dropout_rate)
        self.conv3_1 = self.conv(input_channels, output_channels, kernel_size=kernel_size, stride=1, dropout_rate = dropout_rate)
        
        self.deconv2 = self.deconv(input_channels, output_channels)
        self.deconv1 = self.deconv(input_channels*2, output_channels)
        self.deconv0 = self.deconv(input_channels*2, output_channels)
    
        self.output_layer = self.output(input_channels*2, output_channels, 
                                         kernel_size=kernel_size, stride=1, dropout_rate = dropout_rate)


    def forward(self, x):
        out_conv1 = self.conv1(x)
        out_conv2 = self.conv2_1(self.conv2(out_conv1))
        out_conv3 = self.conv3_1(self.conv3(out_conv2))
        out_deconv2 = self.deconv2(out_conv3)
        concat2 = torch.cat((out_conv2, out_deconv2), 1)
        out_deconv1 = self.deconv1(concat2)
        concat1 = torch.cat((out_conv1, out_deconv1), 1)
        out_deconv0 = self.deconv0(concat1)
        concat0 = torch.cat((x, out_deconv0), 1)
        out = self.output_layer(concat0)

        return out

    def conv(self, in_planes, output_channels, kernel_size, stride, dropout_rate):
        return nn.Sequential(
            nn.Conv2d(in_planes, output_channels, kernel_size=kernel_size,
                      stride=stride, padding=(kernel_size - 1) // 2, bias = False),
            nn.BatchNorm2d(output_channels),
            nn.LeakyReLU(0.1, inplace=True),
            nn.Dropout(dropout_rate)
        )

    def deconv(self, input_channels, output_channels):
        return nn.Sequential(
            nn.ConvTranspose2d(input_channels, output_channels, kernel_size=4,
                               stride=2, padding=1),
            nn.LeakyReLU(0.1, inplace=True)
        )

    def output(self, input_channels, output_channels, kernel_size, stride, dropout_rate):
        return nn.Conv2d(input_channels, output_channels, kernel_size=kernel_size,
                         stride=stride, padding=(kernel_size - 1) // 2)


## 2D Fourier layer
# ================================================================================
class SpectralConv2d(nn.Module):
    def __init__(self, in_channels, out_channels, modes1, modes2):
        super(SpectralConv2d, self).__init__()

        """
        2D Fourier layer: It does FFT, linear transform, and Inverse FFT.   

        Parameters:
        -----------
        in_channels  : lifted dimension 
        out_channels : output dimension 
        modes1       : truncated modes in the first dimension of fourier domain 
        modes2       : truncated modes in the second dimension of fourier domain
        """

        self.in_channels = in_channels
        self.out_channels = out_channels
        self.modes1 = modes1 #Number of Fourier modes to multiply, at most floor(N/2) + 1
        self.modes2 = modes2

        self.scale = (1 / (in_channels * out_channels))
        self.weights1 = nn.Parameter(self.scale * torch.rand(in_channels, out_channels, self.modes1, self.modes2, dtype=torch.cfloat))
        self.weights2 = nn.Parameter(self.scale * torch.rand(in_channels, out_channels, self.modes1, self.modes2, dtype=torch.cfloat))

    def compl_mul2d(self, input, weights):
        # (batch, in_channel, x,y ), (in_channel, out_channel, x,y) -> (batch, out_channel, x,y)
        return torch.einsum("bixy,ioxy->boxy", input, weights)

    def forward(self, x):
        batchsize = x.shape[0]
        #Compute Fourier coeffcients up to factor of e^(- something constant)
        x_ft = torch.fft.rfft2(x)

        # Multiply relevant Fourier modes
        # the result in last dimension is half for fft
        # and the result in  the second to last dimension is symmetric.
        out_ft = torch.zeros(batchsize, self.out_channels,  x.size(-2), x.size(-1)//2 + 1, dtype=torch.cfloat, device=x.device)
        out_ft[:, :, :self.modes1, :self.modes2] = \
            self.compl_mul2d(x_ft[:, :, :self.modes1, :self.modes2], self.weights1)
        out_ft[:, :, -self.modes1:, :self.modes2] = \
            self.compl_mul2d(x_ft[:, :, -self.modes1:, :self.modes2], self.weights2) # because of  symmetry?

        #Return to physical space
        x = torch.fft.irfft2(out_ft, s=(x.size(-2), x.size(-1)))
        return x


## Unet-fourier layer
# ================================================================================
class UFNO2d(nn.Module):
    def __init__(self, modes1, modes2, width, layer_fno, layer_ufno, act_func):
        super(UFNO2d, self).__init__()
        """
        U-FNO's default setting contains 3 Fourier layers and 3 U-Fourier layers.
        
        input shape: (batch, x, y, nchannel)  # 1 channels for logarithm  resistivity
        output shape: (batch, x, y, nchannel)  # 2 channels for Rhoxy and Rhoyx

        Parameters:
        -----------
            - modes1    : truncated modes in the first dimension of fourier domain
            - modes2    : truncated modes in the second dimension of fourier domain
            - act_func  : activation function, key must in act_dict
        
        """
        self.modes1 = modes1
        self.modes2 = modes2
        self.width = width
        self.layer_fno = layer_fno
        self.layer_ufno = layer_ufno
        if act_func in act_dict.keys():
            self.activation = act_dict[act_func]
        else:
            raise KeyError("act name not in act_dict")
        
        self.fno = nn.ModuleList()
        self.conv = nn.ModuleList()
        self.ufno = nn.ModuleList()

        for _ in range(layer_fno+layer_ufno):
            self.fno.append(SpectralConv2d(self.width, self.width, self.modes1, self.modes2))
            self.conv.append(nn.Conv2d(self.width, self.width, 1))

        for _ in range(layer_ufno):
            self.ufno.append(Unet(self.width, self.width, 3, 0 ))
        
    def forward(self, x):
        '''
        input shape: (batch, x, y, width)
        output shape: (batch, x, y, width)
        '''
        x = x.permute(0, 3, 1, 2) # batch_size, width, n1,n2
        # number of fno layers
        for i in range(self.layer_fno):
            x1 = self.fno[i](x)
            x2 = self.conv[i](x)
            x  = x1 + x2
            x = self.activation(x)

        # number of ufno layers
        for i in range(self.layer_fno, self.layer_fno+self.layer_ufno):
            x1 = self.fno[i](x)
            x2 = self.conv[i](x)
            x3 = self.ufno[i-self.layer_fno](x)
            x  = x1 + x2 + x3
            x = self.activation(x)
        
        x = x.permute(0, 2, 3, 1) # batch_size, n1, n2, width

        return x
    
class EFDO(nn.Module):
    def __init__(self, modes1, modes2, width, nout, layer_sizes, nLoc, init_func, layer_fno=3, layer_ufno=3, act_func="gelu"):
        super(EFDO, self).__init__()

        """
        A workflow function
        """
        self.width = width
        self.padding = 8
        self.nout = nout
        if act_func in act_dict.keys():
            self.activation = act_dict[act_func]
        else:
            raise KeyError("act name not in act_dict")
        if init_func in init_dict.keys():
            initializer = init_dict[init_func]
        else:
            raise KeyError("init name not in init_dict")
        self.BranchTrunk = BranchTrunk(width)
        self.ufno = UFNO2d(modes1, modes2, width, layer_fno, layer_ufno, act_func)
        self.fc1 = nn.Linear(width, 128)
        self.fc2 = nn.Linear(128, nout)
        self.linears = nn.ModuleList()
        for i in range(1, len(layer_sizes)):
            self.linears.append(torch.nn.Linear(layer_sizes[i - 1], layer_sizes[i]))
            initializer(self.linears[-1].weight)
            nn.init.zeros_(self.linears[-1].bias)

    def forward(self, x, freq):
        batchSize = x.shape[0]
        nFreq = freq.shape[0]
        x = self.BranchTrunk(x, freq)
        x = self.ufno(x)
        x = self.fc1(x)
        x = self.activation(x)
        x = self.fc2(x)
        x = x[:, :-self.padding, :-self.padding, :]
        x = x.contiguous().view(batchSize, nFreq, -1, self.nout)
        x = x.permute(0, 1, 3, 2)
        for i in range(len(self.linears)-1):
            x = self.activation(self.linears[i](x))
        x = self.linears[-1](x)
        x = x.permute(0, 1, 3, 2)

        return x
