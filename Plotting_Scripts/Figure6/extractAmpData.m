close all;clear;clc;
load("multiAmpData.mat");
ii = [10, 60, 140, 160, 230];
yBlock = yBlock';
zBlock = zBlock';
for m=1:length(ii)
    ind=ii(m);
    sig1 = squeeze(sig(ind,:,:));
    
    sig1 = 10.^(sig1);
    sigma = sig1(11:end,:)';

    nypad = 10;
    nzpad = 10;
    airLayer = zBlock(10:-1:1);
    zBlock = zBlock(11:end);
    
    % coordinate origin
    yori = sum(yBlock)/2;
    zori = 0;
    origin = [yori; zori];
    
    
    ny = length(yBlock);
    nz = length(zBlock);
    
    %% real grids
    yNode = cumsum([0, yBlock(nypad+1:ny-nypad)])-sum(yBlock(nypad+1:ny-nypad))/2; 
    zNode = cumsum([0, zBlock(1:nz-nzpad)]);
    
    res = 1 ./ sigma(nypad+1:ny-nypad,1:nz-nzpad);
    
    % plotting coordinate
    ymin = -6400.0; yspacing = 100.0; ymax = 6400.0;
    zmin = 0;     zspacing = 100.0; zmax = 6000.0;
    % 
    yInterp = ymin:yspacing:ymax;
    zInterp = zmin:zspacing:zmax;
    y1 = yInterp(:);
    z1 = zInterp(:);
    y = y1(1:end-1)+diff(y1)/2;
    z = z1(1:end-1)+diff(z1)/2;
    [interpModel, yiCen, ziCen, yCen, zCen] = sampleLoc(yInterp, zInterp, yNode, zNode, res);
%     imagesc(y, z, log10(interpModel)')
    fileName = sprintf("%s%d%s",'alpha_', m, '.grd');
    fid = fopen(fileName, "w");
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
    
end