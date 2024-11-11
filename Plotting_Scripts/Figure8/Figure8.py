import pygmt
import pandas as pd

def load_xyz_file(filename):
    df = pd.read_csv(filename, sep=r'\s+', header=None, names=['x', 'y', 'z'])
    return df

def preset1():
    ymin, ymax = -6.4, 6.4
    zmin, zmax = 0, 6
    return f"{ymin}/{ymax}/{zmin}/{zmax}"

def preset2():
    xmin = -6150
    xmax = 6150
    ymin = -2.419355
    ymax = 3
    scale = 1000
    xmin = xmin / scale
    xmax = xmax / scale

    # Print the scaled range
    print(f"{xmin} {xmax} {ymin} {ymax}")
    
    # Create a formatted string for the range
    range_xy = f"{xmin}/{xmax}/{ymin}/{ymax}"
    return range_xy


range_yz = preset1()
print("Formatted range:", range_yz)
range_xy = preset2()
print("Formatted range:", range_xy)

# Set file and directory paths
dir_path = "./"
grd_file = f"{dir_path}model2501.grd"
cpt_file_in = f"{dir_path}thermal.cpt"
cpt_file_out = f"{dir_path}rbow.cpt"
out_pdf_png = f"{dir_path}Figure8_py"

fig = pygmt.Figure()
#true model
# Customize font settings
pygmt.config(FONT_ANNOT_PRIMARY="10p", FONT_LABEL="12p", FONT_TITLE="14p", MAP_FRAME_PEN="1.0p")
# Create a colormap
pygmt.makecpt(cmap=cpt_file_in, series="0/4.0/0.01", continuous=True, output=cpt_file_out)
    
# Convert grid range using grdedit in original GMT, currently, PyGMT does not support the `grdedit` and `grdconvert` modules
# gmt grdedit model2501_coreRangeGrids.grd -R-6.4/6.4/0/6 -Gmodel2501.grd
    
# Plot the grid image
fig.grdimage(grid=grd_file, region=range_yz, projection="X10c/-5c", frame=["xa2f1+lY-Distance (km)", "ya1f1+lZ-Depth (km)", "WStr"], cmap=cpt_file_out)
    
# Add a colorbar
fig.colorbar(cmap=cpt_file_out, position="jTC+w5c/0.3c+o5.5c/0.0c+v", frame=["xaf+lLog@-10@-(@~W\267@~m)"])
fig.text(x=-13.5, y=-0.1, text="(I) True model", font='16p', no_clip=True)
fig.text(x=-13.3, y=7, text="(II) Comparison", font='16p', no_clip=True)

def plot_figure1(cpt_file_in, cpt_file_out, range_xy, info, data1, data2, data3):
    
    fig.shift_origin(xshift="-3.5c", yshift="-5.3c")
    pygmt.config(FONT_ANNOT_PRIMARY="8p", FONT_LABEL="8p", MAP_FRAME_PEN="1p")
    pygmt.config(FONT_TITLE="16p,Helvetica,black")
    # Create a custom color palette
    pygmt.makecpt(cmap=cpt_file_in, series="0/4/0.1", continuous=True, output=cpt_file_out)
    
    # Plot Reference
    grid1 = pygmt.xyz2grd(data1, region=range_xy, spacing=(0.3, 0.77419))
    fig.basemap(region=range_xy, projection="X5c/3c", frame=['xf1', 'ya1f1+lLog@-10@-(Frequency) [Hz]', 'WStr+tReference'])
    fig.grdimage(grid = grid1, region=range_xy, projection="X5c/3c", cmap=cpt_file_out)
    
    fig.text(x=-12, y=0.3, text=info, font='12p', no_clip=True)
    
    # Shift for next plot
    fig.shift_origin(xshift="5.25c")
    
    # Plot Predict
    grid2 = pygmt.xyz2grd(data2, region=range_xy, spacing=(0.3, 0.77419))
    fig.basemap(region=range_xy, projection="X5c/3c", frame=['xf1', 'yf1', 'WStr+tPredict'])
    fig.grdimage(grid = grid2, region=range_xy, projection="X5c/3c", cmap=cpt_file_out)
    
    pygmt.config(FONT_ANNOT_PRIMARY="16p", FONT_LABEL="16p")
    fig.colorbar(frame=['xaf0.2+lLog@-10@-(R@-xy@-) [@~\127\267@~m]', 'y'], position="jBL+w3c/0.25c+o5.6c/0c+v+ma")
    pygmt.config(FONT_ANNOT_PRIMARY="8p", FONT_LABEL="8p")
    
    # Shift for next plot
    fig.shift_origin(xshift="6.65c")
    
    # Plot Relative Error
    pygmt.makecpt(cmap=cpt_file_in, series="0/20/0.1", continuous=True, output=cpt_file_out)
    grid3 = pygmt.xyz2grd(data3, region=range_xy, spacing=(0.3, 0.77419))
    fig.basemap(region=range_xy, projection="X5c/3c", frame=['xf1', 'yf1', 'WStr+tRelative error [%]'])
    fig.grdimage(grid = grid3, region=range_xy, projection="X5c/3c", cmap=cpt_file_out)
    pygmt.config(FONT_ANNOT_PRIMARY="16p", FONT_LABEL="16p")
    fig.colorbar(frame=['xa5f1+lRelative error [%]', 'y'], position="jBL+w3c/0.25c+o5.6c/0c+v+ma")

    return 0

