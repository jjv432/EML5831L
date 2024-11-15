function [Obstacle] = makeObstacles(nobst, rad_min, rad_max, map)


xmin = map(1);
xmax = map(3);
ymin = map(2);
ymax = map(4);

drawThetas = linspace(0, 2*pi, 500);

previousShapes = [];
checkBool = 0;

for i = 1:nobst

    % Radius
    r =  rad_min + (rad_max - rad_min)*rand(1);
    
    x_circle = r*cos(drawThetas);
    y_circle = r * sin(drawThetas);

    % Position
    x_pos = xmin + (xmax - xmin)*rand(1);
    y_pos = ymin + (ymax - ymin)*rand(1);
    
   
    % Check X Pos
    Obstacle.(strcat("O", num2str(i))).xCoords = x_circle + x_pos;
    Obstacle.(strcat("O", num2str(i))).yCoords = y_circle + y_pos;

end

end