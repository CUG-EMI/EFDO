function plot_figure1(range_xy, info, fileName1, fileName2, fileName3)

    ## Rxy reference
    C = makecpt("-Cthermal.cpt -T0/4/0.1 -Z > rbow.cpt")
    xyz2grd(fileName1, region=range_xy, inc=(0.3, 0.77419), outgrid="test1.grd")
    basemap(
    region=range_xy, figsize=(5, 3),
    frame=(axes=:WStr,),
    xaxis=(ticks=1, ), # label=:"Y-Distance [km]"
    yaxis=(annot=1, ticks=3, label=:"Log@-10@-(Frequency) [Hz]"),
    title="Reference",
    par=(
    FONT_ANNOT="8p,Helvetica,black",
    FONT_LABEL="8p,Helvetica,black",
    MAP_GRID_PEN="0p,gray,-",
    MAP_FRAME_PEN="1.0p,black",
    FONT_TITLE="16p,Helvetica,black",
    ),
    xshift=-3.5,
    yshift=-5.3,
    )
    grdimage!("test1.grd", region=range_xy, figsize=(5, 3), cmap="rbow.cpt", ) 
    T = text_record([-12 0], [info])
    text(T, noclip=true, font=12, offset=(-0.3,0))

    # Rxy predict
    xyz2grd(fileName2, region=range_xy, inc=(0.3, 0.77419), outgrid="test2.grd")
    basemap!(
    region=range_xy, figsize=(5, 3),
    frame=(axes=:WStr,),
    xaxis=(ticks=1, ), # label=:"Y-Distance [km]"
    yaxis=(ticks=1, ),
    title="Predict",
    par=(
    FONT_ANNOT="8p,Helvetica,black",
    FONT_LABEL="8p,Helvetica,black",
    MAP_GRID_PEN="0p,gray,-",
    MAP_FRAME_PEN="1.0p,black",
    FONT_TITLE="16p,Helvetica,black",
    ),
    xshift = 5.25
    )
    grdimage!("test2.grd", region=range_xy, figsize=(5, 3), cmap="rbow.cpt",)

    colorbar!(xaxis=(annot=1, ticks=0.2), pos=(anchor=:ML, size=(3,0.25), offset=(-5.95,0)), par=(FONT_ANNOT="12p,Helvetica,black", MAP_FRAME_PEN="0.5p,black",))
    T = text_record([9.15 0.2], ["Log@-10@-(R@-xy@-) [@~\127\267@~m]"])
    text(T, noclip=true, font=9, angle=90, offset=(0,0))

    # Rxy error
    C = makecpt("-Cthermal.cpt -T0/20/0.1 -Z > rbow.cpt")
    xyz2grd(fileName3, region=range_xy, inc=(0.3, 0.77419), outgrid="test3.grd")
    basemap!(
    region=range_xy, figsize=(5, 3),
    frame=(axes=:WStr,),
    xaxis=(ticks=1, ), # label=:"Y-Distance [km]"
    yaxis=(ticks=1,),
    title="Relative error [%]",
    par=(
    FONT_ANNOT="8p,Helvetica,black",
    FONT_LABEL="8p,Helvetica,black",
    MAP_GRID_PEN="0p,gray,-",
    MAP_FRAME_PEN="1.0p,black",
    FONT_TITLE="14p,Helvetica,black",
    ),
    xshift = 6.65
    )
    grdimage!("test3.grd", region=range_xy, figsize=(5, 3), cmap="rbow.cpt",) 
    colorbar!(xaxis=(annot=5, ticks=1), pos=(anchor=:ML, size=(3,0.25), offset=(-6.05,0)), par=(FONT_ANNOT="12p,Helvetica,black",  MAP_FRAME_PEN="0.5p,black",))
    T = text_record([9.5 0.3], ["Relative error [%]"])
    text(T, noclip=true, font=9, angle=90, offset=(0,0))

end

