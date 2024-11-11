using GMT

function preset()
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
    range_yz = string(ymin, "/", ymax, "/", zmin, "/", zmax)
    return range_yz
end

range_yz = preset()

gmtbegin("Figure11_jl", fmt="pdf,png")

	# Create a color palette
	C = makecpt("-Cthermal.cpt -T-0.0/4/0.1 -Z > rbow.cpt")

	# Figure (a)
	data1 = grdedit("model_1.grd", region=range_yz)
	basemap!(region=range_yz, figsize=(12, -6), frame=(axes=:WStr,),
			 xaxis=(annot=2, ticks=1, label=:"Y-Distance [km]"), 
             yaxis=(annot=1, ticks=1, label=:"Z-Depth [km]"),
			 par=(FONT_ANNOT_PRIMARY=12, FONT_LABEL=12, MAP_FRAME_PEN="1.5p,black",)
			) 
	grdimage!(data1, region=range_yz, figsize=(12, -6), cmap="rbow.cpt")
	text!(["(a)"], font=16, x=-5.9, y=0.4)

	# Figure (b)
	data2 = grdedit("model_2.grd", region=range_yz)
	basemap!(region=range_yz, figsize=(12, -6), frame=(axes=:wStr,),
			 xaxis=(annot=2, ticks=1, label=:"Y-Distance [km]"), 
             yaxis=(ticks=1),
			 par=(FONT_ANNOT_PRIMARY=12, FONT_LABEL=12,MAP_FRAME_PEN="1.5p,black",),
			 xshift=13
			) 
	grdimage!(data2, region=range_yz, figsize=(12, -6), cmap="rbow.cpt")
    boxline = [-2.0 0.1;-2.0 2.0;6.3 2.0;6.3 0.1;-2.0 0.1]
	plot!(boxline, pen="1.3p,red", close=true)
	text!(["(b)"], font=16, x=-5.9, y=0.4)

	# Adding the colorbar
	gmtset(FONT_ANNOT_PRIMARY = "14p,Helvetica,black", FONT_LABEL = "14p,black")
	colorbar!(xaxis=(annot=:auto, ticks=0.2, label=:"Log@-10@-[@~W\267@~m]", ), 
			  pos=(paper=true, anchor=(-4.5,-2.5), size=(8,0.5), horizontal=true,
			  move_annot=:l, triangles=true))
    rm("rbow.cpt")
gmtend()
