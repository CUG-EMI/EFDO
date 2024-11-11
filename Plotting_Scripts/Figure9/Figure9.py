import pygmt
from scipy.io import loadmat

# Set file and directory paths
dir_path = "./"
out_pdf_png = f"{dir_path}Figure9_py"
# read mat file
file_path = f"{dir_path}Real_predict.mat"
data = loadmat(file_path)

# extract data
loc = data['loc'].flatten()  
freqs = data['freqs'].flatten()


## EFNO
EFNO_rhoxy_site_real = data['EFNO_rhoxy_real']
EFNO_rhoxy_site_predict = data['EFNO_rhoxy_predict']
EFNO_rhoyx_site_real = data['EFNO_rhoyx_real']
EFNO_rhoyx_site_predict = data['EFNO_rhoyx_predict']

## EFDO
EFDO_rhoxy_site_real = data['EFDO3d_rhoxy_real']
EFDO_rhoxy_site_predict = data['EFDO3d_rhoxy_predict']
EFDO_rhoyx_site_real = data['EFDO3d_rhoyx_real']
EFDO_rhoyx_site_predict = data['EFDO3d_rhoyx_predict']

## UFNO
UFNO_rhoxy_site_real = data['UFNO3d_rhoxy_real']
UFNO_rhoxy_site_predict = data['UFNO3d_rhoxy_predict']
UFNO_rhoyx_site_real = data['UFNO3d_rhoyx_real']
UFNO_rhoyx_site_predict = data['UFNO3d_rhoyx_predict']

# convert unit form [m] to [km]
loc = loc / 1000

fig = pygmt.Figure()

def plot_function1(loc, rhoxy_predict, rhoxy_real, rhoyx_predict, rhoyx_real, info):
    
    pygmt.config(FONT_ANNOT_PRIMARY="8p", FONT_LABEL="8p", MAP_FRAME_PEN="0.5p")
    pygmt.config(FONT_TITLE="16p,Helvetica,black")
    # Plot Rxy
    fig.basemap(region=[-6.3, 6.3, 0, 2000], projection='X5c/3c', frame=['WStr+tRxy', 'xf1', 'ya500f100+l"Resistivity [@~W\267@~m]"'])
    fig.plot(x=loc, y=rhoxy_real, pen='0.6p,red', label="Reference")
    fig.plot(x=loc, y=rhoxy_predict, pen='0.6p,0/83/156,..-', label="Predict")
    fig.legend(position='JTL+jTL+o0.1/0.1', box='+p0.25+gwhite')

    fig.text(x=-14, y=750, text=info, font='9p', no_clip=True)

    # Plot Ryx with x-shift
    fig.shift_origin(xshift='5.25c')
    fig.basemap(region=[-6.3, 6.3, 0, 2000], projection='X5c/3c', frame=['WStr+tRyx', 'xf1', 'yf100'])
    fig.plot(x=loc, y=rhoyx_real, pen='0.6p,red', label="Reference")
    fig.plot(x=loc, y=rhoyx_predict, pen='0.6p,0/83/156,..-', label="Predict")
    fig.legend(position='JTL+jTL+o0.1/0.1', box='+p0.25+gwhite')

    # Plot Relative Error with additional x-shift
    fig.shift_origin(xshift='6c')
    fig.basemap(region=[-6.3, 6.3, 0, 20], projection='X5c/3c', frame=['WStr+tRelative Error [%]', 'xf1', 'ya5f1+lRelative Error [%]'])
    fig.plot(x=loc, y=abs((rhoxy_predict - rhoxy_real) / rhoxy_real * 100), pen='0.6p,red', label="Rxy")
    fig.plot(x=loc, y=abs((rhoyx_predict - rhoyx_real) / rhoyx_real * 100), pen='0.6p,0/83/156,..-', label="Ryx")
    fig.legend(position='JTR+jTR+o0.1/0.1', box='+p0.25+gwhite')

    return 0

def plot_function2(loc, rhoxy_predict, rhoxy_real, rhoyx_predict, rhoyx_real, info,shift=0):
    
    pygmt.config(FONT_ANNOT_PRIMARY="8p", FONT_LABEL="8p", MAP_FRAME_PEN="0.5p")
    pygmt.config(FONT_TITLE="16p,Helvetica,black")
    # Plot Rxy
    fig.shift_origin(xshift='-11.25c', yshift='-3.25c')
    fig.basemap(region=[-6.3, 6.3, 0, 2000], projection='X5c/3c', frame=['WStr', 'xf1', 'ya500f100+l"Resistivity [@~W\267@~m]"'])
    fig.plot(x=loc, y=rhoxy_real, pen='0.6p,red', label="Reference")
    fig.plot(x=loc, y=rhoxy_predict, pen='0.6p,0/83/156,..-', label="Predict")
    fig.legend(position='JTL+jTL+o0.1/0.1', box='+p0.25+gwhite')

    fig.text(x=-14-shift, y=750, text=info, font='9p', no_clip=True)

    # Plot Ryx with x-shift
    fig.shift_origin(xshift='5.25c')
    fig.basemap(region=[-6.3, 6.3, 0, 2000], projection='X5c/3c', frame=['WStr', 'xf1', 'yf100'])
    fig.plot(x=loc, y=rhoyx_real, pen='0.6p,red', label="Reference")
    fig.plot(x=loc, y=rhoyx_predict, pen='0.6p,0/83/156,..-', label="Predict")
    fig.legend(position='JTL+jTL+o0.1/0.1', box='+p0.25+gwhite')

    # Plot Relative Error with additional x-shift
    fig.shift_origin(xshift='6c')
    fig.basemap(region=[-6.3, 6.3, 0, 20], projection='X5c/3c', frame=['WStr', 'xf1', 'ya5f1+lRelative Error [%]'])
    fig.plot(x=loc, y=abs((rhoxy_predict - rhoxy_real) / rhoxy_real * 100), pen='0.6p,red', label="Rxy")
    fig.plot(x=loc, y=abs((rhoyx_predict - rhoyx_real) / rhoyx_real * 100), pen='0.6p,0/83/156,..-', label="Ryx")
    fig.legend(position='JTR+jTR+o0.1/0.1', box='+p0.25+gwhite')

    return 0

