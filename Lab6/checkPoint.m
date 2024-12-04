function [inPolygon, newX, newY] = checkPoint(newPoint, beginningPoint, saved_map, phi, lookahead, radius_min)

% val = checkOccupancy(saved_map, [check_x check_y]);

%vobstacles
inSum = 0;
searchRes = 100;

xs = linspace(newPoint(1), beginningPoint(1), searchRes);
ys = linspace(newPoint(2), beginningPoint(2), searchRes);

for j = 1:length(xs)
    in = checkOccupancy(saved_map, [xs(j), ys(j)]);

    inSum = inSum + in;
end


if inSum > 0
    inPolygon = 1;
else
    inPolygon = 0;
end

% turn radius fixing

rotMatrix = [cos(phi) sin(phi); -sin(phi) cos(phi)];
deltaX = newPoint(1) - beginningPoint(1);
deltaY = newPoint(2) - beginningPoint(2);

newCoords = rotMatrix*[deltaX; deltaY];

xl = newCoords(1);
yl = newCoords(2);

turn_radius = lookahead^2 / 2 * yl;

% only change the new waypoint if it doesnt fit on a turn radius
if turn_radius < radius_min

    % something about this math is wrong
    turn_radius = radius_min;
    yl = lookahead^2 / (2 * turn_radius) + beginningPoint(2);
    xl = sqrt(lookahead^2 - yl^2) + beginningPoint(1);

    newGlobal = rotMatrix' * [xl; yl];

    % newX = newGlobal(1);
    % newY = newGlobal(2);

else
    % newX = newPoint(1);
    % newY = newPoint(2);
end

% This format works, it's just the calculations above that are wrong
newX = newPoint(1);
newY = newPoint(2);


end