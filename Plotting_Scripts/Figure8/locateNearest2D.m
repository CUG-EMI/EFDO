function [ind]=locateNearest2D(point, yCen, zCen)
    ind = zeros(1,2);
    y1 = abs(point(1)-yCen);
    [~, ind(1)] = min(y1);
    z1 = abs(point(2)-zCen);
    [~, ind(2)] = min(z1);
end