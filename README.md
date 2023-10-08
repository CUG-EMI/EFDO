# Extended Fourier DeepONet Neural Operator Network

## Hardware requirements
- NVIDIA GPU with compute capability >= 6.0
- At least 16GB of GPU memory, 24GB is recommended
- At least 64GB of system memory, 256GB is recommended
- At least 50GB of free disk space, 512GB is recommended

## Software requirements
- Ubuntu >= 18.04 LTS (or Windows >= 10 or WSL2 with Ubuntu >= 18.04 LTS)
- Python >= 3.7
- PyTorch >= 1.8.0
- torchinfo
- yaml
- numpy
- scipy
- matplotlib
- jupyter notebook


## Installation
> We recommend using `Anaconda` to manage the python environment, and `Mamba` is recommended for faster installation of packages. And the following commands are based on `Anaconda` and `Mamba`.

- First, you can download the `Mamba` package via the following link: [Mamba download page](https://github.com/conda-forge/miniforge#mambaforge), you should choose the right version according to your system. We recommand you to download the `Mambaforge` package, which is a minimal conda distribution that includes `Mamba` and `conda`. After downloading, you can install it via the following command:
```bash
bash Miniforge3-Linux-x86_64.sh -b -p ${HOME}/mambaforge
``` 

- Then, add the `Mamba` and `conda` to the `PATH` via the following command:
```bash
vim ~/.bashrc ## add the following commands to the end of the file

# conda
if [ -f "${HOME}/mambaforge/etc/profile.d/conda.sh" ]; then
    source "${HOME}/mambaforge/etc/profile.d/conda.sh"
fi
# mamba
if [ -f "${HOME}/mambaforge/etc/profile.d/mamba.sh" ]; then
    source "${HOME}/mambaforge/etc/profile.d/mamba.sh"
fi
```

- Then, you can alias the `conda` command to `mamba` via the following command:
```bash
vim ~/.bashrc ## add the following commands to the end of the file

alias conda=mamba
```

- Then, you can create a new environment via the following command:
```bash
conda create -n <env_name> python=3.8
```

- Then, you can activate the environment via the following command:
```bash
conda activate <env_name>
```

- Then, you can install the `PyTorch` package via the following command:
```bash
conda install pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia
```

- Then, you can install the `torchinfo`, `yaml`,  `numpy`... packages via the following command:
```bash
conda install torchinfo pyyaml numpy scipy matplotlib ray jupyter notebook
```

- Until now, you have installed all the packages needed for this project. Then, you can clone this project via the following command:
```bash
git clone https://github.com/CUG-EMI/EFDO
```

## Dataset generation
- You can directly use the `EFNO` network's python code in `genData` directory to parallelly generate the dataset via the following command:
```bash
python model_gen.py 100 50 train_gen
```
In this command, the first parameter `100` is the number of the generated datasets, the second parameter `50` is the number of parallel processes, and the third parameter `train_gen` is the filename of  the generated datasets. You can modify these parameters according to your needs. And the generated datasets will be saved in the `data` directory.

- Or you can use the julia code we provide in `genData` directory to generate the dataset via the following command:
```bash
julia juliaCallGRF.jl
```
In this command, the generated datasets will be saved in the `data` directory. But it is worth noting that the julia code only generates the gaussian random field models, and you need to calculate the forwrad modeling results using other forward modeling codes. In this paper, we use our own `MT2D` julia forward modeling code to calculate the forward modeling results. And the forward modeling code is not open source.

> Because the julia code also calls the python code, you need to install the `PyCall` package in julia. And give the path of the python environment to julia via the following command:
```bash
ENV["PYTHON"] = "Path of the python environment"
using Pkg
Pkg.build("PyCall")
```

## Network training usage

> We take the EFDO network execution as an example to introduce the usage of this open-source code.

- First, you should enter the `code` directory and open the `config_EFDO.yaml` file, and modify the `data_dir` and `save_dir` to the right path. And there are some configuration parameters in the `config_EFDO.yaml` file, you can modify them according to your needs. Meanwhile, there are two groups of configuration parameters in the `config_EFDO.yaml` file, the first group is `EFDO_config`, and the second group is `EFDO_config2`. You can add some comfiguration groups according to your needs.

- Then, you can run the `EFDO` network via the following command:
```bash
python EFDO_main.py EFDO_config
```

- At the same way, you can run the `EFNO` network via the following command:
```bash
python EFNO_main.py EFNO_config
```

- At the same way, you can run the `UFNO3d` network via the following command:
```bash
python UFNO3d_main.py UFNO3d_config 
```

- If you want run these networks in computing nodes, we also provides some `slurm` scripts in the `code` directory with the file appendix `*.slurm`. You can modify the slurm scripts according to your needs, and then you can submit your jobs in the computing nodes.

- Meanwhile, we also provide some `jupyter notebook` files in the `code` directory with the file appendix `*.ipynb`. You can run these `jupyter notebook` files to visualize the results of these networks. Some key results are shown in these `jupyter notebook` files.


