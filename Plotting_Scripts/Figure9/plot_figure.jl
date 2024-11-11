function plot_function1(loc, rhoxy_predict, rhoxy_real, rhoyx_predict, rhoyx_real, info)

    basemap(
        region=[-6.3, 6.3, 0, 2000], figsize=(5, 3),
        frame=(axes=:WStr,),
        xaxis=(ticks=1, ),
        yaxis=(annot=500, ticks=100, label=:"Resistivity [@~W\267@~m]" ),
        title = "Rxy",
        par=(
            FONT_ANNOT_PRIMARY="6p,Helvetica,black",
            FONT_LABEL="8p,Helvetica,black",
            MAP_GRID_PEN="0p,gray,-",
            MAP_FRAME_PEN="0.5p,black",
            FONT_TITLE="16p,Helvetica,black",
        ),
    )

    predict1 = rhoxy_predict
    real1 = rhoxy_real
    err1 = abs.(predict1 .- real1) ./ real1 * 100

    plot!(loc, real1, pen=(0.6, :red), legend="Reference")
    plot!(loc, predict1, pen=(0.6, "0/83/156,..-"), legend="Predict")
    gmtset(FONT="8p",)
    legend!(position=(anchor=:TL, width=2.2, offset=(0.1, 0.1), pen=6), box=(pen=0.25, fill="white"))

    T = text_record([0 0], [info])
    text!(T, noclip=true, font=9, angle=0, offset=(-5.54,1.5))


    basemap(
        region=[-6.3, 6.3, 0, 2000], figsize=(5, 3),
        frame=(axes=:WStr,),
        xaxis=(ticks=1, ),
        yaxis=(ticks=100, ),
        title = "Ryx",
        par=(
            FONT_ANNOT_PRIMARY="6p,Helvetica,black",
            FONT_LABEL="8p,Helvetica,black",
            MAP_GRID_PEN="0p,gray,-",
            MAP_FRAME_PEN="0.5p,black",
            FONT_TITLE="16p,Helvetica,black",
        ),
        xshift = 5.25,
    )

    predict2 = rhoyx_predict
    real2 = rhoyx_real
    err2 = abs.(predict2 .- real2) ./ real2 * 100

    plot!(loc, real2, pen=(0.6, :red), legend="Reference") 
    plot!(loc, predict2, pen=(0.6, "0/83/156,..-"), legend="Predict") 
    legend!(position=(anchor=:TL, width=2.2, offset=(0.1, 0.1)), box=(pen=0.25, fill="white"))


    basemap(
        region=[-6.3, 6.3, 0, 20], figsize=(5, 3),
        frame=(axes=:WStr,),
        xaxis=(ticks=1, ),
        yaxis=(annot=5, ticks=1, label=:"Relative error [%]"),
        title = "Relative error [%]",
        par=(
            FONT_ANNOT_PRIMARY="6p,Helvetica,black",
            FONT_LABEL="8p,Helvetica,black",
            MAP_GRID_PEN="0p,gray,-",
            MAP_FRAME_PEN="0.5p,black",
            FONT_TITLE="16p,Helvetica,black",
        ),
        xshift = 6.5,
    )

    plot!(loc, err1, pen=(0.6, :red), legend="Rxy")
    plot!(loc, err2, pen=(0.6, "0/83/156,..-"), legend="Ryx")
    legend!(position=(anchor=:TR, width=1.5, offset=(0.1, 0.1), pen=6), box=(pen=0.25, fill="white"))

end

