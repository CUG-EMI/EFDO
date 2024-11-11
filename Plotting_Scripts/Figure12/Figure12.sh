#!/usr/bin/env bash

# Set GMT configuration for fonts and frame pen
gmt set FONT_ANNOT_PRIMARY 8p FONT_LABEL 10p MAP_FRAME_PEN 0.6p
gmt set MAP_GRID_PEN 0p,gray,-

gmt begin Figure12 pdf,png
    # Basemap for R²
    gmt basemap -R0/30000/0/250 -JX8c/6c -Bxa5000g5000+l"Sample size" -Bya50g50+l"Each epoch time comsumption (s)" -BWStr

    gmt plot time.txt -W0.4p,red,-
    gmt plot time.txt -Sc0.15c -Gred

    # Legend
    echo S 0.4c c 0.15c red 0.25p,red 0.8c Training time >> legend.txt
    echo G -1l >> legend.txt
    echo S 0.4c - 0.5c red 0.25p,red,--  >> legend.txt

    ## Legend
    gmt legend legend.txt -DJTL+jTL+o0.2c/0.2c -F+p0.3,black+gwhite
    rm legend.txt
    

    # Basemap for RMSE
    gmt basemap -R0/30000/0.001/0.1 -JX8c/6cl -Bxa5000g5000+l"Sample size" -Bya0.1f3g3p+l"Relative error" -BWStr -X9.5c

    ## UFNO
    gmt plot error.txt -W0.6p,blue,-
    gmt plot error.txt -Sc0.15c -Gblue

    echo S 0.4c c 0.15c blue 0.25p,blue 0.8c Training error >> legend.txt
    echo G -1l >> legend.txt
    echo S 0.4c - 0.5c blue 0.25p,blue,--  >> legend.txt

    ## Legend
    gmt legend legend.txt -DJTL+jTL+o0.2c/0.2c -F+p0.3,black+gwhite
    
    ## remove legend.txt
    rm legend.txt

gmt end

