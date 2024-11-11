using MAT, Printf

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

function writeData(data, filename)
    fid =   open(filename, "w")
    for i in 1:length(data)
        @printf(fid, "%-12.5f %-12.5f\n", loc[i], data[i])
    end
    close(fid)  
end

## UFNO
writeData(UFNO_rhoxy_site_predict[1,:], "UFNO_rhoxy_site_predict_1.txt")
writeData(UFNO_rhoxy_site_real[1,:], "UFNO_rhoxy_site_real_1.txt")
writeData(UFNO_rhoyx_site_predict[1,:], "UFNO_rhoyx_site_predict_1.txt")
writeData(UFNO_rhoyx_site_real[1,:], "UFNO_rhoyx_site_real_1.txt")
rxy_Err = abs.(UFNO_rhoxy_site_predict[1,:] .- UFNO_rhoxy_site_real[1,:]) ./ UFNO_rhoxy_site_real[1,:] * 100
ryx_Err = abs.(UFNO_rhoyx_site_predict[1,:] .- UFNO_rhoyx_site_real[1,:]) ./ UFNO_rhoyx_site_real[1,:] * 100
writeData(rxy_Err, "UFNO_rhoxy_site_error_1.txt")
writeData(ryx_Err, "UFNO_rhoyx_site_error_1.txt")

writeData(UFNO_rhoxy_site_predict[end,:], "UFNO_rhoxy_site_predict_end.txt")
writeData(UFNO_rhoxy_site_real[end,:], "UFNO_rhoxy_site_real_end.txt")
writeData(UFNO_rhoyx_site_predict[end,:], "UFNO_rhoyx_site_predict_end.txt")
writeData(UFNO_rhoyx_site_real[end,:], "UFNO_rhoyx_site_real_end.txt")
rxy_Err = abs.(UFNO_rhoxy_site_predict[end,:] .- UFNO_rhoxy_site_real[end,:]) ./ UFNO_rhoxy_site_real[end,:] * 100
ryx_Err = abs.(UFNO_rhoyx_site_predict[end,:] .- UFNO_rhoyx_site_real[end,:]) ./ UFNO_rhoyx_site_real[end,:] * 100
writeData(rxy_Err, "UFNO_rhoxy_site_error_end.txt")
writeData(ryx_Err, "UFNO_rhoyx_site_error_end.txt")

## EFDO
writeData(EFDO_rhoxy_site_predict[1,:], "EFDO_rhoxy_site_predict_1.txt")
writeData(EFDO_rhoxy_site_real[1,:], "EFDO_rhoxy_site_real_1.txt")
writeData(EFDO_rhoyx_site_predict[1,:], "EFDO_rhoyx_site_predict_1.txt")
writeData(EFDO_rhoyx_site_real[1,:], "EFDO_rhoyx_site_real_1.txt")
rxy_Err = abs.(EFDO_rhoxy_site_predict[1,:] .- EFDO_rhoxy_site_real[1,:]) ./ EFDO_rhoxy_site_real[1,:] * 100
ryx_Err = abs.(EFDO_rhoyx_site_predict[1,:] .- EFDO_rhoyx_site_real[1,:]) ./ EFDO_rhoyx_site_real[1,:] * 100
writeData(rxy_Err, "EFDO_rhoxy_site_error_1.txt")
writeData(ryx_Err, "EFDO_rhoyx_site_error_1.txt")

writeData(EFDO_rhoxy_site_predict[end,:], "EFDO_rhoxy_site_predict_end.txt")
writeData(EFDO_rhoxy_site_real[end,:], "EFDO_rhoxy_site_real_end.txt")
writeData(EFDO_rhoyx_site_predict[end,:], "EFDO_rhoyx_site_predict_end.txt")
writeData(EFDO_rhoyx_site_real[end,:], "EFDO_rhoyx_site_real_end.txt")
rxy_Err = abs.(EFDO_rhoxy_site_predict[end,:] .- EFDO_rhoxy_site_real[end,:]) ./ EFDO_rhoxy_site_real[end,:] * 100
ryx_Err = abs.(EFDO_rhoyx_site_predict[end,:] .- EFDO_rhoyx_site_real[end,:]) ./ EFDO_rhoyx_site_real[end,:] * 100
writeData(rxy_Err, "EFDO_rhoxy_site_error_end.txt")
writeData(ryx_Err, "EFDO_rhoyx_site_error_end.txt")

## EFNO
writeData(EFNO_rhoxy_site_predict[1,:], "EFNO_rhoxy_site_predict_1.txt")
writeData(EFNO_rhoxy_site_real[1,:], "EFNO_rhoxy_site_real_1.txt")
writeData(EFNO_rhoyx_site_predict[1,:], "EFNO_rhoyx_site_predict_1.txt")
writeData(EFNO_rhoyx_site_real[1,:], "EFNO_rhoyx_site_real_1.txt")
rxy_Err = abs.(EFNO_rhoxy_site_predict[1,:] .- EFNO_rhoxy_site_real[1,:]) ./ EFNO_rhoxy_site_real[1,:] * 100
ryx_Err = abs.(EFNO_rhoyx_site_predict[1,:] .- EFNO_rhoyx_site_real[1,:]) ./ EFNO_rhoyx_site_real[1,:] * 100
writeData(rxy_Err, "EFNO_rhoxy_site_error_1.txt")
writeData(ryx_Err, "EFNO_rhoyx_site_error_1.txt")

writeData(EFNO_rhoxy_site_predict[end,:], "EFNO_rhoxy_site_predict_end.txt")
writeData(EFNO_rhoxy_site_real[end,:], "EFNO_rhoxy_site_real_end.txt")
writeData(EFNO_rhoyx_site_predict[end,:], "EFNO_rhoyx_site_predict_end.txt")
writeData(EFNO_rhoyx_site_real[end,:], "EFNO_rhoyx_site_real_end.txt")
rxy_Err = abs.(EFNO_rhoxy_site_predict[end,:] .- EFNO_rhoxy_site_real[end,:]) ./ EFNO_rhoxy_site_real[end,:] * 100
ryx_Err = abs.(EFNO_rhoyx_site_predict[end,:] .- EFNO_rhoyx_site_real[end,:]) ./ EFNO_rhoyx_site_real[end,:] * 100
writeData(rxy_Err, "EFNO_rhoxy_site_error_end.txt")
writeData(ryx_Err, "EFNO_rhoyx_site_error_end.txt")


