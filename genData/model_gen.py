'''
generate random model 
usage: python model_gen.py 100 50 train_gen

how to expand boundaries? use the same sigma near boundary.
Code source: https://github.com/zhongpenggeo/EFNO
'''
import ray
import gaussian_random_fields as gr
from scipy.ndimage import gaussian_filter
from scipy.interpolate import interp2d

import sys
import numpy as np
import scipy.io as scio
from timeit import default_timer
from MT2D_secondary import *

def generate_model(alpha_l, n_sample, nza, n_freq, size_k, size_o):
    '''
    genenrate random electrical model  

    Three parts of model:
    0. layers (1D model) for background
    1. blocks
    2. layers
    3. (one) fault

    Parameters:
    nza   : number of air layer
    y     : [-y,y]
    z     : [0,z] 
    size_o: number of observation stations
    size_k: kernel domain,
    '''
    z = 20e3  # maximum depth (m)  
    y = 6500  # horizontal extent (m)  
    size_b = nza  
    # Frequencies from 1000 to 0.001 Hz  
    freq = np.logspace(np.log10(1000),np.log10(1/1000),n_freq)  
    # Observation points  
    ry = np.linspace(-(y-350),(y-350),size_o+1)  

    multiply_y = 20
    multiply_z = 20

    # Air layer thicknesses (m)  
    airLayer = np.array([10, 30, 100, 300, 500, 1000, 5000, 30000, 50000, 100000])  
    z_air = -airLayer[::-1]  # Convert to negative heights for air layers  

    # Build underground depth positions  
    # Layer 1: increasing thickness from 5m to 40m, starting from 0  
    zBlock1 = np.concatenate(([0], np.cumsum(np.arange(5, 41, 5))))  # Add 0 as starting point  
    nz1 = len(zBlock1)  
    z_current = zBlock1[-1]  
    
    # Layer 2: constant 50m thickness  
    zBlock2 = z_current + np.cumsum(np.ones(10) * 50.0)  
    nz2 = len(zBlock2)  
    z_current = zBlock2[-1]  
    
    # Layer 3: constant 60m thickness  
    zBlock3 = z_current + np.cumsum(np.ones(12) * 60.0)  
    nz3 = len(zBlock3)  
    z_current = zBlock3[-1]  
    
    # Layer 4: constant 100m thickness  
    zBlock4 = z_current + np.cumsum(np.ones(22) * 100.0)  
    nz4 = len(zBlock4)  
    z_current = zBlock4[-1]  
    
    # Layer 5: constant 200m thickness  
    zBlock5 = z_current + np.cumsum(np.ones(size_k+1 - nz1 - nz2 - nz3 - nz4) * 200.0)  
    
    # Bottom padding layer with logarithmic spacing  
    zPad = np.logspace(np.log10(zBlock5[-1]), np.log10(z*multiply_z), size_b)  
    
    # Combine all depth positions  
    zn0 = np.concatenate((zBlock1, zBlock2, zBlock3, zBlock4, zBlock5))  # Remove 0 to avoid duplication  
    zn = np.concatenate((z_air, zn0, zPad))  # Add 0 back at the ground surface  

    # Horizontal positions  
    yn0 = np.linspace(-(y-100), y-100, size_k+1)  
    # Horizontal padding with logarithmic spacing  
    y_l = -(np.logspace(np.log10(multiply_y*y), np.log10(y), size_b+1))[:-1]  
    y_r = np.logspace(np.log10(y), np.log10(multiply_y*y), size_b+1)[1:]  
    yn = np.concatenate((y_l, yn0, y_r))  

    # Initialize model array  
    len_z = size_b+size_k+nza  
    len_y = 2*size_b+size_k  
    model = np.ones((n_sample,len_z,len_y))*(-2)  

    # Model parameters  
    sig_up, sig_down = -4, 0  # conductivity range: 10^[-4, 0]  
    mode = 'bound'  
    set_1 = sig_up  
    set_2 = sig_down  

    # Generate random models  
    for ii in range(n_sample):  
        model0 = 0.0  
        model1 = 0.0  

        # Generate and combine multiple gaussian random fields  
        for alpha in alpha_l:  
            model_temp0 = gr.gaussian_random_field(alpha = alpha, size = size_k,  
                                       mode=mode, set_1=set_1, set_2=set_2)  
            model0 += model_temp0  
            
        # Normalize and scale the combined field  
        min0 = np.min(model_temp0)  
        max0 = np.max(model_temp0)  
        model0 = gaussian_filter(model0, sigma=2)/len(alpha_l)  
        min1 = np.min(model0)  
        max1 = np.max(model0)  
        model0 = (model0-min1)*((max0-min0)/(max1-min1))+min0  

        # Assign values to different regions of the model  
        model[ii,nza:-size_b,size_b:-size_b] = model0  # kernel domain  
        model[ii,nza:-size_b,:size_b]  = model0[:,0:1]*np.ones((size_k,size_b))  # left padding  
        model[ii,nza:-size_b,-size_b:] = model0[:,-1:]*np.ones((size_k,size_b))  # right padding  
        model[ii,-size_b:,:]           = model[ii,-size_b-1:-size_b,:]*np.ones((size_b,size_k+2*size_b))  # bottom padding  
       
    # Set air layer conductivity  
    model[:,:nza,:] = -9   
    # Convert log conductivity to conductivity  
    model = 10**model  
    # Extract kernel domain  
    model_k = model[:,nza:-size_b,size_b:-size_b]  

    return zn, yn, freq, ry, model, zn0, yn0, model_k