def plot_figure2(cpt_file_in, cpt_file_out, range_xy, info, data1, data2, data3):
    
    pygmt.config(FONT_ANNOT_PRIMARY="8p", FONT_LABEL="8p", MAP_FRAME_PEN="1p")
    pygmt.config(FONT_TITLE="16p,Helvetica,black")
    # Create a custom color palette
    pygmt.makecpt(cmap=cpt_file_in, series="0/4/0.1", continuous=True, output=cpt_file_out)
    
    # Plot Reference
    fig.shift_origin(xshift="-11.9c", yshift="-3.5c")
    grid1 = pygmt.xyz2grd(data1, region=range_xy, spacing=(0.3, 0.77419))
    fig.basemap(region=range_xy, projection="X5c/3c", frame=['xf1', 'ya1f1+lLog@-10@-(Frequency) [Hz]', "WStr"])
    fig.grdimage(grid = grid1, region=range_xy, projection="X5c/3c", cmap=cpt_file_out)
    fig.text(x=-12, y=0.3, text=info, font='12p', no_clip=True)
    
    # Shift for next plot
    fig.shift_origin(xshift="5.25c")
    
    # Plot Predict
    grid2 = pygmt.xyz2grd(data2, region=range_xy, spacing=(0.3, 0.77419))
    fig.basemap(region=range_xy, projection="X5c/3c", frame=['xf1', 'yf1', 'WStr'])
    fig.grdimage(grid = grid2, region=range_xy, projection="X5c/3c", cmap=cpt_file_out)
    pygmt.config(FONT_ANNOT_PRIMARY="16p", FONT_LABEL="16p")
    fig.colorbar(frame=['xaf0.2+lLog@-10@-(R@-xy@-) [@~\127\267@~m]', 'y'], position="jBL+w3c/0.25c+o5.6c/0c+v+ma")
    pygmt.config(FONT_ANNOT_PRIMARY="8p", FONT_LABEL="8p")
    
    # Shift for next plot
    fig.shift_origin(xshift="6.65c")
    
    # Plot Relative Error
    pygmt.makecpt(cmap=cpt_file_in, series="0/20/0.1", continuous=True, output=cpt_file_out)
    grid3 = pygmt.xyz2grd(data3, region=range_xy, spacing=(0.3, 0.77419))
    fig.basemap(region=range_xy, projection="X5c/3c", frame=['xf1', 'yf1', "WStr"])
    fig.grdimage(grid = grid3, region=range_xy, projection="X5c/3c", cmap=cpt_file_out)
    pygmt.config(FONT_ANNOT_PRIMARY="16p", FONT_LABEL="16p")
    fig.colorbar(frame=['xa5f1+lRelative error [%]', 'y'], position="jBL+w3c/0.25c+o5.6c/0c+v+ma")

    return 0

