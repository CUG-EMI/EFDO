import pygmt
import os 

# Set file and directory paths
dir_path = "./"
out_pdf_png = f"{dir_path}Figure10_py"
legend_file_path = f"{dir_path}legend.txt"

fig = pygmt.Figure()

# plot the R^2 and trained/untrained frequencies figure
pygmt.config(FONT_ANNOT_PRIMARY="8p", FONT_LABEL="10p", MAP_FRAME_PEN="0.6p")
fig.basemap(region=[0, 33, 0.70, 1.01], projection="X8c/6c", frame=["xa4+lFrequency index", "ya0.05+l@R@+2@+@", "WStr"])
# UFNO
fig.plot(data=f"{dir_path}UFNO_r2.txt", pen="0.6p,red,-")
fig.plot(data=f"{dir_path}UFNO_r2.txt", style="c0.15c", pen="0.2p,red")
fig.plot(data=f"{dir_path}UFNO_r2_train.txt", style="c0.15c", fill="red")
# EFDO
fig.plot(data=f"{dir_path}EFDO_r2.txt", pen="0.6p,blue,-")
fig.plot(data=f"{dir_path}EFDO_r2.txt", style="c0.15c", pen="0.2p,blue")
fig.plot(data=f"{dir_path}EFDO_r2_train.txt", style="c0.15c", fill="blue")
# EFNO
fig.plot(data=f"{dir_path}EFNO_r2.txt", pen="0.6p,green1,-")
fig.plot(data=f"{dir_path}EFNO_r2.txt", style="c0.15c", pen="0.2p,green1")
fig.plot(data=f"{dir_path}EFNO_r2_train.txt", style="c0.15c", fill="green1")

# legend content
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
S 0.4c - 0.5c green1 0.25p,green1,--
"""
# write legend content to file
with open(legend_file_path, "w") as file:
    file.write(legend_content)
fig.legend(spec=legend_file_path, position="JBL+jBL+o0.05c/0.05c", box=False)

# plot the RMSE and trained/untrained frequencies figure
fig.shift_origin(xshift="9.5c")
pygmt.config(FONT_ANNOT_PRIMARY="8p", FONT_LABEL="10p", MAP_FRAME_PEN="0.6p")
fig.basemap(region=[0, 33, 0, 0.5], projection="X8c/6c", frame=["xa4+lFrequency index", "ya0.05+lRMSE", "WStr"])
# UFNO
fig.plot(data=f"{dir_path}UFNO_rmse.txt", pen="0.6p,red,-")
fig.plot(data=f"{dir_path}UFNO_rmse.txt", style="c0.15c", pen="0.2p,red")
fig.plot(data=f"{dir_path}UFNO_rmse_train.txt", style="c0.15c", fill="red")
# EFDO
fig.plot(data=f"{dir_path}EFDO_rmse.txt", pen="0.6p,blue,-")
fig.plot(data=f"{dir_path}EFDO_rmse.txt", style="c0.15c", pen="0.2p,blue")
fig.plot(data=f"{dir_path}EFDO_rmse_train.txt", style="c0.15c", fill="blue")
# EFNO
fig.plot(data=f"{dir_path}EFNO_rmse.txt", pen="0.6p,green1,-")
fig.plot(data=f"{dir_path}EFNO_rmse.txt", style="c0.15c", pen="0.2p,green1")
fig.plot(data=f"{dir_path}EFNO_rmse_train.txt", style="c0.15c", fill="green1")
fig.legend(spec=legend_file_path, position="JTL+jTL+o0.05c/0.05c", box=False)

os.remove(legend_file_path)

# Save the figure to a PDF and PNG file
fig.savefig(f"{out_pdf_png}.png")
fig.savefig(f"{out_pdf_png}.pdf")
