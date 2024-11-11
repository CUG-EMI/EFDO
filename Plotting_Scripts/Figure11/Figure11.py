import pygmt

def preset():
    # Convert range units to kilometers
    ymin, ymax, zmin, zmax = -6.4, 6.4, 0, 6  # Again, assuming these values are already in kilometers
    return ymin, ymax, zmin, zmax

# Set file and directory paths
dir_path = "./"
cpt_file_in = f"{dir_path}thermal.cpt"
cpt_file_out = f"{dir_path}rbow.cpt"
result1_grid = f"{dir_path}result1.grd"
result2_grid = f"{dir_path}result2.grd"
out_pdf_png = f"{dir_path}Figure11_py"

# Set range by calling functions
ymin, ymax, zmin, zmax = preset()
range_yz1 = f"{ymin}/{ymax}/{zmin}/{zmax}"

pygmt.config(FONT_ANNOT_PRIMARY="12p", FONT_LABEL="12p", MAP_FRAME_PEN="1.5p,black")

fig = pygmt.Figure()
pygmt.makecpt(cmap=cpt_file_in, series="0/4.0/0.01", continuous=True, output=cpt_file_out)

# Convert grid range using grdedit in original GMT, currently, PyGMT does not support grdedit and grdconvert modules
# gmt grdedit model_1.grd -R-6.4/6.4/0/6 -Gresult1.grd

fig.grdimage(grid=result1_grid, region=range_yz1, projection="X12c/-6c", cmap=cpt_file_out, frame=["xa2f1+lY-Distance [km]", "yaf+lDepth [km]", "WStr"])
fig.text(x=-5.9, y=0.4, text="(a)", font="16p,Helvetica")

ymin, ymax, zmin, zmax = preset()
range_yz2 = f"{ymin}/{ymax}/{zmin}/{zmax}"

# Convert grid range using grdedit in original GMT, currently, PyGMT does not support grdedit and grdconvert modules
# gmt grdedit model_1.grd -R-6.4/6.4/0/6 -Gresult2.grd

fig.shift_origin(xshift="13c")
fig.grdimage(grid=result2_grid, region=range_yz2, projection="X12c/-6c", cmap=cpt_file_out, frame=["xa2f1+lY-Distance [km]", "yf1", "WStr"])
fig.plot(data=[[-2.0, 0.1], [-2.0, 2.0], [6.3, 2.0], [6.3, 0.1], [-2.0, 0.1]], pen="1.3p,red")
fig.text(x=-5.9, y=0.4, text="(b)", font="16p,Helvetica")

pygmt.config(FONT_ANNOT_PRIMARY="15p", FONT_LABEL="14p")
fig.colorbar(cmap=cpt_file_out, frame=["xaf+lLog@-10@-[@~W\267@~m]", "y"], position="jTC+w8c/0.5c+o-6.5c/7.5c+ml+e")

# Save in PDF and PNG formats
fig.savefig(f"{out_pdf_png}.pdf")
fig.savefig(f"{out_pdf_png}.png")