def plot_figure3(cpt_file_in, cpt_file_out, range_xy, info, data1, data2, data3):
    
    pygmt.config(FONT_ANNOT_PRIMARY="8p", FONT_LABEL="8p", MAP_FRAME_PEN="1p")
    pygmt.config(FONT_TITLE="16p,Helvetica,black")
    # Create a custom color palette
    pygmt.makecpt(cmap=cpt_file_in, series="0/4/0.1", continuous=True, output=cpt_file_out)
    
    # Plot Reference
    fig.shift_origin(xshift="-11.9c", yshift="-3.5c")
    grid1 = pygmt.xyz2grd(data1, region=range_xy, spacing=(0.3, 0.77419))
    fig.basemap(region=range_xy, projection="X5c/3c", frame=['xa2f1+lY-Distance [km]', 'ya1f1+lLog@-10@-(Frequency) [Hz]', "WStr"])
    fig.grdimage(grid = grid1, region=range_xy, projection="X5c/3c", cmap=cpt_file_out)
    fig.text(x=-12, y=0.3, text=info, font='12p', no_clip=True)
    
    # Shift for next plot
    fig.shift_origin(xshift="5.25c")
    
    # Plot Predict
    grid2 = pygmt.xyz2grd(data2, region=range_xy, spacing=(0.3, 0.77419))
    fig.basemap(region=range_xy, projection="X5c/3c", frame=['xa2f1+lY-Distance [km]', 'yf1', 'WStr'])
    fig.grdimage(grid = grid2, region=range_xy, projection="X5c/3c", cmap=cpt_file_out)
    pygmt.config(FONT_ANNOT_PRIMARY="16p", FONT_LABEL="16p")
    fig.colorbar(frame=['xaf0.2+lLog@-10@-(R@-xy@-) [@~\127\267@~m]', 'y'], position="jBL+w3c/0.25c+o5.6c/0c+v+ma")
    pygmt.config(FONT_ANNOT_PRIMARY="8p", FONT_LABEL="8p")
    
    # Shift for next plot
    fig.shift_origin(xshift="6.65c")
    
    # Plot Relative Error
    pygmt.makecpt(cmap=cpt_file_in, series="0/20/0.1", continuous=True, output=cpt_file_out)
    grid3 = pygmt.xyz2grd(data3, region=range_xy, spacing=(0.3, 0.77419))
    fig.basemap(region=range_xy, projection="X5c/3c", frame=['xa2f1+lY-Distance [km]', 'yf1', "WStr"])
    fig.grdimage(grid = grid3, region=range_xy, projection="X5c/3c", cmap=cpt_file_out)
    pygmt.config(FONT_ANNOT_PRIMARY="16p", FONT_LABEL="16p")
    fig.colorbar(frame=['xa5f1+lRelative error [%]', 'y'], position="jBL+w3c/0.25c+o5.6c/0c+v+ma")

    return 0

## UFNO Rxy mode
info1 = "(a) UFNO R@-xy@-"
fileName1 = f"{dir_path}UFNO_real_xy.txt"
fileName2 = f"{dir_path}UFNO_predict_xy.txt"
fileName3 = f"{dir_path}UFNO_error_xy.txt"
data1 = load_xyz_file(fileName1)
data2 = load_xyz_file(fileName2)
data3 = load_xyz_file(fileName3)
plot_figure1(cpt_file_in, cpt_file_out, range_xy, info1, data1, data2, data3)

## UFNO Ryx mode
info2 = "(b) UFNO R@-yx@-"
fileName1 = f"{dir_path}UFNO_real_yx.txt"
fileName2 = f"{dir_path}UFNO_predict_yx.txt"
fileName3 = f"{dir_path}UFNO_error_yx.txt"
data1 = load_xyz_file(fileName1)
data2 = load_xyz_file(fileName2)
data3 = load_xyz_file(fileName3)
plot_figure2(cpt_file_in, cpt_file_out, range_xy, info2, data1, data2, data3)

## EFDO Rxy mode
info3 = "(c) EFDO R@-xy@-"
fileName1 = f"{dir_path}EFDO_real_xy.txt"
fileName2 = f"{dir_path}EFDO_predict_xy.txt"
fileName3 = f"{dir_path}EFDO_error_xy.txt"
data1 = load_xyz_file(fileName1)
data2 = load_xyz_file(fileName2)
data3 = load_xyz_file(fileName3)
plot_figure2(cpt_file_in, cpt_file_out, range_xy, info3, data1, data2, data3)

## EFDO Ryx mode
info4 = "(d) EFDO R@-yx@-"
fileName1 = f"{dir_path}EFDO_real_yx.txt"
fileName2 = f"{dir_path}EFDO_predict_yx.txt"
fileName3 = f"{dir_path}EFDO_error_yx.txt"
data1 = load_xyz_file(fileName1)
data2 = load_xyz_file(fileName2)
data3 = load_xyz_file(fileName3)
plot_figure2(cpt_file_in, cpt_file_out, range_xy, info4, data1, data2, data3)

## EFNO Rxy mode
info5 = "(e) EFNO R@-xy@-"
fileName1 = f"{dir_path}EFNO_real_xy.txt"
fileName2 = f"{dir_path}EFNO_predict_xy.txt"
fileName3 = f"{dir_path}EFNO_error_xy.txt"
data1 = load_xyz_file(fileName1)
data2 = load_xyz_file(fileName2)
data3 = load_xyz_file(fileName3)
plot_figure2(cpt_file_in, cpt_file_out, range_xy, info5, data1, data2, data3)

## EFNO Ryx mode
info6 = "(f) EFNO R@-yx@-"
fileName1 = f"{dir_path}EFNO_real_yx.txt"
fileName2 = f"{dir_path}EFNO_predict_yx.txt"
fileName3 = f"{dir_path}EFNO_error_yx.txt"
data1 = load_xyz_file(fileName1)
data2 = load_xyz_file(fileName2)
data3 = load_xyz_file(fileName3)
plot_figure3(cpt_file_in, cpt_file_out, range_xy, info6, data1, data2, data3)

# Save the figure to a PDF and PNG file
fig.savefig(f"{out_pdf_png}.png")
fig.savefig(f"{out_pdf_png}.pdf")
