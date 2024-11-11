#!/usr/bin/env bash

# Set GMT configuration for fonts and frame pen
gmt set FONT_ANNOT_PRIMARY 8p FONT_LABEL 10p MAP_FRAME_PEN 0.6p

gmt begin Figure10 pdf,png
    # Basemap for R²
    gmt basemap -R0/33/0.70/1.01 -JX8c/6c -Bxa4+l"Frequency index" -Bya0.05+l"@R@+2@+@" -BWStr

    ## UFNO
    gmt plot ${dir_path}UFNO_r2.txt -W0.6p,red,-
    gmt plot ${dir_path}UFNO_r2.txt -Sc0.15c -W0.2p,red
    gmt plot ${dir_path}UFNO_r2_train.txt -Sc0.15c -Gred

    ## EFDO
    gmt plot ${dir_path}EFDO_r2.txt -W0.6p,blue,-
    gmt plot ${dir_path}EFDO_r2.txt -Sc0.15c -W0.2p,blue
    gmt plot ${dir_path}EFDO_r2_train.txt -Sc0.15c -Gblue

    ## EFNO
    gmt plot ${dir_path}EFNO_r2.txt -W0.6p,green1,-
    gmt plot ${dir_path}EFNO_r2.txt -Sc0.15c -W0.2p,green1
    gmt plot ${dir_path}EFNO_r2_train.txt -Sc0.15c -Ggreen1

    # Legend
    ## UFNO
    echo S 0.4c c 0.15c red 0.25p,red 0.8c UFNO trained frequencies >> legend.txt
    echo G -1l >> legend.txt
    echo S 0.4c - 0.5c red 0.25p,red,-- >> legend.txt

    echo S 0.4c c 0.15c - 0.25p,red 0.8c UFNO untrained frequencies >> legend.txt
    echo G -1l >> legend.txt
    echo S 0.4c - 0.5c red 0.25p,red,-- >> legend.txt

    ## EFDO
    echo S 0.4c c 0.15c blue 0.25p,blue 0.8c EFDO trained frequencies >> legend.txt
    echo G -1l >> legend.txt
    echo S 0.4c - 0.5c blue 0.25p,blue,--  >> legend.txt

    echo S 0.4c c 0.15c - 0.25p,blue 0.8c EFDO untrained frequencies >> legend.txt
    echo G -1l >> legend.txt
    echo S 0.4c - 0.5c blue 0.25p,blue,-- >> legend.txt

    ## EFNO
    echo S 0.4c c 0.15c green1 0.25p,green1 0.8c EFNO trained frequencies >> legend.txt
    echo G -1l >> legend.txt
    echo S 0.4c - 0.5c green1 0.25p,green1,-- >> legend.txt

    echo S 0.4c c 0.15c - 0.25p,green1 0.8c EFNO untrained frequencies >> legend.txt
    echo G -1l >> legend.txt
    echo  S 0.4c - 0.5c green1 0.25p,green1,-- >> legend.txt

    ## Legend
    gmt legend legend.txt -DJBL+jBL+o0.05c/0.05c -F+gwhite


    # Basemap for RMSE
    gmt basemap -R0/33/0/0.5 -JX8c/6c -Bxa4+l"Frequency index" -Bya0.05+l"RMSE" -BWStr -X9.5c

    ## UFNO
    gmt plot ${dir_path}UFNO_rmse.txt -W0.6p,red,-
    gmt plot ${dir_path}UFNO_rmse.txt -Sc0.15c -W0.2p,red
    gmt plot ${dir_path}UFNO_rmse_train.txt -Sc0.15c -Gred

    ## EFDO
    gmt plot ${dir_path}EFDO_rmse.txt -W0.6p,blue,-
    gmt plot ${dir_path}EFDO_rmse.txt -Sc0.15c -W0.2p,blue
    gmt plot ${dir_path}EFDO_rmse_train.txt -Sc0.15c -Gblue

    ## EFNO
    gmt plot ${dir_path}EFNO_rmse.txt -W0.6p,green1,-
    gmt plot ${dir_path}EFNO_rmse.txt -Sc0.15c -W0.2p,green1
    gmt plot ${dir_path}EFNO_rmse_train.txt -Sc0.15c -Ggreen1

    ## Legend
    gmt legend legend.txt -DJTL+jTL+o0.05c/0.05c -F+gwhite
    
    ## remove legend.txt
    rm legend.txt

gmt end
