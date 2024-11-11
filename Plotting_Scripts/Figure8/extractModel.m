clc;clear;close all;

load("model_2501.mat");
imagesc(log10(1./(10 .^ sig)));
colorbar
title("core restivity")


sig = 10.^(sig)';
sigma = sig';


%% 2d forward model
nypad = 10;
nzpad = 10;
airLayer = zBlock(10:-1:1);
zBlock1 = zBlock(11:end-10);

yBlock1 = yBlock(11:74);

% coordinate origin
yori = sum(yBlock)/2;
zori = sum(airLayer);
origin = [yori; zori];

%% real grids
yBlock1 = yBlock1';
zBlock1 = zBlock1';
yNode = cumsum([0, yBlock1])-sum(yBlock1)/2; 
zNode = cumsum([0, zBlock1])-0;

res = 1 ./ sig;

% extract core region
ymin = -6400; yspacing = 100.0; ymax = 6400;
zmin = 0;     zspacing = 100.0; zmax = 6000;

yInterp = ymin:yspacing:ymax;
zInterp = zmin:zspacing:zmax;
y = yInterp(1:end-1)+diff(yInterp)/2;
z = zInterp(1:end-1)+diff(zInterp)/2;
[interpModel, yiCen, ziCen, yCen, zCen] = sampleLoc(yInterp, zInterp, yNode, zNode, res);

%% core grid file
fid = fopen("model2501_coreRangeGrids.grd", "w");
ny = length(y);
nz = length(z);
fprintf(fid,"%4s\n","DSAA");
fprintf(fid,"%d\t %d\n",ny,nz);
fprintf(fid, "%10.4f\t %10.4f\n",min(y),max(y));
fprintf(fid, "%10.4f\t %10.4f\n",min(z),max(z));
fprintf(fid, "%10.4f\t %10.4f\n",log10(min(interpModel(:))),log10(max(interpModel(:))));
bb = log10(interpModel)';

for k = 1:nz
    for j = 1:ny
        fprintf(fid, "%10.4f\n", bb(k,j));
    end
end
fclose(fid);