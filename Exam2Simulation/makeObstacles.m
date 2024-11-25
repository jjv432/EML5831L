function [Obstacle] = makeObstacles(obst_posns, rad, u_posn, limits)


%% Making circular shapes

drawThetas = linspace(0, 2*pi, 500);


for i = 1:size(obst_posns, 1)

    % Radius
    r =  rad;
    
    x_circle = r*cos(drawThetas);
    y_circle = r * sin(drawThetas);

    % Position
    x_pos = obst_posns(i, 1);
    y_pos = obst_posns(i, 2);
   
    % Check X Pos
    Obstacle.(strcat("O", num2str(i))).xCoords = x_circle + x_pos;
    Obstacle.(strcat("O", num2str(i))).yCoords = y_circle + y_pos;

end

%% Making the U shape

u_x_vals = [zeros(1, 5), linspace(0, 1, 5), ones(1,5), linspace(1, 0, 5), zeros(1,5), linspace(0, 1.25, 5), 1.25*ones(1,5), linspace(1.25, 0, 5)];
u_y_vals = [linspace(0, .25, 5) .25*ones(1,5), linspace(.25, 1.5, 5), 1.5*ones(1,5), linspace(1.5, 1.75, 5), 1.75*ones(1,5), linspace(1.75, 0, 5), zeros(1,5)];

theta = u_posn(3);
rotMatrix = [cos(theta), -sin(theta); sin(theta), cos(theta)];
coords = rotMatrix * [u_x_vals; u_y_vals];

Obstacle.OU.xCoords = coords(1, :) + u_posn(1);
Obstacle.OU.yCoords = coords(2,:) + u_posn(2);

end