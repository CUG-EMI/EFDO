'''
modified from code of Bruno Sciolla, https://github.com/bsciolla/gaussian-random-fields
'''

# Main dependencies
import numpy as np
import scipy.fftpack


def fftind(size):
    """ Returns a numpy array of shifted Fourier coordinates k_x k_y.
        
        Input args:
            size (integer): The size of the coordinate array to create
        Returns:
            k_ind, numpy array of shape (2, size, size) with:
                k_ind[0,:,:]:  k_x components
                k_ind[1,:,:]:  k_y components
                
        Example:
        
            print(fftind(5))
            
            [[[ 0  1 -3 -2 -1]
            [ 0  1 -3 -2 -1]
            [ 0  1 -3 -2 -1]
            [ 0  1 -3 -2 -1]
            [ 0  1 -3 -2 -1]]

            [[ 0  0  0  0  0]
            [ 1  1  1  1  1]
            [-3 -3 -3 -3 -3]
            [-2 -2 -2 -2 -2]
            [-1 -1 -1 -1 -1]]]
            
        """
    k_ind = np.mgrid[:size, :size] - int( (size + 1)/2 )
    k_ind = scipy.fftpack.fftshift(k_ind)
    return( k_ind )



# return numpy.ndarray of shape (size, size),
def gaussian_random_field(alpha = 3.0,# smooth factor
                          size = 128, # size of the field
                          mode = 'random',# 'random' or bound
                          set_1 = 0.0, # if 'random', mean; else if 'bound', lower bound
                          set_2 = 1.0):# if 'random', standard derivation; else if 'bound', upper bound
    """ Returns a numpy array of shifted Fourier coordinates k_x k_y.
        
        Input args:
            alpha (double, default = 3.0): 
                The power of the power-law momentum distribution
            size (integer, default = 128):
                The size of the square output Gaussian Random Fields
            flag_normalize (boolean, default = True):
                Normalizes the Gaussian Field:
                    - to have an average of 0.0
                    - to have a standard deviation of 1.0

        Returns:
            gfield (numpy array of shape (size, size)):
                The random gaussian random field
                
        Example:
        import matplotlib
        import matplotlib.pyplot as plt
        example = gaussian_random_field()
        plt.imshow(example)
        """
        
        # Defines momentum indices
    k_idx = fftind(size)

        # Defines the amplitude as a power law 1/|k|^(alpha/2)
    amplitude = np.power( k_idx[0]**2 + k_idx[1]**2 + 1e-10, -alpha/4.0 )
    amplitude[0,0] = 0
    
        # Draws a complex gaussian random noise with normal
        # (circular) distribution
    noise = np.random.normal(size = (size, size)) \
        + 1j * np.random.normal(size = (size, size))
    
        # To real space
    gfield = np.fft.ifft2(noise * amplitude).real
    
        # Sets the standard deviation to one
    gfield = gfield - np.mean(gfield)
    gfield = gfield/np.std(gfield)
    if mode == 'random':
        set_mean = set_1
        set_std  = set_2
        gfield = gfield * set_std
        gfield = gfield + set_mean
    elif mode == 'bound':
        set_lower = set_1
        set_upper = set_2
        g_max = np.max(gfield)
        g_min = np.min(gfield)
        gfield = (set_upper-set_lower)/(g_max - g_min) * gfield + \
                (set_lower*g_max - set_upper*g_min)/(g_max - g_min)
    else:
          raise KeyError("mode must be 'random' or 'bound")   
    return gfield




def main():
    import matplotlib
    import matplotlib.pyplot as plt
    example = gaussian_random_field()
    plt.imshow(example, cmap='gray')
    plt.show()
    
if __name__ == '__main__':
    main()


