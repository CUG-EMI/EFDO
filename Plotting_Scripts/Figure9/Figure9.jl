using GMT
using MAT

# read mat file
file = matopen("./Real_predict.mat")
loc = read(file, "loc")
freqs = read(file, "freqs")

## EFNO
EFNO_rhoxy_site_real = read(file, "EFNO_rhoxy_real")
EFNO_rhoxy_site_predict = read(file, "EFNO_rhoxy_predict")
EFNO_rhoyx_site_real = read(file, "EFNO_rhoyx_real")
EFNO_rhoyx_site_predict = read(file, "EFNO_rhoyx_predict")

## EFDO
EFDO_rhoxy_site_real = read(file, "EFDO3d_rhoxy_real")
EFDO_rhoxy_site_predict = read(file, "EFDO3d_rhoxy_predict")
EFDO_rhoyx_site_real = read(file, "EFDO3d_rhoyx_real")
EFDO_rhoyx_site_predict = read(file, "EFDO3d_rhoyx_predict")

## UFNO 
UFNO_rhoxy_site_real = read(file, "UFNO3d_rhoxy_real")
UFNO_rhoxy_site_predict = read(file, "UFNO3d_rhoxy_predict")
UFNO_rhoyx_site_real = read(file, "UFNO3d_rhoyx_real")
UFNO_rhoyx_site_predict = read(file, "UFNO3d_rhoyx_predict")
close(file)

loc = loc ./ 1000

include("plot_figure.jl")

gmtbegin("Figure9_jl", fmt="pdf,png")

    # UFNO
    plot_function1(loc, UFNO_rhoxy_site_predict[1,:], UFNO_rhoxy_site_real[1,:], UFNO_rhoyx_site_predict[1,:], UFNO_rhoyx_site_real[1,:], "(a) UFNO 1000 Hz")
    plot_function2(loc, UFNO_rhoxy_site_predict[end,:], UFNO_rhoxy_site_real[end,:], UFNO_rhoyx_site_predict[end,:], UFNO_rhoyx_site_real[end,:], "(b) UFNO 0.0038 Hz")

    # EFDO
    plot_function2(loc, EFDO_rhoxy_site_predict[1,:], EFDO_rhoxy_site_real[1,:], EFDO_rhoyx_site_predict[1,:], EFDO_rhoyx_site_real[1,:], "(c) EFDO 1000 Hz", -5.54)
    plot_function2(loc, EFDO_rhoxy_site_predict[end,:], EFDO_rhoxy_site_real[end,:], EFDO_rhoyx_site_predict[end,:], EFDO_rhoyx_site_real[end,:], "(d) EFDO 0.0038 Hz")

    # EFNO
    plot_function2(loc, EFNO_rhoxy_site_predict[1,:], EFNO_rhoxy_site_real[1,:], EFNO_rhoyx_site_predict[1,:], EFNO_rhoyx_site_real[1,:], "(e) EFNO 1000 Hz", -5.54)
    plot_function3(loc, EFNO_rhoxy_site_predict[end,:], EFNO_rhoxy_site_real[end,:], EFNO_rhoyx_site_predict[end,:], EFNO_rhoyx_site_real[end,:], "(f) EFNO 0.0038 Hz")


gmtend()

        