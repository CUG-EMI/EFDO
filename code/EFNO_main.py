"""
predict apparent resistivity Rxy and Ryx
usage: python EFNO_main.py EFNO_config
Original network ref: https://github.com/zhongpenggeo/EFNO
"""

import os
import numpy as np
import torch
from torchinfo import summary
import yaml
from timeit import default_timer
import sys
from utilities import *
from EFNO import EFNO

torch.manual_seed(0)
np.random.seed(0)

def get_batch_data(TRAIN_PATH, VAL_PATH, TEST_PATH,   
                   ntrain, nval, ntest,   
                   r_train, s_train, r_val, s_val, r_test, s_test,   
                   batch_size, n_out):  
    '''  
    preprocess data for training, validation and testing dataset  

    Parameters:  
    ----------  
        - TRAIN_PATH : path of the training dataset  
        - VAL_PATH   : path of the validation dataset  
        - TEST_PATH  : path of the testing dataset  
        - ntrain     : number of training data   
        - nval       : number of validation data  
        - ntest      : number of testing data   
        - r_train    : downsampling factor of training data  
        - s_train    : resolution of training data  
        - r_val      : downsampling factor of validation data  
        - s_val      : resolution of validation data  
        - r_test     : downsampling factor of testing data  
        - s_test     : resolution of testing data  
        - batch_size : batch size in training and testing  
        - n_out      : number of output channels  
    '''  
    print("begin to read data")  
    
    # Define key mapping based on n_out
    # All dataset have been normalized already
    # rhoxy and rhoxy are normalized by log10 values
    # phsxy and phsyx are normalized by dividing 180
    if n_out == 2:
        key_map = ['rhoxy', 'rhoyx']
    elif n_out == 4:
        key_map = ['rhoxy', 'phsxy', 'rhoyx', 'phsyx']
    else:
        raise ValueError(f"n_out must be 2 or 4, got {n_out}")
    
    t_read0 = default_timer()

    # get training data  
    reader = MatReader(TRAIN_PATH)  
    x_train = reader.read_field('sig')  
    x_train = x_train[:ntrain,::r_train[0],::r_train[1]][:,:s_train[0],:s_train[1]]  
    y_train = torch.stack([reader.read_field(key_map[i])\
    [:ntrain,::r_train[2],::r_train[3]][:,:s_train[2],:s_train[3]] for i in range(len(key_map))]).permute(1,2,3,0)  
    freq_base = reader.read_field('freq')[0]  
    obs_base = reader.read_field('obs')[0]  
    freq = torch.log10(freq_base[::r_train[2]][:s_train[2]])  
    obs = obs_base[::r_train[3]][:s_train[3]]/torch.max(obs_base)  
    # nLoc = obs.shape[0]  
    # nFreq = freq.shape[0]  
    # freq = freq.view(nFreq, -1)  
    loc1,loc2     = torch.meshgrid(freq,obs)
    loc_train = torch.cat((loc1.reshape(-1,1),loc2.reshape(-1,1)),-1)
    del reader  

    # get validation data  
    reader_val = MatReader(VAL_PATH)  
    x_val = reader_val.read_field('sig')  
    x_val = x_val[:nval,::r_val[0],::r_val[1]][:,:s_val[0],:s_val[1]]  
    y_val = torch.stack([reader_val.read_field(key_map[i])\
    [:nval,::r_val[2],::r_val[3]][:,:s_val[2],:s_val[3]] for i in range(len(key_map))]).permute(1,2,3,0)  
    freq_base = reader_val.read_field('freq')[0]  
    obs_base = reader_val.read_field('obs')[0] 
    freq    = torch.log10(freq_base[::r_val[2]][:s_val[2]])
    obs     = obs_base[::r_val[3]][:s_val[3]]/torch.max(obs_base)

    loc1,loc2= torch.meshgrid(freq,obs)
    loc_val = torch.cat((loc1.reshape(-1,1),loc2.reshape(-1,1)),-1)
    del reader_val  

    # get test data  
    reader_test = MatReader(TEST_PATH)  
    x_test = reader_test.read_field('sig')  
    x_test = x_test[:ntest,::r_test[0],::r_test[1]][:,:s_test[0],:s_test[1]]  
    y_test = torch.stack([reader_test.read_field(key_map[i])\
    [:ntest,::r_test[2],::r_test[3]][:,:s_test[2],:s_test[3]] for i in range(len(key_map))]).permute(1,2,3,0)  
    freq_base = reader_test.read_field('freq')[0]  
    obs_base = reader_test.read_field('obs')[0] 
    freq    = torch.log10(freq_base[::r_test[2]][:s_test[2]])
    obs     = obs_base[::r_test[3]][:s_test[3]]/torch.max(obs_base)

    loc1,loc2= torch.meshgrid(freq,obs)
    loc_test = torch.cat((loc1.reshape(-1,1),loc2.reshape(-1,1)),-1)
    del reader_test  

    # dataset normalization  
    x_normalizer = GaussianNormalizer(x_train)  
    x_train = x_normalizer.encode(x_train)  
    x_val = x_normalizer.encode(x_val)  
    x_test = x_normalizer.encode(x_test)  

    y_normalizer = GaussianNormalizer_out(y_train)  
    y_train = y_normalizer.encode(y_train)  

    # reshape data  
    x_train = x_train.reshape(ntrain, s_train[0], s_train[1], 1)  
    x_val = x_val.reshape(nval, s_val[0], s_val[1], 1)  
    x_test = x_test.reshape(ntest, s_test[0], s_test[1], 1)  

    # Create dataloaders  
    train_loader = torch.utils.data.DataLoader(  
        torch.utils.data.TensorDataset(x_train, y_train),   
        batch_size=batch_size,   
        shuffle=True  
    )  
    
    val_loader = torch.utils.data.DataLoader(  
        torch.utils.data.TensorDataset(x_val, y_val),   
        batch_size=batch_size,   
        shuffle=False  
    )  
    
    test_loader = torch.utils.data.DataLoader(  
        torch.utils.data.TensorDataset(x_test, y_test),   
        batch_size=batch_size,   
        shuffle=False  
    )  

    t_read1 = default_timer()  
    print(f"reading finished in {t_read1-t_read0:.3f} s")  

    return loc_train, loc_val, loc_test, train_loader, val_loader, test_loader, x_normalizer, y_normalizer

