#!/bin/bash
#SBATCH -J UFNO3d
#SBATCH -p debug

#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 2400:2400:00

python UFNO3d_main.py UFNO3d_config > UFNO_running_info.txt

