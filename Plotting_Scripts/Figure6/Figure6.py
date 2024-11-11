import pygmt

# Set file and directory paths
dir_path = "./"
cpt_file_in = f"{dir_path}thermal.cpt"
cpt_file_out = f"{dir_path}rbow.cpt"
alpha_grids = [f"{dir_path}alpha_{i}_1.grd" for i in range(1, 6)]  
out_pdf_png = f"{dir_path}Figure6_py"

# set initial range
xmin, xmax, ymin, ymax, scale = -6400, 6400, 0, 6000, 1000
xmin, xmax = xmin / scale, xmax / scale
ymin, ymax = ymin / scale, ymax / scale
range_xy = f"{xmin}/{xmax}/{ymin}/{ymax}"

# Create a color palette
pygmt.makecpt(cmap=cpt_file_in, series="0/4.0/0.1", continuous=True, output=cpt_file_out)

# Convert grid range using grdedit in original GMT, currently, PyGMT does not support the `grdedit` and `grdconvert` modules
# gmt grdedit alpha_{i}.grd -R-6.4/6.4/0/6 -Galpha_{i}_1.grd

# Create a figure with 2 rows and 3 columns subplots
fig = pygmt.Figure()
pygmt.config(MAP_FRAME_PEN="0.5p")
with fig.subplot(nrows=2, ncols=3, figsize=("24c", "8c"), frame="WSne", margins=["0.8c", "0.5c"]):
    labels = ['(a) @~\141@~=3.0', '(b) @~\141@~=4.0', '(c) @~\141@~=5.0', '(d) @~\141@~=6.0', '(e) @~\141@~=7.0']
    for i, alpha_grd in enumerate(alpha_grids):
        with fig.set_panel(panel=i):
            # adjust frame labels for each subplot
            if i == 0:
                frame = ["xa2f1", "xa2f1", "ya1f1+lZ-Depth (km)", "WS"]
                fig.grdimage(grid=alpha_grd, region=range_xy, projection="X8c/-4c", cmap=cpt_file_out, frame=frame)
            elif i == 3:
                frame = ["xa2f1+lY-Distance (km)", "ya1f1+lZ-Depth (km)", "WS"]
                fig.grdimage(grid=alpha_grd, region=range_xy, projection="X8c/-4c", cmap=cpt_file_out, frame=frame)
            elif i == 4:
                frame = ["xa2f1+lY-Distance (km)", "ya1f1", "WS"]
                fig.grdimage(grid=alpha_grd, region=range_xy, projection="X8c/-4c", cmap=cpt_file_out, frame=frame)
            else:
                frame = ["xa2f1", "ya1f1", "WS"]
                fig.grdimage(grid=alpha_grd, region=range_xy, projection="X8c/-4c", cmap=cpt_file_out, frame=frame)
                
            fig.basemap(region=range_xy, projection="X8c/-4c", frame="ne")
            fig.text(x=-0.5, y=5.0, text=f"{labels[i]}", font="12p,Helvetica", justify="TL")

# add colorbar
fig.colorbar(cmap=cpt_file_out, position="jTC+w6c/0.5c+o9.5c/6.0c+ml+e", frame=["xaf+lLog@-10@-(@~W\\267@~m)", "y"])

# Save the figure to a PDF and PNG file
fig.savefig(f"{out_pdf_png}.png")
fig.savefig(f"{out_pdf_png}.pdf")