def print_model(model, flag=True):
    if flag:
        summary(model)


def batch_train(model, batch_size,s_train,r_train,loc,train_loader, y_normalizer, loss_func, optimizer, scheduler, device):
    '''min-batch training
    Parameters:
    -----------
        - model       : neural network model
        - batch_size  : batch size
        - s_train     : resolution of training data
        - loc         : location of training data
        - train_loader: dataloader for training data
        - y_normalizer: normalizer for training output data
        - loss_func   : function for loss
        - optimizer   : optimizer
        - scheduler   : scheduler
        - device      : device of data and model storage, 'cpu' or 'cuda:id'
    '''
    # if not y_normalizer.is_cuda:
    #     y_normalizer.to(device)
    train_l2 = 0.0
    input_size = s_train[2]*s_train[3]
    loc = loc.to(device)
    for x, y in train_loader:
        x, y = x.to(device), y.to(device) # input (batch, s, s,1)

        # batch_size = len(x)
        optimizer.zero_grad()
        out = model(loc,x)
        n_out = y.shape[-1]
        # for muliti-output, restore one dimesion to (H,W) at each channel and then concatenate
        out = torch.cat(([out[:,i*input_size:(i+1)*input_size].reshape(batch_size,int(s_train[2]/r_train[2]),int(s_train[3]/r_train[3]),-1) for i in range(n_out)]),-1)
        out = y_normalizer.decode(out)
        y = y_normalizer.decode(y)
        loss = loss_func(out, y)
        loss.backward()
        optimizer.step()        
        train_l2 += loss.item()
    scheduler.step()
    return train_l2


def batch_validate(model,batch_size,s_val,r_val,loc,val_loader, y_normalizer, loss_func, device):
    '''batch validation of test data
    Parameters: as batch_train function
    '''
    # if not y_normalizer.is_cuda:
    #     y_normalizer.to(device)
    val_l2 = 0.0
    input_size = s_val[2]*s_val[3]
    loc = loc.to(device)
    with torch.no_grad():
        for x, y in val_loader:
            x, y = x.to(device), y.to(device)
            # batch_size = len(x)
            n_out = y.shape[-1]
            out = model(loc,x)#.reshape(batch_size, s_test[2], s_test[3],-1)
            out = torch.cat(([out[:,i*input_size:(i+1)*input_size].reshape(batch_size,int(s_val[2]/r_val[2]),int(s_val[3]/r_val[3]),-1) \
                    for i in range(n_out)]),-1)
            out = y_normalizer.decode(out)
            val_l2 += loss_func(out, y).item()
    return val_l2

