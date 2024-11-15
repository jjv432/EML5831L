function [inPolygon] = checkPoint(point, obstacles, nobst)

inSum = 0;

for i = 1:nobst
    
    x_coords = obstacles.(strcat("O", num2str(i))).xCoords;
    y_coords = obstacles.(strcat("O", num2str(i))).yCoords;

    in = inpolygon(point(1), point(2), x_coords, y_coords);

    inSum = inSum + in;


end

if inSum > 0
    inPolygon = 1;
else
    inPolygon = 0;
end
end