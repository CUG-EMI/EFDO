using GMT

gmtbegin("Figure10_jl", fmt="pdf,png")
   
    basemap(
    region=[0, 33, 0.70, 1.01], figsize=(8, 6),
    frame=(axes=:WStr,),
    xaxis=(annot=4, label=:"Frequency index"), 
    yaxis=(annot=0.05, label=:"@R@+2@+@"),
    par=(FONT_ANNOT_PRIMARY=8, FONT_LABEL=10, MAP_FRAME_PEN="0.6p") 
    )

    # UFNO
    plot!("UFNO_r2.txt", pen=(0.6, :Red, "--"))
    plot!(
          "UFNO_r2.txt", marker=:circle, 
          markersize=0.15, 
          fill="-",
          markerline=ml=(0.2,"Red"),
        )
    plot!(
          "UFNO_r2_train.txt", marker=:circle, 
          markersize=0.15, 
          markercolor="Red"
        )

    # EFDO
    plot!("EFDO_r2.txt", pen=(0.6, :BLUE, "-"))
    plot!(
          "EFDO_r2.txt", marker=:circle, 
          markersize=0.15, 
          fill="-",
          markerline=ml=(0.2,"BLUE"),
        )
    plot!(
          "EFDO_r2_train.txt", marker=:circle, 
          markersize=0.15, 
          markercolor="BLUE"
        )

    # EFNO
    plot!("EFNO_r2.txt", pen=(0.6, :GREEN1, "-"))
    plot!(
          "EFNO_r2.txt", marker=:circle, 
          markersize=0.15, 
          fill="-",
          markerline=ml=(0.2,"GREEN1"),
        )
    plot!(
          "EFNO_r2_train.txt", marker=:circle, 
          markersize=0.15, 
          markercolor="GREEN1"
        )

    legend_content = """
    S 0.4c c 0.15c red 0.25p,red 0.8c UFNO trained frequencies
    G -1l
    S 0.4c - 0.5c red 0.25p,red,-- 

    S 0.4c c 0.15c - 0.25p,red 0.8c UFNO untrained frequencies
    G -1l
    S 0.4c - 0.5c red 0.25p,red,--

    S 0.4c c 0.15c blue 0.25p,blue 0.8c EFDO trained frequencies
    G -1l
    S 0.4c - 0.5c blue 0.25p,blue,-- 

    S 0.4c c 0.15c - 0.25p,blue 0.8c EFDO untrained frequencies
    G -1l
    S 0.4c - 0.5c blue 0.25p,blue,--

    S 0.4c c 0.15c green1 0.25p,green1 0.8c EFNO trained frequencies
    G -1l
    S 0.4c - 0.5c green1 0.25p,green1,-- 

    S 0.4c c 0.15c - 0.25p,green1 0.8c EFNO untrained frequencies
    G -1l
    S 0.4c - 0.5c green1 0.25p,green1,--"""

    fid = open("legend.txt", "w")
        write(fid, legend_content)
    close(fid)
    gmtset(FONT=8,)
    legend!(
      "legend.txt",
      position=(anchor=:BL, offset=0.05),
    )


    # RMSE 
    basemap!(
    region=[0, 33, 0, 0.5], figsize=(8, 6),
    frame=(axes=:WStr,),
    xaxis=(annot=4, label=:"Frequency index"), 
    yaxis=(annot=0.05, label=:"RMSE"),
    par=(FONT_ANNOT_PRIMARY=8, FONT_LABEL=10, MAP_FRAME_PEN="0.6p"),
    xshift = 9.7
    )

    # UFNO
    plot!("UFNO_rmse.txt", pen=(0.6, :Red, "--"))
    plot!(
          "UFNO_rmse.txt", marker=:circle, 
          markersize=0.15, 
          fill="-",
          markerline=ml=(0.2,"Red"),
        )
    plot!(
          "UFNO_rmse_train.txt", marker=:circle, 
          markersize=0.15, 
          markercolor="Red"
        )

    # EFDO
    plot!("EFDO_rmse.txt", pen=(0.6, :BLUE, "-"))
    plot!(
          "EFDO_rmse.txt", marker=:circle, 
          markersize=0.15, 
          fill="-",
          markerline=ml=(0.2,"BLUE"),
        )
    plot!(
          "EFDO_rmse_train.txt", marker=:circle, 
          markersize=0.15, 
          markercolor="BLUE"
        )

    # EFNO
    plot!("EFNO_rmse.txt", pen=(0.6, :GREEN1, "-"))
    plot!(
          "EFNO_rmse.txt", marker=:circle, 
          markersize=0.15, 
          fill="-",
          markerline=ml=(0.2,"GREEN1"),
        )
    plot!(
          "EFNO_rmse_train.txt", marker=:circle, 
          markersize=0.15, 
          markercolor="GREEN1"
        )

    gmtset(FONT=8,)
    legend!(
      "legend.txt",
      position=(anchor=:TL, offset=0.05),
    )

    # remove legend.txt
    rm("legend.txt")

gmtend()
