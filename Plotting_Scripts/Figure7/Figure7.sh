#!/usr/bin/env bash
gmt begin Figure7 pdf,png

    gmt set MAP_GRID_PEN 0.05p,DARKGRAY
    gmt set FONT_ANNOT_PRIMARY 10p,Helvetica,black
    gmt set FONT_LABEL 14p,Helvetica,black
    gmt set MAP_FRAME_PEN 0.6p,black
    
    gmt basemap -R0/500/0.001/1 -JX10c/7cl -Bxa100+l"Epoch" -Bya1f3p+l"Relative loss" -BWStr

    # U-FNO
    echo S 0.2c - 0.4c 0/83/156 0.6p,0/83/156 0.6c U-FNO train >> temp.dat
    echo S 0.2c - 0.4c 65/105/225 1.3p,65/105/225,. 0.6c U-FNO val >> temp.dat
    echo S 0.2c - 0.4c 30/144/255 0.4p,30/144/255,-- 0.6c U-FNO test >> temp.dat

    # EFDO
    echo S 0.2c - 0.4c 178/34/34 0.6p,178/34/34 0.6c EFDO train >> temp.dat
    echo S 0.2c - 0.4c 220/20/60 1.3p,220/20/60,. 0.6c EFDO val >> temp.dat
    echo S 0.2c - 0.4c 255/99/71 0.4p,255/99/71,-- 0.6c EFDO test >> temp.dat

    # EFNO
    echo S 0.2c - 0.4c 0/100/0 0.6p,0/100/0 0.6c EFNO train >> temp.dat
    echo S 0.2c - 0.4c 34/139/34 1.3p,34/139/34,. 0.6c EFNO val >> temp.dat
    echo S 0.2c - 0.4c 60/179/113 0.4p,60/179/113,-- 0.6c EFNO test >> temp.dat

    gmt set MAP_FRAME_PEN 0.3p,black
    gmt set FONT 7p,Helvetica,black
    gmt legend temp.dat -DjTR+w2.2c+o0.1c/0.1c -F+p0.3p+r0.1c+gwhite

    # U-FNO
    gmt plot data1_train.txt -W0.6p,0/83/156         
    gmt plot data1_val.txt -W1.3p,65/105/225,.        
    gmt plot data1_test.txt -W0.4p,30/144/255,--      

    # EFDO
    gmt plot data2_train.txt -W0.6p,178/34/34         
    gmt plot data2_val.txt -W1.3p,220/20/60,.         
    gmt plot data2_test.txt -W0.4p,255/99/71,--       

    # EFNO
    gmt plot data3_train.txt -W0.6p,0/100/0           
    gmt plot data3_val.txt -W1.3p,34/139/34,.         
    gmt plot data3_test.txt -W0.4p,60/179/113,--      

    rm temp.dat

gmt end