function plot_figure2(range_xy, info, fileName1, fileName2, fileName3)

    ## Rxy reference
    C = makecpt("-Cthermal.cpt -T0/4/0.1 -Z > rbow.cpt")
    xyz2grd(fileName1, region=range_xy, inc=(0.3, 0.77419), outgrid="test1.grd")
    basemap(
    region=range_xy, figsize=(5, 3),
    frame=(axes=:WStr,),
    xaxis=(ticks=1, ), # label=:"Y-Distance [km]"
    yaxis=(annot=1, ticks=3, label=:"Log@-10@-(Frequency) [Hz]"),
    par=(
    FONT_ANNOT="8p,Helvetica,black",
    FONT_LABEL="8p,Helvetica,black",
    MAP_GRID_PEN="0p,gray,-",
    MAP_FRAME_PEN="1.0p,black",
    ),
    xshift = -11.9,
    yshift = -3.25
    )
    grdimage!("test1.grd", region=range_xy, figsize=(5, 3), cmap="rbow.cpt",) 
    T = text_record([-12 0], [info])
    text(T, noclip=true, font=12, offset=(-0.3,0))

    # Rxy predict
    xyz2grd(fileName2, region=range_xy, inc=(0.3, 0.77419), outgrid="test2.grd")
    basemap!(
    region=range_xy, figsize=(5, 3),
    frame=(axes=:WStr,),
    xaxis=(ticks=1, ), # label=:"Y-Distance [km]"
    yaxis=(ticks=1, ),
    par=(
    FONT_ANNOT="8p,Helvetica,black",
    FONT_LABEL="8p,Helvetica,black",
    MAP_GRID_PEN="0p,gray,-",
    MAP_FRAME_PEN="1.0p,black",
    ),
    xshift = 5.25)
    grdimage!("test2.grd", region=range_xy, figsize=(5, 3), cmap="rbow.cpt")

    colorbar!(xaxis=(annot=1, ticks=0.2), pos=(anchor=:ML, size=(3,0.25), offset=(-5.95,0)), par=(FONT_ANNOT="12p,Helvetica,black", MAP_FRAME_PEN="0.5p,black",))
    T = text_record([9.15 0.2], ["Log@-10@-(R@-xy@-) [@~\127\267@~m]"])
    text(T, noclip=true, font=9, angle=90, offset=(0,0))

    # Rxy error
    C = makecpt("-Cthermal.cpt -T0/20/0.1 -Z > rbow.cpt")
    xyz2grd(fileName3, region=range_xy, inc=(0.3, 0.77419), outgrid="test3.grd")
    basemap!(
    region=range_xy, figsize=(5, 3),
    frame=(axes=:WStr,),
    xaxis=(ticks=1, ), # label=:"Y-Distance [km]"
    yaxis=(ticks=1,),
    par=(
    FONT_ANNOT="8p,Helvetica,black",
    FONT_LABEL="8p,Helvetica,black",
    MAP_GRID_PEN="0p,gray,-",
    MAP_FRAME_PEN="1.0p,black",
    ),
    xshift = 6.65
    )
    grdimage!("test3.grd", region=range_xy, figsize=(5, 3), cmap="rbow.cpt") 
    colorbar!(xaxis=(annot=5, ticks=1), pos=(anchor=:ML, size=(3,0.25), offset=(-6.05,0)), par=(FONT_ANNOT="12p,Helvetica,black",  MAP_FRAME_PEN="0.5p,black",))
    T = text_record([9.5 0.3], ["Relative error [%]"])
    text(T, noclip=true, font=9, angle=90, offset=(0,0))

end

function plot_figure3(range_xy, info, fileName1, fileName2, fileName3)

    ## Rxy reference
    C = makecpt("-Cthermal.cpt -T0/4/0.1 -Z > rbow.cpt")
    xyz2grd(fileName1, region=range_xy, inc=(0.3, 0.77419), outgrid="test1.grd")
    basemap(
    region=range_xy, figsize=(5, 3),
    frame=(axes=:WStr,),
    xaxis=(ticks=1, label=:"Y-Distance [km]"), # label=:"Y-Distance [km]"
    yaxis=(annot=1, ticks=3, label=:"Log@-10@-(Frequency) [Hz]"),
    par=(
    FONT_ANNOT="8p,Helvetica,black",
    FONT_LABEL="8p,Helvetica,black",
    MAP_GRID_PEN="0p,gray,-",
    MAP_FRAME_PEN="1.0p,black",
    ),
    xshift=-11.9,
    yshift=-3.25
    )
    grdimage!("test1.grd", region=range_xy, figsize=(5, 3), cmap="rbow.cpt") 
    T = text_record([-12 0], [info])
    text(T, noclip=true, font=12, offset=(-0.3,0))

    # Rxy predict
    xyz2grd(fileName2, region=range_xy, inc=(0.3, 0.77419), outgrid="test2.grd")
    basemap!(
    region=range_xy, figsize=(5, 3),
    frame=(axes=:WStr,),
    xaxis=(ticks=1, label=:"Y-Distance [km]"), # label=:"Y-Distance [km]"
    yaxis=(ticks=1, ),
    par=(
    FONT_ANNOT="8p,Helvetica,black",
    FONT_LABEL="8p,Helvetica,black",
    MAP_GRID_PEN="0p,gray,-",
    MAP_FRAME_PEN="1.0p,black",
    ),
    xshift = 5.25
    )
    grdimage!("test2.grd", region=range_xy, figsize=(5, 3), cmap="rbow.cpt")
    colorbar!(xaxis=(annot=1, ticks=0.2), pos=(anchor=:ML, size=(3,0.25), offset=(-5.95,0)), par=(FONT_ANNOT="12p,Helvetica,black", MAP_FRAME_PEN="0.5p,black",))
    T = text_record([9.15 0.2], ["Log@-10@-(R@-xy@-) [@~\127\267@~m]"])
    text(T, noclip=true, font=9, angle=90, offset=(0,0))

    # Rxy error
    C = makecpt("-Cthermal.cpt -T0/20/0.1 -Z > rbow.cpt")
    xyz2grd(fileName3, region=range_xy, inc=(0.3, 0.77419), outgrid="test3.grd")
    basemap!(
    region=range_xy, figsize=(5, 3),
    frame=(axes=:WStr,),
    xaxis=(ticks=1, label=:"Y-Distance [km]"), # label=:"Y-Distance [km]"
    yaxis=(ticks=1,),
    par=(
    FONT_ANNOT="8p,Helvetica,black",
    FONT_LABEL="8p,Helvetica,black",
    MAP_GRID_PEN="0p,gray,-",
    MAP_FRAME_PEN="1.0p,black",
    ),
    xshift = 6.65
    )
    grdimage!("test3.grd", region=range_xy, figsize=(5, 3), cmap="rbow.cpt") 
    colorbar!(xaxis=(annot=5, ticks=1), pos=(anchor=:ML, size=(3,0.25), offset=(-6.05,0)), par=(FONT_ANNOT="12p,Helvetica,black",  MAP_FRAME_PEN="0.5p,black",))
    T = text_record([9.5 0.3], ["Relative error [%]"])
    text(T, noclip=true, font=9, angle=90, offset=(0,0))

end