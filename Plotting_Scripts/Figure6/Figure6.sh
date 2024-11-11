#!/usr/bin/env bash
function preset()
{
    xmin=-6400
    xmax=6400
    ymin=0
    ymax=6000
    scale=1000
    xmin=`echo $xmin  $scale | awk '{print ($1/$2)}'`
    xmax=`echo $xmax  $scale | awk '{print ($1/$2)}'`
    ymin=`echo $ymin  $scale | awk '{print ($1/$2)}'`
    ymax=`echo $ymax  $scale | awk '{print ($1/$2)}'`

    echo $xmin $xmax $ymin $ymax
    range_xy=$xmin/$xmax/$ymin/$ymax
}
preset

gmt set FONT_ANNOT_PRIMARY 10p
gmt set FONT_LABEL 12p
gmt set MAP_FRAME_PEN 0.5p

gmt begin Figure6 png,pdf

    gmt makecpt -Cthermal.cpt -T0/4.0/0.1 -Z -H > rbow.cpt

    gmt subplot begin 2x3 -Fs8c/4c

        gmt subplot set 0,0
        gmt grdconvert alpha_1.grd out.grd
        gmt grdedit out.grd -R$range_xy -Gresult.nc
        gmt basemap -Bxa2f1 -Bya1f1+l"Z-Depth [km]" -BWStr -R$range_xy -JX8c/-4c 
        gmt grdimage -R$range_xy -JX8c/-4c result.nc -Crbow.cpt
        echo -0.05 5.5 '(a)' "@~\141@~"=3.0 | gmt text -F+f14p,Helvetica -JX8c/-4c -R$range_xy
        
        gmt subplot set 0,1
        gmt grdconvert alpha_2.grd out.grd
        gmt grdedit out.grd -R$range_xy -Gresult.nc
        gmt basemap -Bxa2f1 -Bya1f1 -BWStr -R$range_xy -JX8c/-4c 
        gmt grdimage -R$range_xy -JX8c/-4c result.nc -Crbow.cpt
        echo -0.05 5.5 '(b)' "@~\141@~"=4.0 | gmt text -F+f14p,Helvetica -JX8c/-4c -R$range_xy

        gmt subplot set 0,2
        gmt grdconvert alpha_3.grd out.grd
        gmt grdedit out.grd -R$range_xy -Gresult.nc
        gmt basemap -Bxa2f1+l"Y-Distance [km]" -Bya1f1 -BWStr -R$range_xy -JX8c/-4c 
        gmt grdimage -R$range_xy -JX8c/-4c result.nc -Crbow.cpt
        echo -0.05 5.5 '(c)' "@~\141@~"=5.0 | gmt text -F+f14p,Helvetica -JX8c/-4c -R$range_xy

        gmt subplot set 1,0
        gmt grdconvert alpha_4.grd out.grd
        gmt grdedit out.grd -R$range_xy -Gresult.nc
        gmt basemap -Bxa2f1+l"Y-Distance [km]" -Bya1f1+l"Z-Depth [km]" -BWStr -R$range_xy -JX8c/-4c 
        gmt grdimage -R$range_xy -JX8c/-4c result.nc -Crbow.cpt
        echo -0.05 5.5 '(d)' "@~\141@~"=6.0 | gmt text -F+f14p,Helvetica -JX8c/-4c -R$range_xy

        gmt subplot set 1,1
        gmt grdconvert alpha_5.grd out.grd
        gmt grdedit out.grd -R$range_xy -Gresult.nc
        gmt basemap -Bxa2f1+l"Y-Distance [km]" -Bya1f1 -BWStr -R$range_xy -JX8c/-4c 
        gmt grdimage -R$range_xy -JX8c/-4c result.nc -Crbow.cpt
        echo -0.05 5.5 '(e)' "@~\141@~"=7.0 | gmt text -F+f14p,Helvetica -JX8c/-4c -R$range_xy

        gmt subplot set 1,2 
        gmt colorbar -R$range_xy -Crbow.cpt -DjTC+w6c/0.5c+o0.0c/2.0c+ml+e -N -Bxaf+l"Log@-10@-[@~W\267@~m]" -By

    gmt subplot end    

gmt end