def save_model(model_name0,zn, yn, freq, ry, sig_log, rhoxy, phsxy,zxy,rhoyx,phsyx,zyx):
    '''
    save data as electrical model and field 
    for field, save as matrix with size of (n_model, n_obs, n_freq)

    '''
    model_name = model_name0+'.mat'
    scio.savemat(model_name,{'zn':zn, 'yn':yn, 'freq':freq, 'obs':ry,'sig':sig_log,
                            'rhoxy':rhoxy, 'phsxy':phsxy,'zxy':zxy,
                            'rhoyx':rhoyx,'phsyx':phsyx,'zyx':zyx})

def func_remote(nza, zn, yn, freq, ry, sig,n_sample,mode="TETM",np_dtype = np.float64):
    n_freq = np.size(freq)
    n_ry   = len(ry)
    rhoxy = np.zeros((n_sample,n_freq,n_ry),dtype=np_dtype) 
    phsxy = np.zeros((n_sample,n_freq,n_ry),dtype=np_dtype)
    rhoyx = np.zeros((n_sample,n_freq,n_ry),dtype=np_dtype)
    phsyx = np.zeros((n_sample,n_freq,n_ry),dtype=np_dtype)
    zxy   = np.zeros((n_sample,n_freq,n_ry),dtype=complex)
    zyx   = np.zeros((n_sample,n_freq,n_ry),dtype=complex)

    # rhoxy, phsxy,Zxy,rhoyx,phsyx,Zyx  = model.mt2d("TETM")
    result = []
    for ii in range(n_sample):
        model = MT2DFD.remote(nza, zn, yn, freq, ry, sig[ii,:,:])
        result.append(model.mt2d.remote(mode))

    temp0 = ray.get(result)
    for ii in range(len(temp0)):
        temp = temp0[ii]
        # log10(rho)
        rhoxy[ii,:,:], phsxy[ii,:,:],zxy[ii,:,:],rhoyx[ii,:,:],phsyx[ii,:,:],zyx[ii,:,:]  =\
            temp[0],temp[1],temp[2],temp[3],temp[4],temp[5]
    
    # print("remote computation finished !")
    return rhoxy, phsxy,zxy,rhoyx,phsyx,zyx

def main(n_sample,num_cpus,model_name):
    np_dtype = np.float64
    nza = 10 # number of air layer
    n_freq = 32 # number of frequency
    size_k = 64
    size_o = 41
    alpha_l = [3.0,4.0,5.0,6.0,7.0]

    zn, yn, freq, ry, sig, zn0, yn0, sig_k\
             = generate_model(alpha_l,n_sample,nza,n_freq,size_k, size_o) 

    time0 = default_timer()

    ray.init()


    # skin depth 
    alpha0 = 1 # 1 times of skin depth
    skin_depth = 0.503*alpha0*np.sqrt(1.0/np.mean(sig_k)/freq[0]) # km
    print(f"skin depth is {skin_depth}km")
    skin_depth = 0.503*alpha0*np.sqrt(1.0/np.mean(sig_k)/freq[-1]) # km
    print(f"skin depth is {skin_depth}km")


    k = int(n_sample/num_cpus)
    n_sample = int(k*num_cpus)

    n_ry = len(ry)
    rhoxy = np.ones((n_sample,n_freq,n_ry),dtype=np_dtype) 
    phsxy = np.ones((n_sample,n_freq,n_ry),dtype=np_dtype)
    rhoyx = np.ones((n_sample,n_freq,n_ry),dtype=np_dtype)
    phsyx = np.ones((n_sample,n_freq,n_ry),dtype=np_dtype)
    zxy   = np.ones((n_sample,n_freq,n_ry),dtype=complex)
    zyx   = np.ones((n_sample,n_freq,n_ry),dtype=complex)
    for ii in range(k):
        rhoxy[num_cpus*ii:num_cpus*(ii+1),:,:], phsxy[num_cpus*ii:num_cpus*(ii+1),:,:],zxy[num_cpus*ii:num_cpus*(ii+1),:,:],\
            rhoyx[num_cpus*ii:num_cpus*(ii+1),:,:],phsyx[num_cpus*ii:num_cpus*(ii+1),:,:],zyx[num_cpus*ii:num_cpus*(ii+1),:,:]  = \
            func_remote(nza, zn, yn, freq, ry, sig[num_cpus*ii:num_cpus*(ii+1),:,:],n_sample=num_cpus,mode="TETM")
        print(f"{ii} of {k} finished!")

        rhoxy0 = np.log10(rhoxy)
        rhoyx0 = np.log10(rhoyx)
        # notice: keep the same number of sig and rho,phs
        sig_k0 = np.log10(sig_k[:n_sample,:,:])

        save_model(model_name,zn0, yn0, freq, ry, sig_k0, rhoxy0, phsxy,zxy,rhoyx0,phsyx,zyx)

    time1 = default_timer()
    # rhoxy, phsxy,Zxy, rhoyx, phsyx,Zyx  = model.mt2d("TETM")
    # save_model(filename,resis, rhoxy, phsxy, rhoyx, phsyx)
    print(f"time using: {time1-time0}s")

    # print("calculate coarse grid")
    ray.shutdown()

if __name__ == "__main__":
    try:# run in command line
        n_sample = int(sys.argv[1]) # number of random model
        num_cpus = int(sys.argv[2])
        model_name = '../data/'+sys.argv[3]
    except:# debug in vscode
        print("debug mode, no input")
        n_sample = 2 # number of random model
        num_cpus = 1
        model_name = '../data/test'
    main(n_sample,num_cpus,model_name)