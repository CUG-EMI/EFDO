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
gmt begin Figure8 pdf,png

    gmt makecpt -Cthermal.cpt -T0/4.0/0.01 -Z -H > rbow.cpt
    gmt grdconvert model2501_coreRangeGrids.grd out.grd
    gmt grdedit out.grd -R$range_yz -Gresult.nc
    gmt basemap -Bxa2f1+l"Y-Distance (km)" -Bya1f1+l"Z-Depth (km)" -BWStr -R$range_yz -JX10c/-5c 
    gmt grdimage -R$range_yz -JX10c/-5c result.nc -Crbow.cpt
    
    gmt set FONT_ANNOT_PRIMARY 14p
    gmt set FONT_LABEL 14p
    gmt colorbar -R$range_yz -Crbow.cpt -DjTC+w5c/0.3c+o5.5c/0.0c+v -N -Bxaf+l"Log@-10@-(@~W\267@~m)" -By -FONT_ANNOT_PRIMARY=15p

    # plot prediction
    gmt set FONT_ANNOT_PRIMARY 8p FONT_LABEL 8p MAP_FRAME_PEN 1p FONT_TITLE 12p

    function preset()
    {
        ymin=-6150
        ymax=6150
        zmin=-2.419355
        zmax=3
        scale=1000
        ymin=`echo $ymin  $scale | awk '{print ($1/$2)}'`
        ymax=`echo $ymax  $scale | awk '{print ($1/$2)}'`
        echo $ymin $ymax $zmin $zmax
        range_yz=$ymin/$ymax/$zmin/$zmax
    }

    preset

    # UFNO Rxy
    gmt makecpt -Cthermal.cpt -T0/4/0.1 -Z -H > rbow.cpt
    gmt xyz2grd UFNO_real_xy.txt -R$range_yz -I0.3/0.77419 -Gtmp.grd 
    gmt basemap -R$range_yz -JX5c/3c -Bxf1 -Bya1f1+l"Log@-10@-(Frequency) [Hz]" -BWStr -X-3.5c -Y-5.3c
    gmt grdimage tmp.grd -Crbow.cpt -R$range_yz -JX5c/3c 
    # In shell GMT, text cannot be placed outside the basemap without manually adjusting the plot range
    echo -3 0.3 '(a) UFNO R@-xy@-' | gmt pstext -F+f12p,Helvetica -R$range_yz -JX5c/3c
 
    gmt xyz2grd UFNO_predict_xy.txt -R$range_yz -I0.3/0.77419 -Gtmp.grd
    gmt basemap -R$range_yz -JX5c/3c -Bxf1 -Byf1 -BWStr+t"Predict" -X5.25c
    gmt grdimage tmp.grd -Crbow.cpt -R$range_yz -JX5c/3c 
    gmt set FONT_ANNOT_PRIMARY 16p FONT_LABEL 16p
    gmt colorbar -R$range_yz -Crbow.cpt -DjBL+w3c/0.25c+o5.6c/0c+v+ma -Bxaf0.2+l"Log@-10@-(R@-xy@-) [@~\127\267@~m]" -By
    
    gmt set FONT_ANNOT_PRIMARY 8p FONT_LABEL 8p
    gmt makecpt -Cthermal.cpt -T0/20/0.1 -Z -H > rbow.cpt
    gmt xyz2grd UFNO_error_xy.txt -R$range_yz -I0.3/0.77419 -Gtmp.grd
    gmt basemap -R$range_yz -JX5c/3c -Bxf1 -Byf1 -BWStr+t"Relative error [%]" -X6.65c
    gmt grdimage tmp.grd -Crbow.cpt -R$range_yz -JX5c/3c 
    gmt set FONT_ANNOT_PRIMARY 16p FONT_LABEL 16p
    gmt colorbar -R$range_yz -Crbow.cpt -DjBL+w3c/0.25c+o5.6c/0c+v+ma -Bxa5f1+l"Relative error [%]" -By

    # UFNO Ryx
    gmt set FONT_ANNOT_PRIMARY 8p FONT_LABEL 8p
    gmt makecpt -Cthermal.cpt -T0/4/0.1 -Z -H > rbow.cpt
    gmt xyz2grd UFNO_real_yx.txt -R$range_yz -I0.3/0.77419 -Gtmp.grd 
    gmt basemap -R$range_yz -JX5c/3c -Bxf1 -Bya1f1+l"Log@-10@-(Frequency) [Hz]" -BWStr -X-11.9c -Y-3.5c
    gmt grdimage tmp.grd -Crbow.cpt -R$range_yz -JX5c/3c 
    echo -3 0.3 '(b) UFNO R@-yx@-' | gmt text -F+f12p,Helvetica -R$range_yz -JX5c/3c

    gmt xyz2grd UFNO_predict_yx.txt -R$range_yz -I0.3/0.77419 -Gtmp.grd
    gmt basemap -R$range_yz -JX5c/3c -Bxf1 -Byf1 -BWStr -X5.25c
    gmt grdimage tmp.grd -Crbow.cpt -R$range_yz -JX5c/3c 
    gmt set FONT_ANNOT_PRIMARY 16p FONT_LABEL 16p
    gmt colorbar -R$range_yz -Crbow.cpt -DjBL+w3c/0.25c+o5.6c/0c+v+ma -Bxaf0.2+l"Log@-10@-(R@-xy@-) [@~\127\267@~m]" -By
    
    gmt set FONT_ANNOT_PRIMARY 8p FONT_LABEL 8p
    gmt makecpt -Cthermal.cpt -T0/20/0.1 -Z -H > rbow.cpt
    gmt xyz2grd UFNO_error_yx.txt -R$range_yz -I0.3/0.77419 -Gtmp.grd
    gmt basemap -R$range_yz -JX5c/3c -Bxf1 -Byf1 -BWS -X6.65c
    gmt grdimage tmp.grd -Crbow.cpt -R$range_yz -JX5c/3c 
    gmt set FONT_ANNOT_PRIMARY 16p FONT_LABEL 16p
    gmt colorbar -R$range_yz -Crbow.cpt -DjBL+w3c/0.25c+o5.6c/0c+v+ma -Bxa5f1+l"Relative error [%]" -By

    # EFDO Rxy
    gmt set FONT_ANNOT_PRIMARY 8p FONT_LABEL 8p
    gmt makecpt -Cthermal.cpt -T0/4/0.1 -Z -H > rbow.cpt
    gmt xyz2grd EFDO_real_xy.txt -R$range_yz -I0.3/0.77419 -Gtmp.grd 
    gmt basemap -R$range_yz -JX5c/3c -Bxf1 -Bya1f1+l"Log@-10@-(Frequency) [Hz]" -BWStr -X-11.9c -Y-3.5c
    gmt grdimage tmp.grd -Crbow.cpt -R$range_yz -JX5c/3c 
    echo -3 0.3 '(c) EFDO R@-xy@-' | gmt text -F+f12p,Helvetica -R$range_yz -JX5c/3c

    gmt xyz2grd EFDO_predict_xy.txt -R$range_yz -I0.3/0.77419 -Gtmp.grd
    gmt basemap -R$range_yz -JX5c/3c -Bxf1 -Byf1 -BWStr -X5.25c
    gmt grdimage tmp.grd -Crbow.cpt -R$range_yz -JX5c/3c 
    gmt set FONT_ANNOT_PRIMARY 16p FONT_LABEL 16p
    gmt colorbar -R$range_yz -Crbow.cpt -DjBL+w3c/0.25c+o5.6c/0c+v+ma -Bxaf0.2+l"Log@-10@-(R@-xy@-) [@~\127\267@~m]" -By
    
    gmt set FONT_ANNOT_PRIMARY 8p FONT_LABEL 8p
    gmt makecpt -Cthermal.cpt -T0/20/0.1 -Z -H > rbow.cpt
    gmt xyz2grd EFDO_error_xy.txt -R$range_yz -I0.3/0.77419 -Gtmp.grd
    gmt basemap -R$range_yz -JX5c/3c -Bxf1 -Byf1 -BWStr -X6.65c
    gmt grdimage tmp.grd -Crbow.cpt -R$range_yz -JX5c/3c 

    gmt set FONT_ANNOT_PRIMARY 16p FONT_LABEL 16p
    gmt colorbar -R$range_yz -Crbow.cpt -DjBL+w3c/0.25c+o5.6c/0c+v+ma -Bxa5f1+l"Relative error [%]" -By

    # EFDO Ryx
    gmt set FONT_ANNOT_PRIMARY 8p FONT_LABEL 8p
    gmt makecpt -Cthermal.cpt -T0/4/0.1 -Z -H > rbow.cpt
    gmt xyz2grd EFDO_real_yx.txt -R$range_yz -I0.3/0.77419 -Gtmp.grd 
    gmt basemap -R$range_yz -JX5c/3c -Bxf1 -Bya1f1+l"Log@-10@-(Frequency) [Hz]" -BWStr -X-11.9c -Y-3.5c
    gmt grdimage tmp.grd -Crbow.cpt -R$range_yz -JX5c/3c 
    echo -3 0.3 '(d) EFDO R@-yx@-' | gmt text -F+f12p,Helvetica -R$range_yz -JX5c/3c

    gmt xyz2grd EFDO_predict_yx.txt -R$range_yz -I0.3/0.77419 -Gtmp.grd
    gmt basemap -R$range_yz -JX5c/3c -Bxf1 -Byf1 -BWStr -X5.25c
    gmt grdimage tmp.grd -Crbow.cpt -R$range_yz -JX5c/3c 
    gmt set FONT_ANNOT_PRIMARY 16p FONT_LABEL 16p
    gmt colorbar -R$range_yz -Crbow.cpt -DjBL+w3c/0.25c+o5.6c/0c+v+ma -Bxaf0.2+l"Log@-10@-(R@-xy@-) [@~\127\267@~m]" -By
    
    gmt set FONT_ANNOT_PRIMARY 8p FONT_LABEL 8p
    gmt makecpt -Cthermal.cpt -T0/20/0.1 -Z -H > rbow.cpt
    gmt xyz2grd EFDO_error_yx.txt -R$range_yz -I0.3/0.77419 -Gtmp.grd
    gmt basemap -R$range_yz -JX5c/3c -Bxf1 -Byf1 -BWStr -X6.65c
    gmt grdimage tmp.grd -Crbow.cpt -R$range_yz -JX5c/3c 
    gmt set FONT_ANNOT_PRIMARY 16p FONT_LABEL 16p
    gmt colorbar -R$range_yz -Crbow.cpt -DjBL+w3c/0.25c+o5.6c/0c+v+ma -Bxa5f1+l"Relative error [%]" -By

    # EFNO Rxy
    gmt set FONT_ANNOT_PRIMARY 8p FONT_LABEL 8p
    gmt makecpt -Cthermal.cpt -T0/4/0.1 -Z -H > rbow.cpt
    gmt xyz2grd EFNO_real_xy.txt -R$range_yz -I0.3/0.77419 -Gtmp.grd 
    gmt basemap -R$range_yz -JX5c/3c -Bxf1 -Bya1f1+l"Log@-10@-(Frequency) [Hz]" -BWStr -X-11.9c -Y-3.5c
    gmt grdimage tmp.grd -Crbow.cpt -R$range_yz -JX5c/3c 
    echo -3 0.3 '(e) EFNO R@-xy@-' | gmt text -F+f12p,Helvetica -R$range_yz -JX5c/3c

    gmt xyz2grd EFNO_predict_xy.txt -R$range_yz -I0.3/0.77419 -Gtmp.grd
    gmt basemap -R$range_yz -JX5c/3c -Bxf1 -Byf1 -BWStr -X5.25c
    gmt grdimage tmp.grd -Crbow.cpt -R$range_yz -JX5c/3c 
    gmt set FONT_ANNOT_PRIMARY 16p FONT_LABEL 16p
    gmt colorbar -R$range_yz -Crbow.cpt -DjBL+w3c/0.25c+o5.6c/0c+v+ma -Bxaf0.2+l"Log@-10@-(R@-xy@-) [@~\127\267@~m]" -By
    
    gmt set FONT_ANNOT_PRIMARY 8p FONT_LABEL 8p
    gmt makecpt -Cthermal.cpt -T0/20/0.1 -Z -H > rbow.cpt 
    gmt xyz2grd EFNO_error_xy.txt -R$range_yz -I0.3/0.77419 -Gtmp.grd
    gmt basemap -R$range_yz -JX5c/3c -Bxf1 -Byf1 -BWStr -X6.65c
    gmt grdimage tmp.grd -Crbow.cpt -R$range_yz -JX5c/3c
    gmt set FONT_ANNOT_PRIMARY 16p FONT_LABEL 16p
    gmt colorbar -R$range_yz -Crbow.cpt -DjBL+w3c/0.25c+o5.6c/0c+v+ma -Bxa5f1+l"Relative error [%]" -By

    # EFNO Ryx
    gmt set FONT_ANNOT_PRIMARY 8p FONT_LABEL 8p
    gmt makecpt -Cthermal.cpt -T0/4/0.1 -Z -H > rbow.cpt
    gmt xyz2grd EFNO_real_yx.txt -R$range_yz -I0.3/0.77419 -Gtmp.grd 
    gmt basemap -R$range_yz -JX5c/3c -Bxa2f1+l"Y-Distance [km]" -Bya1f1+l"Log@-10@-(Frequency) [Hz]" -BWStr -X-11.9c -Y-3.5c
    gmt grdimage tmp.grd -Crbow.cpt -R$range_yz -JX5c/3c 
    echo -3 0.3 '(f) EFNO R@-yx@-' | gmt text -F+f12p,Helvetica -R$range_yz -JX5c/3c

    gmt xyz2grd EFNO_predict_yx.txt -R$range_yz -I0.3/0.77419 -Gtmp.grd
    gmt basemap -R$range_yz -JX5c/3c -Bxa2f1+l"Y-Distance [km]" -Byf1 -BWStr -X5.25c
    gmt grdimage tmp.grd -Crbow.cpt -R$range_yz -JX5c/3c 
    gmt set FONT_ANNOT_PRIMARY 16p FONT_LABEL 16p
    gmt colorbar -R$range_yz -Crbow.cpt -DjBL+w3c/0.25c+o5.6c/0c+v+ma -Bxaf0.2+l"Log@-10@-(R@-xy@-) [@~\127\267@~m]" -By
    
    gmt set FONT_ANNOT_PRIMARY 8p FONT_LABEL 8p
    gmt makecpt -Cthermal.cpt -T0/20/0.1 -Z -H > rbow.cpt
    gmt xyz2grd EFNO_error_yx.txt -R$range_yz -I0.3/0.77419 -Gtmp.grd
    gmt basemap -R$range_yz -JX5c/3c -Bxa2f1+l"Y-Distance [km]" -Byf1 -BWStr -X6.65c
    gmt grdimage tmp.grd -Crbow.cpt -R$range_yz -JX5c/3c 
    gmt set FONT_ANNOT_PRIMARY 16p FONT_LABEL 16p
    gmt colorbar -R$range_yz -Crbow.cpt -DjBL+w3c/0.25c+o5.6c/0c+v+ma -Bxa5f1+l"Relative error [%]" -By


gmt end