def batch_test(model,batch_size,s_test,r_test,loc,test_loader, y_normalizer, loss_func, device):
    '''batch validation of test data
    Parameters: as batch_train function
    '''
    # if not y_normalizer.is_cuda:
    #     y_normalizer.to(device)
    test_l2 = 0.0
    input_size = s_test[2]*s_test[3]
    loc = loc.to(device)
    with torch.no_grad():
        for x, y in test_loader:
            x, y = x.to(device), y.to(device)
            # batch_size = len(x)
            n_out = y.shape[-1]
            out = model(loc,x)#.reshape(batch_size, s_test[2], s_test[3],-1)
            out = torch.cat(([out[:,i*input_size:(i+1)*input_size].reshape(batch_size,int(s_test[2]/r_test[2]),int(s_test[3]/r_test[3]),-1) \
                    for i in range(n_out)]),-1)
            out = y_normalizer.decode(out)
            test_l2 += loss_func(out, y).item()
    return test_l2


def run_train(model, batch_size,   
              s_train, r_train, s_val, r_val, s_test, r_test,  
              loc_train, loc_val, loc_test,  
              train_loader, val_loader, test_loader,  
              y_normalizer, loss_func, optimizer, scheduler,   
              epochs, thre_epoch, patience, save_step,  
              save_mode, model_path, model_path_temp,  
              ntrain, nval, ntest, device, log_file):  
    '''  
    training, validation and testing of model  

    Parameters: some parameters are same as 'batch_train' function and 'get_batch_data' function  
    -----------  
        - epochs: number of epochs  
        - thre_epoch: threshold of epochs for early stopping  
        - patience: patience epochs that loss continue to rise  
        - save_step: save model every 'save_step' epochs  
        - save_mode: save whole model or static dictionary  
        - model_path: path to save model  
        - model_path_temp: path to save temporary model  
        - log_file: path to save log file  
    '''  
    
    best_val_l2 = np.inf  
    stop_counter = 0  
    best_epoch = 0  
    temp_file = None  

    for ep in range(epochs):  
        t1 = default_timer()  
        
        # Training phase  
        model.train()  
        train_l2 = batch_train(model, batch_size, s_train, r_train,   
                              loc_train, train_loader, y_normalizer,  
                              loss_func, optimizer, scheduler, device)  
        
        # Validation phase  
        model.eval()  
        val_l2 = batch_validate(model, batch_size, s_val, r_val,  
                               loc_val, val_loader, y_normalizer,   
                               loss_func, device)  
        
        # Testing phase  
        test_l2 = batch_validate(model, batch_size, s_test, r_test,  
                                loc_test, test_loader, y_normalizer,   
                                loss_func, device)  
        
        # Normalize losses by dataset sizes  
        train_l2 /= ntrain  
        val_l2 /= nval  
        test_l2 /= ntest  

        # Save temporary model  
        if (ep+1) % save_step == 0:  
            if temp_file is not None:  
                os.remove(temp_file)  
            torch.save(model.state_dict(),  model_path_temp+'_epoch_'+str(ep+1)+'.pkl')  
            temp_file = model_path_temp+'_epoch_'+str(ep+1)+'.pkl'  

        # Early stopping logic  
        if (ep+1) > thre_epoch:  
            if val_l2 < best_val_l2:  
                best_val_l2 = val_l2  
                best_epoch = ep  
                stop_counter = 0  
                # Save best model  
                if save_mode == 'state_dict':  
                    torch.save(model.state_dict(), model_path+'_epoch_'+str(ep+1)+'.pkl')  
                else:  
                    torch.save(model, model_path+'_epoch_'+str(ep+1)+'.pt')  
            else:  
                stop_counter += 1  
            
            if stop_counter > patience:  
                print(f"Early stop at epoch {ep}")  
                print(f"Best model was saved at epoch {best_epoch+1}")  
                print(f"# Early stop at epoch {ep}", file=log_file)  
                print(f"# Best model was saved at epoch {best_epoch+1}",   
                      file=log_file)  
                break  

        t2 = default_timer()  
        
        # Print and log results  
        print(ep + 1, t2 - t1, train_l2, val_l2, test_l2)  
        print(ep + 1, t2 - t1, train_l2, val_l2, test_l2, file=log_file)



