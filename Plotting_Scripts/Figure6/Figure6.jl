using GMT

# change the scale of the default cooridinates
function preset()
    xmin = -6400
    xmax = 6400
    ymin = 0
    ymax = 6000
    scale = 1000
    xmin = xmin / scale
    xmax = xmax / scale
    ymin = ymin / scale
    ymax = ymax / scale

    println("$xmin $xmax $ymin $ymax")
    range_xy = "$xmin/$xmax/$ymin/$ymax"
    return range_xy
end

range_xy = preset()

gmtbegin("Figure6_jl", fmt="pdf,png")
    C = makecpt("-Cthermal.cpt -T0/4/0.1 -Z > rbow.cpt")
    subplot(grid="2x3", panels_size=(8,4), margins="3p") # `autolabel=true or 1` do the automatic labeling
        
        # Figure (a)
        data1 = grdedit("alpha_1.grd", region=range_xy) # change cooridinates scale
        basemap!(region=range_xy, figsize=(8, -4), frame=(axes=:WStr,),
        xaxis=(annot=2, ticks=1), 
        yaxis=(annot=1, label=:"Z-Depth [km]"),
        par=(MAP_FRAME_PEN="1p,black",),panel=(1,1))
        grdimage!(data1, region=range_xy, figsize=(8, -4), cmap="rbow.cpt", panel=(1,1)) 
        text!(["(a) @~\141@~=3.0"], font=12, x=-0.05, y=5.5)

        # Figure (b)
        data2 = grdedit("alpha_2.grd", region=range_xy) # change cooridinates scale
        basemap!(region=range_xy, figsize=(8, -4), frame=(axes=:WStr,),
        xaxis=(annot=2, ticks=1), yaxis=(annot=1),
        par=(MAP_FRAME_PEN="1p,black",), panel=(1,2)) 
        grdimage!(data2, region=range_xy, figsize=(8, -4), cmap="rbow.cpt", panel=(1,2)) 
        text!(["(b) @~\141@~=4.0"], font=12, x=-0.05, y=5.5)

        # Figure (c)
        data3 = grdedit("alpha_3.grd", region=range_xy) # change cooridinates scale
        basemap!(region=range_xy, figsize=(8, -4), frame=(axes=:WStr,),
        xaxis=(annot=2, ticks=1), yaxis=(annot=1),
        par=(MAP_FRAME_PEN="1p,black",), panel=(1,3)) 
        grdimage!(data3, region=range_xy, figsize=(8, -4), cmap="rbow.cpt", panel=(1,3)) 
        text!(["(c) @~\141@~=5.0"], font=12, x=-0.05, y=5.5)

        # Figure (d)
        data4 = grdedit("alpha_4.grd", region=range_xy) # change cooridinates scale
        basemap!(region=range_xy, figsize=(8, -4), frame=(axes=:WStr,),
        xaxis=(annot=2, ticks=1, label=:"Y-Distance [km]"), 
        yaxis=(annot=1, label=:"Z-Depth [km]"),
        par=(MAP_FRAME_PEN="1p,black",), panel=(2,1)) 
        grdimage!(data4, region=range_xy, figsize=(8, -4), cmap="rbow.cpt", panel=(2,1)) 
        text!(["(d) @~\141@~=6.0"], font=12, x=-0.05, y=5.5)

        # Figure (e)
        data5 = grdedit("alpha_5.grd", region=range_xy) # change cooridinates scale
        basemap!(region=range_xy, figsize=(8, -4), frame=(axes=:WStr,),
        xaxis=(annot=2, ticks=1, label=:"Y-Distance [km]"), 
        yaxis=(annot=1),
        par=(MAP_FRAME_PEN="1p,black",), panel=(2,2)) 
        grdimage!(data5, region=range_xy, figsize=(8, -4), cmap="rbow.cpt", panel=(2,2)) 
        text!(["(e) @~\141@~=7.0"], font=12, x=-0.05, y=5.5)
        
        colorbar!(xaxis=(annot=1, ticks=0.2), pos=(paper=true, anchor=(1,2), size=(6.2,0.5), horizontal=true, triangles=true), par=(MAP_FRAME_PEN="1p,black",), panel=(2,3))
        text!(["Log@-10@-[@~W\267@~m]"], font=12, x=0, y=4.3)

    subplot()
gmtend()

