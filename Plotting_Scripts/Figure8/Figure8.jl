using GMT

# change the scale of the default cooridinates
function preset1()
    ymin, ymax = -6.4, 6.4
    zmin, zmax = 0, 6
    println("$ymin $ymax $zmin $zmax")
    rnage_yz = "$ymin/$ymax/$zmin/$zmax"

    return rnage_yz
end

function preset2()
    xmin = -6150
    xmax = 6150
    ymin = -2.419355
    ymax = 3
    scale = 1000
    xmin = xmin / scale
    xmax = xmax / scale

    println("$xmin $xmax $ymin $ymax")
    range_xy = "$xmin/$xmax/$ymin/$ymax"
    return range_xy
end

range_yz = preset1()
range_xy = preset2()
include("plot_figure.jl")

gmtbegin("Figure8_jl", fmt="pdf,png")

    ## reference model 
    C = makecpt("-Cthermal.cpt -T0/4/0.1 -Z > rbow.cpt")
    basemap(region=range_yz, figsize=(10, -5), frame=(axes=:WStr,),
    xaxis=(annot=2, ticks=1, label=:"Y-Distance [km]"), # 
    yaxis=(annot=2, ticks=1, label=:"Z-Depth [km]"),
    par=(FONT_ANNOT="10p,Helvetica,black", FONT_LABEL="12p,Helvetica,black",
    MAP_FRAME_PEN="0.8p,black",
    ))
    grdimage!("model2501.grd", region=range_yz, figsize=(10, -5), cmap="rbow.cpt") 

    T = text_record([0 0], ["(I) True model"])
    text!(T, noclip=true, font=16, angle=0, offset=(-13.5,-0.1))
    colorbar!(xaxis=(annot=1, ticks=0.2), pos=(outside=true, anchor=:MR, size=(4.8,0.25), offset=(0.6,0), move_annot=:a, triangles = true), xlabel="Log@-10@-(R@-xy@-) [@~\127\267@~m]",  par=(FONT_ANNOT="12p,Helvetica,black", MAP_FRAME_PEN="0.5p,black",))
    
    ## UFNO Rxy mode
    info1 = "(a) UFNO R@-xy@-"
    fileName1 = "UFNO_real_xy.txt"
    fileName2 = "UFNO_predict_xy.txt"
    fileName3 = "UFNO_error_xy.txt"
    plot_figure1(range_xy, info1, fileName1, fileName2, fileName3)
    T = text_record([0 0], ["(II) Comparison"])
    text!(T, noclip=true, font=16, angle=0, offset=(-19.3,2.4))

    ## UFNO Ryx mode
    info1 = "(b) UFNO R@-yx@-"
    fileName1 = "UFNO_real_yx.txt"
    fileName2 = "UFNO_predict_yx.txt"
    fileName3 = "UFNO_error_yx.txt"
    plot_figure2(range_xy, info1, fileName1, fileName2, fileName3)

    ## EFDO Rxy mode
    info1 = "(c) EFDO R@-xy@-"
    fileName1 = "EFDO_real_xy.txt"
    fileName2 = "EFDO_predict_xy.txt"
    fileName3 = "EFDO_error_xy.txt"
    plot_figure2(range_xy, info1, fileName1, fileName2, fileName3)

    ## EFDO Ryx mode
    info1 = "(d) EFDO R@-yx@-"
    fileName1 = "EFDO_real_yx.txt"
    fileName2 = "EFDO_predict_yx.txt"
    fileName3 = "EFDO_error_yx.txt"
    plot_figure2(range_xy, info1, fileName1, fileName2, fileName3)

    ## EFNO Rxy mode
    info1 = "(e) EFNO R@-xy@-"
    fileName1 = "EFNO_real_xy.txt"
    fileName2 = "EFNO_predict_xy.txt"
    fileName3 = "EFNO_error_xy.txt"
    plot_figure2(range_xy, info1, fileName1, fileName2, fileName3)

    ## EFNO Ryx mode
    info1 = "(f) EFNO R@-yx@-"
    fileName1 = "EFNO_real_yx.txt"
    fileName2 = "EFNO_predict_yx.txt"
    fileName3 = "EFNO_error_yx.txt"
    plot_figure3(range_xy, info1, fileName1, fileName2, fileName3)

    rm("test1.grd")
    rm("test2.grd")
    rm("test3.grd")

gmtend()