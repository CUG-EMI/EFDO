using GMT

gmtbegin("Figure12_jl", fmt="pdf,png")
   
    basemap(
    region=[0, 30000, 0, 250], figsize=(8, 6),
    frame=(axes=:WStr,),
    xaxis=(annot=5000, grid=5000, label=:"Sample size"), 
    yaxis=(annot=50, grid=50, label=:"Each epoch time comsumption (s)"),
    par=(
    FONT_ANNOT_PRIMARY=8, 
    FONT_LABEL=10, 
    MAP_GRID_PEN="0p,gray,-",
    MAP_FRAME_PEN="0.6p",
    ) 
    ) 
    
    plot!("time.txt", pen=(0.4, :Red, "--"))
    plot!(
          "time.txt", marker=:circle, 
          markersize=0.15, 
          markercolor="Red"
        )
    gmtset(FONT=8,)

    # This is an alternative method for creating legends, styled in the manner of Julia 
    # language. It structures the legend like function parameters, making it intuitive 
    # yet different from the legend formats used in PyGMT and original GMT. By adopting 
    # the style shown in `Figure10.jl` we provided, we can achieve consistency in legend 
    # creation across all three GMT variations.
    legend!(
        (
            symbol1=(marker=:circ, size=0.12, dx_left=0.26, fill=:red, dx_right=0.6, text="Training time"),
            vspace1=-0.31,
            symbol2=(marker="-", size=0.5, dx_left=0.25, pen=(0.25, "red", "--")),
        ),
        position=(anchor=:TL, width=2.6, offset=0.2),
        box=(pen=0.5, fill=:white, radius=0.2)
    )
    
    basemap!(
    region=[0, 30000, 0.001, 0.1], figsize=(8, 6), proj=:logy,
    xaxis=(annot=5000, grid=5000, label=:"Sample size"),
    yaxis=(annot=0.1, ticks=3, grid=3, label=:"Relative error", scale=:pow),
    frame=(axes=:WStr,),
    par=(
    FONT_ANNOT_PRIMARY=8, 
    FONT_LABEL=10,
    MAP_GRID_PEN="0p,gray,-",
    MAP_FRAME_PEN="0.6p",
    ),
    xshift = 9.5
    )

    plot!("error.txt", pen=(0.4, :Blue, "--"))
    plot!(
          "error.txt", marker=:circle, 
          markersize=0.15, 
          markercolor="Blue"
        )

    gmtset(FONT=8,)
    legend!(
      (
        symbol1=(marker=:circ, size=0.12, dx_left=0.26, fill=:Blue, dx_right=0.6, text="Training error"),
        vspace1=-0.31,
        symbol2=(marker="-", size=0.5, dx_left=0.25, pen=(0.25, "Blue", "--")),
      ),
      position=(anchor=:TL, width=2.6, offset=0.2),
      box=(pen=0.5, fill=:white, radius=0.2)
    )

gmtend()