def plot_function3(loc, rhoxy_predict, rhoxy_real, rhoyx_predict, rhoyx_real, info):
    
    pygmt.config(FONT_ANNOT_PRIMARY="8p", FONT_LABEL="8p", MAP_FRAME_PEN="0.5p")
    pygmt.config(FONT_TITLE="16p,Helvetica,black")
    # Plot Rxy
    fig.shift_origin(xshift='-11.25c', yshift='-3.25c')
    fig.basemap(region=[-6.3, 6.3, 0, 2000], projection='X5c/3c', frame=['WStr', 'xf1+lY-Distance [km]', 'ya500f100+lResistivity [@~W\267@~m]'])
    fig.plot(x=loc, y=rhoxy_real, pen='0.6p,red', label="Reference")
    fig.plot(x=loc, y=rhoxy_predict, pen='0.6p,0/83/156,..-', label="Predict")
    fig.legend(position='JTL+jTL+o0.1/0.1', box='+p0.25+gwhite')

    fig.text(x=-14+0.4, y=750, text=info, font='9p', no_clip=True)

    # Plot Ryx with x-shift
    fig.shift_origin(xshift='5.25c')
    fig.basemap(region=[-6.3, 6.3, 0, 1500], projection='X5c/3c', frame=['WStr', 'xf1+lY-Distance [km]', 'yf100'])
    fig.plot(x=loc, y=rhoyx_real, pen='0.6p,red', label="Reference")
    fig.plot(x=loc, y=rhoyx_predict, pen='0.6p,0/83/156,..-', label="Predict")
    fig.legend(position='JTL+jTL+o0.1/0.1', box='+p0.25+gwhite')

    # Plot Relative Error with additional x-shift
    fig.shift_origin(xshift='6c')
    fig.basemap(region=[-6.3, 6.3, 0, 20], projection='X5c/3c', frame=['WStr', 'xf1+lY-Distance [km]', 'ya5f1+lRelative Error [%]'])
    fig.plot(x=loc, y=abs((rhoxy_predict - rhoxy_real) / rhoxy_real * 100), pen='0.6p,red', label="Rxy")
    fig.plot(x=loc, y=abs((rhoyx_predict - rhoyx_real) / rhoyx_real * 100), pen='0.6p,0/83/156,..-', label="Ryx")
    fig.legend(position='JTR+jTR+o0.1/0.1', box='+p0.25+gwhite')

    return 0

# UFNO
plot_function1(loc, UFNO_rhoxy_site_predict[0,:], UFNO_rhoxy_site_real[0,:], UFNO_rhoyx_site_predict[0,:], UFNO_rhoyx_site_real[0,:], "(a) UFNO 1000 Hz")
plot_function2(loc, UFNO_rhoxy_site_predict[-1,:], UFNO_rhoxy_site_real[-1,:], UFNO_rhoyx_site_predict[-1,:], UFNO_rhoyx_site_real[-1,:], "(b) UFNO 0.0038 Hz", -0.44)

# EFDO
plot_function2(loc, EFDO_rhoxy_site_predict[0,:], EFDO_rhoxy_site_real[0,:], EFDO_rhoyx_site_predict[0,:], EFDO_rhoyx_site_real[0,:], "(c) EFDO 1000 Hz")
plot_function2(loc, EFDO_rhoxy_site_predict[-1,:], EFDO_rhoxy_site_real[-1,:], EFDO_rhoyx_site_predict[-1,:], EFDO_rhoyx_site_real[-1,:], "(d) EFDO 0.0038 Hz", -0.44)

# EFNO
plot_function2(loc, EFNO_rhoxy_site_predict[0,:], EFNO_rhoxy_site_real[0,:], EFNO_rhoyx_site_predict[0,:], EFNO_rhoyx_site_real[0,:], "(e) EFNO 1000 Hz")
plot_function3(loc, EFNO_rhoxy_site_predict[-1,:], EFNO_rhoxy_site_real[-1,:], EFNO_rhoyx_site_predict[-1,:], EFNO_rhoyx_site_real[-1,:], "(f) EFNO 0.0038 Hz")

# Save the figure to a PDF and PNG file
fig.savefig(f"{out_pdf_png}.png")
fig.savefig(f"{out_pdf_png}.pdf")