function plot_function2(loc, rhoxy_predict, rhoxy_real, rhoyx_predict, rhoyx_real, info, shift=-5.4)

    basemap(
        region=[-6.3, 6.3, 0, 2000], figsize=(5, 3),
        frame=(axes=:WStr,),
        xaxis=(ticks=1,),
        yaxis=(annot=500, ticks=100, label=:"Resistivity [@~W\267@~m]" ),
        par=(
            FONT_ANNOT_PRIMARY="6p,Helvetica,black",
            FONT_LABEL="8p,Helvetica,black",
            MAP_GRID_PEN="0p,gray,-",
            MAP_FRAME_PEN="0.5p,black",
            FONT_TITLE="16p,Helvetica,black",
        ),
        xshift = -11.75,
        yshift = -3.25,
    )

    predict1 = rhoxy_predict
    real1 = rhoxy_real
    err1 = abs.(predict1 .- real1) ./ real1 * 100

    plot!(loc, real1, pen=(0.6, :red), legend="Reference")
    plot!(loc, predict1, pen=(0.6, "0/83/156,..-"), legend="Predict")
    legend!(position=(anchor=:TL, width=2.2, offset=(0.1, 0.1), pen=6), box=(pen=0.25, fill="white"))

    T = text_record([0 0], [info])
    text!(T, noclip=true, font=9, angle=0, offset=(shift,1.5))


    basemap(
        region=[-6.3, 6.3, 0, 2000], figsize=(5, 3),
        frame=(axes=:WStr,),
        xaxis=(ticks=1,),
        yaxis=(ticks=100, ),
        par=(
            FONT_ANNOT_PRIMARY="6p,Helvetica,black",
            FONT_LABEL="8p,Helvetica,black",
            MAP_GRID_PEN="0p,gray,-",
            MAP_FRAME_PEN="0.5p,black",
            FONT_TITLE="16p,Helvetica,black",
        ),
        xshift = 5.25,
    )

    predict2 = rhoyx_predict
    real2 = rhoyx_real
    err2 = abs.(predict2 .- real2) ./ real2 * 100

    plot!(loc, real2, pen=(0.6, :red), legend="Reference") 
    plot!(loc, predict2, pen=(0.6, "0/83/156,..-"), legend="Predict") 
    legend!(position=(anchor=:TL, width=2.2, offset=(0.1, 0.1)), box=(pen=0.25, fill="white"))


    basemap(
        region=[-6.3, 6.3, 0, 20], figsize=(5, 3),
        frame=(axes=:WStr,),
        xaxis=(ticks=1, ),
        yaxis=(annot=5, ticks=1, label=:"Relative error [%]"),
        par=(
            FONT_ANNOT_PRIMARY="6p,Helvetica,black",
            FONT_LABEL="8p,Helvetica,black",
            MAP_GRID_PEN="0p,gray,-",
            MAP_FRAME_PEN="0.5p,black",
            FONT_TITLE="16p,Helvetica,black",
        ),
        xshift = 6.5,
    )

    plot!(loc, err1, pen=(0.6, :red), legend="Rxy")
    plot!(loc, err2, pen=(0.6, "0/83/156,..-"), legend="Ryx")
    legend!(position=(anchor=:TR, width=1.5, offset=(0.1, 0.1), pen=6), box=(pen=0.25, fill="white"))

end

function plot_function3(loc, rhoxy_predict, rhoxy_real, rhoyx_predict, rhoyx_real, info)

    basemap(
        region=[-6.3, 6.3, 0, 2000], figsize=(5, 3),
        frame=(axes=:WStr,),
        xaxis=(annot=2, ticks=1, label=:"Y-Distance [km]"),
        yaxis=(annot=500, ticks=100, label=:"Resistivity [@~W\267@~m]" ),
        par=(
            FONT_ANNOT_PRIMARY="6p,Helvetica,black",
            FONT_LABEL="8p,Helvetica,black",
            MAP_GRID_PEN="0p,gray,-",
            MAP_FRAME_PEN="0.5p,black",
            FONT_TITLE="16p,Helvetica,black",
        ),
        xshift = -11.75,
        yshift = -3.25,
    )
    predict1 = rhoxy_predict
    real1 = rhoxy_real
    err1 = abs.(predict1 .- real1) ./ real1 * 100

    plot!(loc, real1, pen=(0.6, :red), legend="Reference")
    plot!(loc, predict1, pen=(0.6, "0/83/156,..-"), legend="Predict")
    legend!(position=(anchor=:TL, width=2.2, offset=(0.1, 0.1), pen=6), box=(pen=0.25, fill="white"))

    T = text_record([0 0], [info])
    text!(T, noclip=true, font=9, angle=0, offset=(-5.4,1.5))


    basemap(
        region=[-6.3, 6.3, 0, 2000], figsize=(5, 3),
        frame=(axes=:WStr,),
        xaxis=(annot=2, ticks=1, label=:"Y-Distance [km]"),
        yaxis=(ticks=100, ),
        par=(
            FONT_ANNOT_PRIMARY="6p,Helvetica,black",
            FONT_LABEL="8p,Helvetica,black",
            MAP_GRID_PEN="0p,gray,-",
            MAP_FRAME_PEN="0.5p,black",
            FONT_TITLE="16p,Helvetica,black",
        ),
        xshift = 5.25,
    )

    predict2 = rhoyx_predict
    real2 = rhoyx_real
    err2 = abs.(predict2 .- real2) ./ real2 * 100

    plot!(loc, real2, pen=(0.6, :red), legend="Reference") 
    plot!(loc, predict2, pen=(0.6, "0/83/156,..-"), legend="Predict") 
    legend!(position=(anchor=:TL, width=2.2, offset=(0.1, 0.1)), box=(pen=0.25, fill="white"))


    basemap(
        region=[-6.3, 6.3, 0, 20], figsize=(5, 3),
        frame=(axes=:WStr,),
        xaxis=(annot=2, ticks=1, label=:"Y-Distance [km]"),
        yaxis=(annot=5, ticks=1, label=:"Relative error [%]"),
        par=(
            FONT_ANNOT_PRIMARY="6p,Helvetica,black",
            FONT_LABEL="8p,Helvetica,black",
            MAP_GRID_PEN="0p,gray,-",
            MAP_FRAME_PEN="0.5p,black",
            FONT_TITLE="16p,Helvetica,black",
        ),
        xshift = 6.5,
    )

    plot!(loc, err1, pen=(0.6, :red), legend="Rxy")
    plot!(loc, err2, pen=(0.6, "0/83/156,..-"), legend="Ryx")
    legend!(position=(anchor=:TR, width=1.5, offset=(0.1, 0.1), pen=6), box=(pen=0.25, fill="white"))

end