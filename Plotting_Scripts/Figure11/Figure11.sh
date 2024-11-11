#!/usr/bin/env bash

gmt set FONT_ANNOT_PRIMARY 10p
gmt set FONT_LABEL 12p

function preset()
{
    ymin=-6400
    ymax=6400
    zmin=0
    zmax=6000
    scale=1000
    ymin=`echo $ymin  $scale | awk '{print ($1/$2)}'`
    ymax=`echo $ymax  $scale | awk '{print ($1/$2)}'`
    zmin=`echo $zmin  $scale | awk '{print ($1/$2)}'`
    zmax=`echo $zmax  $scale | awk '{print ($1/$2)}'`
    echo $ymin $ymax $zmin $zmax
    range_yz=$ymin/$ymax/$zmin/$zmax
}
preset

# x=0 slice 
gmt begin Figure11 pdf,png

    gmt set FONT_ANNOT_PRIMARY 12p
    gmt set FONT_LABEL 12p

    gmt makecpt -Cthermal.cpt -T0/4.0/0.01 -Z -H > rbow.cpt
    gmt grdconvert model_1.grd out.grd
    gmt grdedit out.grd -R$range_yz -Gresult.nc
    gmt grdimage -Bxa2f1+l"Y-Distance [km]" -Bya1f1+l"Z-Depth [km]" -BWStr -R$range_yz -JX12c/-6c result.nc -Crbow.cpt

    gmt text -F+f16p,Helvetica << EOF
-5.9 0.4 (a) 
EOF


    # # plot prediction
    # gmt set FONT_ANNOT_PRIMARY 8p FONT_LABEL 8p MAP_FRAME_PEN 0.3p FONT_TITLE 12p

    gmt grdconvert model_2.grd out.grd
    gmt grdedit out.grd -R$range_yz -Gresult.nc
    gmt grdimage -Bxa2f1+l"Y-Distance [km]" -Bya1f1 -BwStr -R$range_yz -JX12c/-6c result.nc -Crbow.cpt -X13

    gmt text -F+f16p,Helvetica << EOF
-5.9 0.4 (b) 
EOF

    gmt plot -W1.3p,red  << EOF
-2.0 0.1
-2.0 2.0
6.3 2.0
6.3 0.1
-2.0 0.1
EOF


    gmt colorbar -R$range_yz -Crbow.cpt -DjTC+w8c/0.5c+o-6.5c/7.5c+ml+e -N -Bxaf+l"Log@-10@-[@~W\267@~m]" -By -FONT_ANNOT_PRIMARY=15p

    rm out.grd result.nc gmt.conf rbow.cpt

gmt end