#!/usr/bin/env bash
function preset1()
{
    ymin=-100000
    ymax=100000
    zmin=-50000
    zmax=50000
    scale=1000
    ymin=`echo $ymin  $scale | awk '{print ($1/$2)}'`
    ymax=`echo $ymax  $scale | awk '{print ($1/$2)}'`
    zmin=`echo $zmin  $scale | awk '{print ($1/$2)}'`
    zmax=`echo $zmax  $scale | awk '{print ($1/$2)}'`
    echo $ymin $ymax $zmin $zmax
    range_yz1=$ymin/$ymax/$zmin/$zmax
}
preset1

gmt set FONT_ANNOT_PRIMARY 12p
gmt set FONT_LABEL 14p
gmt set MAP_FRAME_PEN 1p,black

# x=0 slice 
gmt begin Figure5 pdf,png
gmt makecpt -Cthermal.cpt -T0/4.0/0.01 -Z -H > rbow.cpt
gmt grdconvert wholeRangeGrids.grd out.grd
gmt grdedit out.grd -R$range_yz1 -Gresult.nc

gmt basemap -Bxa20f10+l"Y-Distance [km]" -Bya10f5+l"Z-Depth [km]" -BWStr -R$range_yz1 -JX12c/-6c
gmt grdimage -R$range_yz1 -JX12c/-6c result.nc -Crbow.cpt 

# y grid lines
gmt plot -Wfaint,white line_y.txt -Frs

# z grid lines
gmt plot -Wfaint,white line_z.txt -Frs

# the core region
gmt plot  -W0.8p <<EOF
-6.4 0
-6.4 6.0
6.4 6.0
6.4 0
-6.4 0
EOF

gmt text -F+f16p,Helvetica << EOF
-93 43 (a) 
EOF

function preset2()
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
    range_yz2=$ymin/$ymax/$zmin/$zmax
}
preset2
gmt grdconvert coreRangeGrids.grd out.grd
gmt grdedit out.grd -R$range_yz2 -Gresult.nc
gmt basemap -Bxa2f1+l"Y-Distance [km]" -Bya1f1+l"Z-Depth [km]" -BWStr -R$range_yz2 -JX12c/-6c -X14
gmt grdimage -R$range_yz2 -JX12c/-6c result.nc -Crbow.cpt 

gmt text -F+f16p,Helvetica << EOF
-5.95 5.55 (b) 
EOF

gmt colorbar -R$range_yz1 -Crbow.cpt -DjTC+w8c/0.5c+o-7.0c/8.0c+ml+e -N -Bxaf+l"Log@-10@-[@~W\267@~m]" -By -FONT_ANNOT_PRIMARY=15p

rm out.grd rbow.cpt *.nc

gmt end