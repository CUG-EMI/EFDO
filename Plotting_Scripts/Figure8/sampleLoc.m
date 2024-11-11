function [interpModel, yiCen, ziCen, yCen, zCen] = sampleLoc(yInterp, zInterp, yNode, zNode, rho)

    yiCen = yInterp(1:end-1) + diff(yInterp) / 2;
    ziCen = zInterp(1:end-1) + diff(zInterp) / 2;
    
    yCen = yNode(1:end-1) + diff(yNode) / 2;
    zCen = zNode(1:end-1) + diff(zNode) / 2;
%     yCen = yNode(1:end-1) ;
%     zCen = zNode(1:end-1) ;
    
    ny = length(yInterp) - 1;
    nz = length(zInterp) - 1;
    
    interpModel = zeros(ny, nz);
    for k = 1:nz
        for j = 1:ny
              point = [yiCen(j) ziCen(k)];
              inds  = locateNearest2D(point, yCen, zCen);
              interpModel(j, k) = rho(inds(1), inds(2));
        end
    end

end


