#!/bin/bash
#SBATCH -J EFNO
#SBATCH -p debug

#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 2400:2400:00

python EFNO_main.py EFNO_config > EFNO_running_info.txt

