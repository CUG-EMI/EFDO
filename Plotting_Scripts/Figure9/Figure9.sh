#!/usr/bin/env bash
function preset1()
{
    ymin=-6300
    ymax=6300
    zmin=0
    zmax=2000
    scale=1000
    ymin=`echo $ymin  $scale | awk '{print ($1/$2)}'`
    ymax=`echo $ymax  $scale | awk '{print ($1/$2)}'`
    echo $ymin $ymax $zmin $zmax
    range_yz1=$ymin/$ymax/$zmin/$zmax
}
function preset2()
{
    ymin=-6300
    ymax=6300
    zmin=0
    zmax=20
    scale=1000
    ymin=`echo $ymin  $scale | awk '{print ($1/$2)}'`
    ymax=`echo $ymax  $scale | awk '{print ($1/$2)}'`
    echo $ymin $ymax $zmin $zmax
    range_yz2=$ymin/$ymax/$zmin/$zmax
}

preset1
preset2

gmt begin Figure9 pdf,png
    gmt set FONT_ANNOT_PRIMARY 8p FONT_LABEL 8p MAP_FRAME_PEN 0.3p FONT_TITLE 14p

    # UFNO 1000Hz
    gmt basemap -R$range_yz1 -JX5c/3c -Bxf1 -Bya500f100+l"Resistivity [@~W\267@~m]" -BWStr+t"Rxy"
    gmt plot UFNO_rhoxy_site_real_1.txt -R$range_yz1 -JX5c/3c -W0.6p,red 
    gmt plot UFNO_rhoxy_site_predict_1.txt -R$range_yz1 -JX5c/3c -W0.6p,0/83/156,..-
    echo "S 0.2c - 0.4c - 0.6p,red 0.5c Reference" >> legend.txt
    echo "S 0.2c - 0.4c - 0.6p,0/83/156,..- 0.5c Prediction" >> legend.txt
    gmt legend legend.txt -DJTL+jTL+o0.1/0.1 -F+gwhite+p0.25p
    # In shell GMT, text cannot be placed outside the basemap without manually adjusting the plot range
    echo -2.6 750 '(a) UFNO 1000 Hz' | gmt text -F+f9p,Helvetica -R$range_yz1 -JX5c/3c
    rm legend.txt

    gmt basemap -R$range_yz1 -JX5c/3c -Bxf1 -Byf100 -BWStr+t"Ryx" -X5.25c
    gmt plot UFNO_rhoyx_site_real_1.txt -R$range_yz1 -JX5c/3c -W0.6p,red 
    gmt plot UFNO_rhoyx_site_predict_1.txt -R$range_yz1 -JX5c/3c -W0.6p,0/83/156,..-
    echo "S 0.2c - 0.4c - 0.6p,red 0.5c Reference" >> legend.txt
    echo "S 0.2c - 0.4c - 0.6p,0/83/156,..- 0.5c Prediction" >> legend.txt
    gmt legend legend.txt -DJTL+jTL+o0.1/0.1 -F+gwhite+p0.25p
    rm legend.txt

    gmt basemap -R$range_yz2 -JX5c/3c -Bxf1 -Bya5f1+l"Relative Error [%]" -BWStr+t"Relative Error [%]" -X6c
    gmt plot UFNO_rhoxy_site_error_1.txt -R$range_yz2 -JX5c/3c -W0.6p,red 
    gmt plot UFNO_rhoyx_site_error_1.txt -R$range_yz2 -JX5c/3c -W0.6p,0/83/156,..-
    echo "S 0.2c - 0.4c - 0.6p,red 0.5c Rxy" >> legend.txt
    echo "S 0.2c - 0.4c - 0.6p,0/83/156,..- 0.5c Ryx" >> legend.txt
    gmt legend legend.txt -DJTR+jTR+o0.1/0.1 -F+gwhite+p0.25p
    rm legend.txt

    # UFNO 0.0038Hz
    gmt basemap -R$range_yz1 -JX5c/3c -Bxf1 -Bya500f100+l"Resistivity [@~W\267@~m]" -BWStr -X-11.25c -Y-3.25c
    gmt plot UFNO_rhoxy_site_real_end.txt -R$range_yz1 -JX5c/3c -W0.6p,red 
    gmt plot UFNO_rhoxy_site_predict_end.txt -R$range_yz1 -JX5c/3c -W0.6p,0/83/156,..-
    echo "S 0.2c - 0.4c - 0.6p,red 0.5c Reference" >> legend.txt
    echo "S 0.2c - 0.4c - 0.6p,0/83/156,..- 0.5c Prediction" >> legend.txt
    gmt legend legend.txt -DJTL+jTL+o0.1/0.1 -F+gwhite+p0.25p
    echo -2.6 750 '(b) UFNO 0.0038 Hz' | gmt text -F+f9p,Helvetica -R$range_yz1 -JX5c/3c
    rm legend.txt

    gmt basemap -R$range_yz1 -JX5c/3c -Bxf1 -Byf100 -BWStr -X5.25c
    gmt plot UFNO_rhoyx_site_real_end.txt -R$range_yz1 -JX5c/3c -W0.6p,red 
    gmt plot UFNO_rhoyx_site_predict_end.txt -R$range_yz1 -JX5c/3c -W0.6p,0/83/156,..-
    echo "S 0.2c - 0.4c - 0.6p,red 0.5c Reference" >> legend.txt
    echo "S 0.2c - 0.4c - 0.6p,0/83/156,..- 0.5c Prediction" >> legend.txt
    gmt legend legend.txt -DJTL+jTL+o0.1/0.1 -F+gwhite+p0.25p
    
    rm legend.txt

    gmt basemap -R$range_yz2 -JX5c/3c -Bxf1 -Bya5f1+l"Relative Error [%]" -BWStr -X6c
    gmt plot UFNO_rhoxy_site_error_end.txt -R$range_yz2 -JX5c/3c -W0.6p,red 
    gmt plot UFNO_rhoyx_site_error_end.txt -R$range_yz2 -JX5c/3c -W0.6p,0/83/156,..-
    echo "S 0.2c - 0.4c - 0.6p,red 0.5c Rxy" >> legend.txt
    echo "S 0.2c - 0.4c - 0.6p,0/83/156,..- 0.5c Ryx" >> legend.txt
    gmt legend legend.txt -DJTR+jTR+o0.1/0.1 -F+gwhite+p0.25p
    rm legend.txt

    # EFDO 1000Hz
    gmt basemap -R$range_yz1 -JX5c/3c -Bxf1 -Bya500f100+l"Resistivity [@~W\267@~m]" -BWStr -X-11.25c -Y-3.25c
    gmt plot EFDO_rhoxy_site_real_1.txt -R$range_yz1 -JX5c/3c -W0.6p,red 
    gmt plot EFDO_rhoxy_site_predict_1.txt -R$range_yz1 -JX5c/3c -W0.6p,0/83/156,..-
    echo "S 0.2c - 0.4c - 0.6p,red 0.5c Reference" >> legend.txt
    echo "S 0.2c - 0.4c - 0.6p,0/83/156,..- 0.5c Prediction" >> legend.txt
    gmt legend legend.txt -DJTL+jTL+o0.1/0.1 -F+gwhite+p0.25p
    echo -2.6 750 '(c) EFDO 1000 Hz' | gmt text -F+f9p,Helvetica -R$range_yz1 -JX5c/3c
    rm legend.txt

    gmt basemap -R$range_yz1 -JX5c/3c -Bxf1 -Byf100 -BWStr -X5.25c
    gmt plot EFDO_rhoyx_site_real_1.txt -R$range_yz1 -JX5c/3c -W0.6p,red 
    gmt plot EFDO_rhoyx_site_predict_1.txt -R$range_yz1 -JX5c/3c -W0.6p,0/83/156,..-
    echo "S 0.2c - 0.4c - 0.6p,red 0.5c Reference" >> legend.txt
    echo "S 0.2c - 0.4c - 0.6p,0/83/156,..- 0.5c Prediction" >> legend.txt
    gmt legend legend.txt -DJTL+jTL+o0.1/0.1 -F+gwhite+p0.25p
    rm legend.txt

    gmt basemap -R$range_yz2 -JX5c/3c -Bxf1 -Bya5f1+l"Relative Error [%]" -BWStr -X6c
    gmt plot EFDO_rhoxy_site_error_1.txt -R$range_yz2 -JX5c/3c -W0.6p,red 
    gmt plot EFDO_rhoyx_site_error_1.txt -R$range_yz2 -JX5c/3c -W0.6p,0/83/156,..-
    echo "S 0.2c - 0.4c - 0.6p,red 0.5c Rxy" >> legend.txt
    echo "S 0.2c - 0.4c - 0.6p,0/83/156,..- 0.5c Ryx" >> legend.txt
    gmt legend legend.txt -DJTR+jTR+o0.1/0.1 -F+gwhite+p0.25p
    rm legend.txt

    # EFDO 0.0038Hz
    gmt basemap -R$range_yz1 -JX5c/3c -Bxf1 -Bya500f100+l"Resistivity [@~W\267@~m]" -BWStr -X-11.25c -Y-3.25c
    gmt plot EFDO_rhoxy_site_real_end.txt -R$range_yz1 -JX5c/3c -W0.6p,red 
    gmt plot EFDO_rhoxy_site_predict_end.txt -R$range_yz1 -JX5c/3c -W0.6p,0/83/156,..-
    echo "S 0.2c - 0.4c - 0.6p,red 0.5c Reference" >> legend.txt
    echo "S 0.2c - 0.4c - 0.6p,0/83/156,..- 0.5c Prediction" >> legend.txt
    gmt legend legend.txt -DJTL+jTL+o0.1/0.1 -F+gwhite+p0.25p
    echo -2.6 750 '(d) EFDO 0.0038 Hz' | gmt text -F+f9p,Helvetica -R$range_yz1 -JX5c/3c
    rm legend.txt

    gmt basemap -R$range_yz1 -JX5c/3c -Bxf1 -Byf100 -BWStr -X5.25c
    gmt plot EFDO_rhoyx_site_real_end.txt -R$range_yz1 -JX5c/3c -W0.6p,red 
    gmt plot EFDO_rhoyx_site_predict_end.txt -R$range_yz1 -JX5c/3c -W0.6p,0/83/156,..-
    echo "S 0.2c - 0.4c - 0.6p,red 0.5c Reference" >> legend.txt
    echo "S 0.2c - 0.4c - 0.6p,0/83/156,..- 0.5c Prediction" >> legend.txt
    gmt legend legend.txt -DJTL+jTL+o0.1/0.1 -F+gwhite+p0.25p
    rm legend.txt

    gmt basemap -R$range_yz2 -JX5c/3c -Bxf1 -Bya5f1+l"Relative Error [%]" -BWStr -X6c
    gmt plot EFDO_rhoxy_site_error_end.txt -R$range_yz2 -JX5c/3c -W0.6p,red 
    gmt plot EFDO_rhoyx_site_error_end.txt -R$range_yz2 -JX5c/3c -W0.6p,0/83/156,..-
    echo "S 0.2c - 0.4c - 0.6p,red 0.5c Rxy" >> legend.txt
    echo "S 0.2c - 0.4c - 0.6p,0/83/156,..- 0.5c Ryx" >> legend.txt
    gmt legend legend.txt -DJTR+jTR+o0.1/0.1 -F+gwhite+p0.25p
    rm legend.txt

    # EFNO 1000Hz
    gmt basemap -R$range_yz1 -JX5c/3c -Bxf1 -Bya500f100+l"Resistivity [@~W\267@~m]" -BWStr -X-11.25c -Y-3.25c
    gmt plot EFNO_rhoxy_site_real_1.txt -R$range_yz1 -JX5c/3c -W0.6p,red 
    gmt plot EFNO_rhoxy_site_predict_1.txt -R$range_yz1 -JX5c/3c -W0.6p,0/83/156,..-
    echo "S 0.2c - 0.4c - 0.6p,red 0.5c Reference" >> legend.txt
    echo "S 0.2c - 0.4c - 0.6p,0/83/156,..- 0.5c Prediction" >> legend.txt
    gmt legend legend.txt -DJTL+jTL+o0.1/0.1 -F+gwhite+p0.25p
    echo -2.6 750 '(e) EFNO 1000 Hz' | gmt text -F+f9p,Helvetica -R$range_yz1 -JX5c/3c
    rm legend.txt

    gmt basemap -R$range_yz1 -JX5c/3c -Bxf1 -Byf100 -BWStr -X5.25c
    gmt plot EFNO_rhoyx_site_real_1.txt -R$range_yz1 -JX5c/3c -W0.6p,red 
    gmt plot EFNO_rhoyx_site_predict_1.txt -R$range_yz1 -JX5c/3c -W0.6p,0/83/156,..-
    echo "S 0.2c - 0.4c - 0.6p,red 0.5c Reference" >> legend.txt
    echo "S 0.2c - 0.4c - 0.6p,0/83/156,..- 0.5c Prediction" >> legend.txt
    gmt legend legend.txt -DJTL+jTL+o0.1/0.1 -F+gwhite+p0.25p
    rm legend.txt

    gmt basemap -R$range_yz2 -JX5c/3c -Bxf1 -Bya5f1+l"Relative Error [%]" -BWStr -X6c
    gmt plot EFNO_rhoxy_site_error_1.txt -R$range_yz2 -JX5c/3c -W0.6p,red 
    gmt plot EFNO_rhoyx_site_error_1.txt -R$range_yz2 -JX5c/3c -W0.6p,0/83/156,..-
    echo "S 0.2c - 0.4c - 0.6p,red 0.5c Rxy" >> legend.txt
    echo "S 0.2c - 0.4c - 0.6p,0/83/156,..- 0.5c Ryx" >> legend.txt
    gmt legend legend.txt -DJTR+jTR+o0.1/0.1 -F+gwhite+p0.25p
    rm legend.txt

    # EFNO 0.0038Hz
    gmt basemap -R$range_yz1 -JX5c/3c -Bxf1 -Bya500f100+l"Resistivity [@~W\267@~m]" -BWStr -X-11.25c -Y-3.25c
    gmt plot EFNO_rhoxy_site_real_end.txt -R$range_yz1 -JX5c/3c -W0.6p,red 
    gmt plot EFNO_rhoxy_site_predict_end.txt -R$range_yz1 -JX5c/3c -W0.6p,0/83/156,..-
    echo "S 0.2c - 0.4c - 0.6p,red 0.5c Reference" >> legend.txt
    echo "S 0.2c - 0.4c - 0.6p,0/83/156,..- 0.5c Prediction" >> legend.txt
    gmt legend legend.txt -DJTL+jTL+o0.1/0.1 -F+gwhite+p0.25p
    echo -2.6 750 '(f) EFNO 0.0038 Hz' | gmt text -F+f9p,Helvetica -R$range_yz1 -JX5c/3c
    rm legend.txt

    gmt basemap -R$range_yz1 -JX5c/3c -Bxf1 -Byf100 -BWStr -X5.25c
    gmt plot EFNO_rhoyx_site_real_end.txt -R$range_yz1 -JX5c/3c -W0.6p,red 
    gmt plot EFNO_rhoyx_site_predict_end.txt -R$range_yz1 -JX5c/3c -W0.6p,0/83/156,..-
    echo "S 0.2c - 0.4c - 0.6p,red 0.5c Reference" >> legend.txt
    echo "S 0.2c - 0.4c - 0.6p,0/83/156,..- 0.5c Prediction" >> legend.txt
    gmt legend legend.txt -DJTL+jTL+o0.1/0.1 -F+gwhite+p0.25p
    rm legend.txt

    gmt basemap -R$range_yz2 -JX5c/3c -Bxf1 -Bya5f1+l"Relative Error [%]" -BWStr -X6c
    gmt plot EFNO_rhoxy_site_error_end.txt -R$range_yz2 -JX5c/3c -W0.6p,red 
    gmt plot EFNO_rhoyx_site_error_end.txt -R$range_yz2 -JX5c/3c -W0.6p,0/83/156,..-
    echo "S 0.2c - 0.4c - 0.6p,red 0.5c Rxy" >> legend.txt
    echo "S 0.2c - 0.4c - 0.6p,0/83/156,..- 0.5c Ryx" >> legend.txt
    gmt legend legend.txt -DJTR+jTR+o0.1/0.1 -F+gwhite+p0.25p
    rm legend.txt

gmt end