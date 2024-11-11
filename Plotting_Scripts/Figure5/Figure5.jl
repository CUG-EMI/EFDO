using GMT

function preset1()
    ymin = -100000
    ymax = 100000
    zmin = -50000
    zmax = 50000
    scale = 1000
    ymin /= scale
    ymax /= scale
    zmin /= scale
    zmax /= scale
    println("$ymin $ymax $zmin $zmax")
    range_yz = string(ymin, "/", ymax, "/", zmin, "/", zmax)
    return range_yz
end

function preset2()
    ymin = -6400
    ymax = 6400
    zmin = 0
    zmax = 6000
    scale = 1000
    ymin /= scale
    ymax /= scale
    zmin /= scale
    zmax /= scale
    println("$ymin $ymax $zmin $zmax")
    range_yz1 = string(ymin, "/", ymax, "/", zmin, "/", zmax)
    return range_yz1
end

range_yz1 = preset1()
range_yz2 = preset2()

gmtbegin("Figure5_jl", fmt="pdf,png")

	# Create a color palette
	C = makecpt("-Cthermal.cpt -T0/4/0.1 -Z > rbow.cpt")

	# Figure (a)
	data1 = grdedit("wholeRangeGrids.grd", region=range_yz1)
	basemap!(region=range_yz1, figsize=(12, -6), frame=(axes=:WStr,),
			 xaxis=(annot=20, ticks=10, label=:"Y-Distance [km]"), 
             yaxis=(annot=10, ticks=5, label=:"Z-Depth [km]"),
			 par=(FONT_ANNOT_PRIMARY=12, FONT_LABEL=14, MAP_FRAME_PEN="1p,black",)
			) 
	grdimage!(data1, region=range_yz1, figsize=(12, -6), cmap="rbow.cpt")
	plot!("line_y.txt", pen=(0.1, :White))
	plot!("line_z.txt", pen=(0.1, :White))
	boxline = [-6.4 0;-6.4 6.0;6.4 6.0;6.4 0;-6.4 0]
	plot!(boxline, pen="0.8p", close=true)
	text!(["(a)"], font=16, x=-93, y=43)

	# Figure (b)
	data2 = grdedit("coreRangeGrids.grd", region=range_yz2)
	basemap!(region=range_yz2, figsize=(12, -6), frame=(axes=:WStr,),
			 xaxis=(annot=2, ticks=1, label=:"Y-Distance [km]"), 
             yaxis=(annot=1, ticks=1, label=:"Z-Depth [km]"),
			 par=(FONT_ANNOT_PRIMARY=12, FONT_LABEL=14,MAP_FRAME_PEN="1p,black",),
			 xshift=14
			) 
	grdimage!(data2, region=range_yz2, figsize=(12, -6), cmap="rbow.cpt")
	text!(["(b)"], font=16, x=-5.95, y=5.55)

	# Adding the colorbar
	gmtset(FONT_ANNOT_PRIMARY = "14p,Helvetica,black", FONT_LABEL = "14p,black")
	colorbar!(xaxis=(annot=1, ticks=0.2, label=:"Log@-10@-[@~W\267@~m]"), 
			  pos=(paper=true, anchor=(-5,-2.5), size=(8,0.5), horizontal=true,
			  move_annot=:l, triangles=true))

gmtend()



