function [inPolygon, newX, newY] = checkPoint(newPoint, beginningPoint, saved_map)

inSum = 0;
searchRes = 100;

xs = linspace(newPoint(1), beginningPoint(1), searchRes);
ys = linspace(newPoint(2), beginningPoint(2), searchRes);

for j = 1:length(xs)
    in = checkOccupancy(saved_map, [xs(j), ys(j)]);

    inSum = inSum + in;
    if in == 1
        break;
    end
end


if inSum > 0
    inPolygon = 1;
    
else
    inPolygon = 0;
    
end

newX = newPoint(1);
newY = newPoint(2);


end