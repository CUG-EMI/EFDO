using PyCall
using MAT

py"""
import sys
sys.path.insert(0, "./")
import gaussian_random_fields as gr
from scipy.ndimage import gaussian_filter
from scipy.interpolate import interp2d

import numpy as np
import scipy.io as scio
from timeit import default_timer
from MT2D_secondary import *

def generate_model(alpha_l,n_sample,nza,n_freq,size_k, size_o):
    z = 20e3
    y = 6500
    size_b = nza
    freq = np.logspace(np.log10(1000),np.log10(1/1000),n_freq) # 1000 - 0.001 Hz, n_freq Freqs
    ry = np.linspace(-(y-350),(y-350),size_o+1)

    # grid blocks
    multiply_y = 200
    multiply_z = 50
    airLayer = np.array([10, 30, 100, 300, 500, 1000, 5000, 30000, 50000, 100000])
    z_air = airLayer[::-1] * 1.0

    zBlock1 = np.arange(5, 41, 5)
    nz1 = len(zBlock1)
    zBlock2 = np.ones(10) * 50.0
    nz2 = len(zBlock2)
    zBlock3 = np.ones(12) * 60.0
    nz3 = len(zBlock3)
    zBlock4 = np.ones(22) * 100.0
    nz4 = len(zBlock4)
    zBlock5 = np.ones(size_k - nz1 - nz2 - nz3 - nz4) * 200.0
    zPad = np.logspace(np.log10(200), np.log10(z*multiply_z), size_b)
    zBlock0 = np.concatenate((zBlock1, zBlock2, zBlock3, zBlock4, zBlock5))
    zBlock = np.concatenate((z_air, zBlock0, zPad))

    yBlock0 = np.ones(size_k) * 200.0
    yPad = np.logspace(np.log10(yBlock0[-1]), np.log10(yBlock0[-1]*multiply_y), size_b)
    yBlock = np.concatenate((yPad[::-1], yBlock0, yPad))

    ############## background and air layer #####################
    len_z = size_b+size_k+nza # 10+64+10
    len_y = 2*size_b+size_k # 20+64
    model = np.ones((n_sample,len_z,len_y))*(-2)

    #############  parameters  ###################################
    sig_up, sig_down = -4, 0  # sigma range from 10^[-4, 0]

    # alpha = 4.0  smothness of model, the larger the smoother
    mode = 'bound' # 
    set_1 = sig_up # log10
    set_2 = sig_down # log10

    ################  construct model ###############################
    for ii in range(n_sample):
        model0 = 0.0
        model1 = 0.0

        for alpha in alpha_l:
            model_temp0 = gr.gaussian_random_field(alpha = alpha, size = size_k,
                                       mode=mode, set_1=set_1, set_2=set_2)
            model0 += model_temp0
        min0 = np.min(model_temp0)
        max0 = np.max(model_temp0)
        model0 = gaussian_filter(model0, sigma=2)/len(alpha_l) # 1-D convolution filters
        min1 = np.min(model0)
        max1 = np.max(model0)
        model0 = (model0-min1)*((max0-min0)/(max1-min1))+min0
        model[ii,nza:-size_b,size_b:-size_b] = model0  
        model[ii,nza:-size_b,:size_b]  = model0[:,0:1]*np.ones((size_k,size_b)) 
        model[ii,nza:-size_b,-size_b:] = model0[:,-1:]*np.ones((size_k,size_b))
        model[ii,-size_b:,:]           = model[ii,-size_b-1:-size_b,:]*np.ones((size_b,size_k+2*size_b)) 
       
    model[:,:nza,:] = -8 
    model_k = model[:,nza:-size_b,size_b:-size_b] 
    return freq, ry, yBlock, zBlock, model, model_k

def grfModelGen(n_sample):  
    np_dtype = np.float64
    nza = 10 
    n_freq = 32 
    size_k = 64 
    size_o = 41
    alpha_l = [3.0,4.0,5.0,6.0,7.0]

    freq, ry, yBlock, zBlock, sig, sig_k,\
             = generate_model(alpha_l,n_sample,nza,n_freq,size_k, size_o) 

    time0 = default_timer()

    # skin depth 
    alpha0 = 1 # 1 times of skin depth 
    skin_depth = 0.503*alpha0*np.sqrt(1.0/np.mean(10**sig_k)/freq[0]) # km 503sqrt(\rho / f), km unit
    print(np.mean(sig_k))
    print(f"skin depth is {skin_depth}km")
    skin_depth = 0.503*alpha0*np.sqrt(1.0/np.mean(10**sig_k)/freq[-1]) # km
    print(f"skin depth is {skin_depth}km")


    time1 = default_timer()
    print(f"time using: {time1-time0}s")

    return freq, ry, yBlock, zBlock, sig, sig_k


    """

freq, ry, yBlock, zBlock, sig, sig_k = py"grfModelGen"(36000)

println("Starting to save training data as mat file...")
workpath = "../data/"
saveFile = "genModel.mat"
saveFile = workpath * saveFile
file = matopen(saveFile, "w")
write(file, "freq", freq)
write(file, "obs", ry)
write(file, "sig", sig)
write(file, "sig_k", sig_k)
write(file, "yBlock", yBlock)
write(file, "zBlock", zBlock)
close(file)