clc;clear;close all;

load("SelectTrainDataSetModel0729.mat");
sig_k1 = squeeze(sig_k(44,:,:));
imagesc(log10(1./(10 .^ sig_k1)))
colorbar
title("core restivity")

sig = squeeze(sig(44,:,:));

sig = 10.^(sig)';
sigma = sig(11:end,:)';


%% 2d forward model
nypad = 10;
nzpad = 10;
airLayer = zBlock(10:-1:1);
zBlock1 = zBlock(11:end);

% coordinate origin
yori = sum(yBlock)/2;
zori = sum(airLayer);
origin = [yori; zori];

figure
imagesc(log10(1 ./ sigma));
colorbar
title("grid scale restivity")

%% real grids
yBlock = yBlock';
zBlock = zBlock';
yNode = cumsum([0, yBlock])-sum(yBlock)/2; 
zNode = cumsum([0, zBlock])-zori;

res = 1 ./ sig;

% plotting coordinate
ymin = -100000; yspacing = 100.0; ymax = 100000;
zmin = -50000;     zspacing = 100.0; zmax = 50000;

yInterp = ymin:yspacing:ymax;
zInterp = zmin:zspacing:zmax;
y = yInterp(1:end-1)+diff(yInterp)/2;
z = zInterp(1:end-1)+diff(zInterp)/2;
[interpModel, yiCen, ziCen, yCen, zCen] = sampleLoc(yInterp, zInterp, yNode, zNode, res);

aa = log10(interpModel);
aa(aa>4)=4;
figure
imagesc(y/1000, (z)/1000, aa')
title("Selected restivity model")
colormap('parula');
ch = colorbar;
set(get(ch,'XLabel'),'String','log_{10}[\Omega\cdot m]','FontWeight','Bold');
set(gca,'ydir','reverse','fontsize',10.5,'layer','top');
axis([-100 100 -50 50]);
xlabel('x [km]');
ylabel('Depth [km]');


fid = fopen("wholeRangeGrids.grd", "w");
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

% extract core region
ymin = -6400; yspacing = 100.0; ymax = 6400;
zmin = 0;     zspacing = 100.0; zmax = 6000;

yInterp = ymin:yspacing:ymax;
zInterp = zmin:zspacing:zmax;
y = yInterp(1:end-1)+diff(yInterp)/2;
z = zInterp(1:end-1)+diff(zInterp)/2;
[interpModel, yiCen, ziCen, yCen, zCen] = sampleLoc(yInterp, zInterp, yNode, zNode, res);


fid = fopen("coreRangeGrids.grd", "w");
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

fid = fopen("line_y.txt", "w");
for i = 1:length(yNode)
    if yNode(i)/1000<6.4 && yNode(i)/1000>-6.4
        continue
    end
    fprintf(fid, "%-15.4f %10.4f\n", yNode(i)/1000, -50);
    fprintf(fid, "%-15.4f %10.4f\n", yNode(i)/1000, 50);
    fprintf(fid, "%-s\n", '>');
end
fclose(fid);

fid = fopen("line_z.txt", "w");
for i = 1:length(zNode)
    if zNode(i)/1000<6.0 && zNode(i)/1000>0
        continue
    end
    fprintf(fid, "%-15.4f %10.4f\n", -100, zNode(i)/1000);
    fprintf(fid, "%-15.4f %10.4f\n", 100, zNode(i)/1000);
    fprintf(fid, "%-s\n", '>');
end
fclose(fid);