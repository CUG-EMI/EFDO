import pygmt

# Set file and directory paths
dir_path = "./"
out_pdf_png = f"{dir_path}Figure7_py"

# some figure configurations
pygmt.config(MAP_GRID_PEN="0.05p,DARKGRAY")
pygmt.config(FONT_ANNOT_PRIMARY="10p,Helvetica,black")
pygmt.config(FONT_LABEL="14p,Helvetica,black")
pygmt.config(MAP_FRAME_PEN="0.6p,black")

fig = pygmt.Figure()

# setup basemap
fig.basemap(
    region=[0, 500, 0.001, 1],
    projection="X10c/7cl",
    frame=["WSrt", "xa100+lEpoch", "ya1f3p+lRelative loss"]
)

# plot data
# U-FNO
fig.plot(data=f"{dir_path}data1_train.txt", pen="0.6p,0/83/156", label="U-FNO train")
fig.plot(data=f"{dir_path}data1_val.txt", pen="1.3p,65/105/225,.", label="U-FNO val")
fig.plot(data=f"{dir_path}data1_test.txt", pen="0.4p,30/144/255,--", label="U-FNO test")

# EFDO
fig.plot(data=f"{dir_path}data2_train.txt", pen="0.6p,178/34/34", label="EFDO train")
fig.plot(data=f"{dir_path}data2_val.txt", pen="1.3p,220/20/60,.", label="EFDO val")
fig.plot(data=f"{dir_path}data2_test.txt", pen="0.4p,255/99/71,--", label="EFDO test")

# EFNO
fig.plot(data=f"{dir_path}data3_train.txt", pen="0.6p,0/100/0", label="EFNO train")
fig.plot(data=f"{dir_path}data3_val.txt", pen="1.3p,34/139/34,.", label="EFNO val")
fig.plot(data=f"{dir_path}data3_test.txt", pen="0.4p,60/179/113,--", label="EFNO test")

# add lengend
pygmt.config(FONT="7p,Helvetica,black")
pygmt.config(MAP_FRAME_PEN="0.3p,black")
fig.legend(
    position="jTR+w2.2c+o0.1c/0.1c",
    box="+p0.3p+r0.1c+gwhite"
)

# Save the figure to a PDF and PNG file
fig.savefig(f"{out_pdf_png}.pdf")
fig.savefig(f"{out_pdf_png}.png")