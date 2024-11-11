import pygmt
import os

# Set file and directory paths
dir_path = "./"
out_pdf_png = f"{dir_path}Figure12_py"
legend_file_path = f"{dir_path}legend.txt"

fig = pygmt.Figure()

# training time
pygmt.config(FONT_ANNOT_PRIMARY="8p", FONT_LABEL="10p", MAP_FRAME_PEN="0.6p", MAP_GRID_PEN="0p,gray,-")
fig.basemap(region=[0, 30000, 0, 250], projection="X8c/6c", frame=["xa5000g5000+lSample size", "ya50g50+lEach epoch time comsumption (s)", "WStr"])

fig.plot(data=f"{dir_path}time.txt", pen="0.4p,red,-")
fig.plot(data=f"{dir_path}time.txt", style="c0.15c", pen="0.2p,red", fill="red")

# legend content
legend_content = """
S 0.4c c 0.15c red 0.25p,red 0.8c Training time
G -1l
S 0.4c - 0.5c red 0.25p,red,-- 
"""
# write legend content to a text file in the specified directory
with open(legend_file_path, "w") as file:
    file.write(legend_content)
fig.legend(spec=legend_file_path, position="JTL+jTL+o0.2c/0.2c", box="+p0.3,black+gwhite")


# test error
fig.shift_origin(xshift="9.5c")
pygmt.config(FONT_ANNOT_PRIMARY="8p", FONT_LABEL="10p", MAP_FRAME_PEN="0.6p", MAP_GRID_PEN="0p,gray,-")
pygmt.config(FORMAT_FLOAT_OUT='e')
fig.basemap(region=[0, 30000, 0.001, 0.1], projection="X8c/6cl", frame=["xa5000g5000+lSample size", "ya0.1f3g3p+lRelative error", "WStr"])

fig.plot(data=f"{dir_path}error.txt", pen="0.4p,Blue,-")
fig.plot(data=f"{dir_path}error.txt", style="c0.15c", pen="0.2p,Blue", fill="blue")

# legend content
legend_content = """
S 0.4c c 0.15c Blue 0.25p,Blue 0.8c Training error
G -1l
S 0.4c - 0.5c Blue 0.25p,Blue,-- 
"""
# write legend content to a text file in the specified directory
with open(legend_file_path, "w") as file:
    file.write(legend_content)
fig.legend(spec=legend_file_path, position="JTL+jTL+o0.2c/0.2c", box="+p0.3,black+gwhite")

os.remove(legend_file_path)

# Save the figure to a PDF and PNG file
fig.savefig(f"{out_pdf_png}.png")
fig.savefig(f"{out_pdf_png}.pdf")