################################################################
# configs
################################################################
def main(item):
    '''
    item: item name in config_EFNO.yml file
    '''
    t0 = default_timer()
    # read configurations from config_EFNO.yml file
    with open( 'config_EFNO.yml') as f:
        config = yaml.full_load(f)
    config = config[item]
    cuda_id = "cuda:"+str(config['cuda_id'])
    device = torch.device(cuda_id if torch.cuda.is_available() else "cpu")
    TRAIN_PATH = config['TRAIN_PATH']
    VAL_PATH   = config['VAL_PATH']
    TEST_PATH  = config['TEST_PATH']
    save_mode  = config['save_mode']
    save_step  = config['save_step']
    n_out      = config['n_out'] # rhoxy,rhoyx
    model_path = "../model/"+config['name']+ "_"+str(n_out) # save path and name of model
    model_path_temp = "../temp_model/"+config['name']+"_"+ str(n_out)
    log_path = "../log/"+config['name']+"_"+str(n_out)+'.log'
    ntrain = config['ntrain']
    nval = config['nval']
    ntest  = config['ntest']
    batch_size = config['batch_size']
    learning_rate = config['learning_rate']
    epochs = config['epochs']
    step_size = config['step_size']
    gamma = config['gamma']
    modes = config['modes']
    width = config['width']
    s_train = config['s_train']
    r_train = config['r_train']
    s_val = config['s_val']
    r_val = config['r_val']
    s_test = config['s_test']
    r_test = config['r_test']
    layer_num = config['layer_num']
    last_size = config['last_size']
    # layer_sizes = config['layer_sizes'] + [s_train[0]*s_train[1]]
    layer_sizes = config['layer_sizes'] + [2*64]
    act_fno   = config['act_fno']
    act_func  = config['act_func']
    init_func = config['init_func']    
    patience = config['patience'] # if there is {patience} epoch that val_error is larger, early stop,
    thre_epoch = config['thre_epoch']# condiser early stop after {thre_epoch} epochs
    print_model_flag = config['print_model_flag'] # print model

    ################################################################
    # load data and data normalization 
    ################################################################
    loc_train,loc_val,loc_test,train_loader, val_loader, test_loader, _,y_normalizer = \
        get_batch_data(TRAIN_PATH, VAL_PATH, TEST_PATH, ntrain, nval, ntest,\
                        r_train, s_train, r_val, s_val, r_test, s_test, batch_size, n_out)
    y_normalizer.to(device)

    ################################################################
    # training, evaluation and test
    ################################################################
    model = EFNO(layer_sizes, act_func, init_func,modes, modes, width,\
        n_out,layer_num, last_size, act_fno).to(device)
    print_model(model, print_model_flag)
    optimizer = Adam(model.parameters(), lr=learning_rate, weight_decay=1e-4)
    scheduler = torch.optim.lr_scheduler.StepLR(optimizer, step_size=step_size, gamma=gamma)

    myloss = LpLoss(size_average=False)
    log_file = open(log_path,'a+')
    print("####################")
    print("begin to train model")
    
    run_train(model, batch_size,s_train,r_train,s_val,r_val,s_test,r_test,loc_train,loc_val,loc_test,train_loader,val_loader, test_loader, y_normalizer, myloss, optimizer, scheduler, epochs, \
               thre_epoch, patience, save_step,save_mode, model_path,model_path_temp, ntrain, nval, ntest,device,log_file)

    tn = default_timer()
    print(f'all time:{tn-t0:.3f}s')
    print(f'# all time:{tn-t0:.3f}s',file=log_file)
    log_file.close()


if __name__ == '__main__':
    # item name in config_EFNO.yml file
    try:
        item = sys.argv[1]
    except: 
        item = 'EFNO_config'
    main(item)