function [inPolygon] = checkPoint(newPoint, beginningPoint, obstacles, nobst)

inSum = 0;
searchRes = 100;

xs = linspace(newPoint(1), beginningPoint(1), searchRes);
ys = linspace(newPoint(2), beginningPoint(2), searchRes);

for i = 1:nobst
    
    x_coords = obstacles.(strcat("O", num2str(i))).xCoords;
    y_coords = obstacles.(strcat("O", num2str(i))).yCoords;

    for j = 1:length(xs)
    in = inpolygon(xs(j), ys(j), x_coords, y_coords);

    inSum = inSum + in;
    end

end

if inSum > 0
    inPolygon = 1;
else
    inPolygon = 0;
end
end