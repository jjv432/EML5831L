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

u_x_vals = [zeros(1, 4), linspace(0, .8, 4), ones(1,4), linspace(1, .2, 4), zeros(1,4), linspace(0, 1, 4), 1.25*ones(1,5), linspace(1.25, 0.25, 4)];
u_y_vals = [linspace(0, .2, 4), .25*ones(1,4), linspace(.25, 1.25, 4), 1.5*ones(1,4), linspace(1.5, 1.7, 4), 1.75*ones(1,5), linspace(1.4, .28, 4), zeros(1,4)];

theta = u_posn(3);
rotMatrix = [cos(theta), -sin(theta); sin(theta), cos(theta)];
coords = rotMatrix * [u_x_vals; u_y_vals];

Obstacle.OU.xCoords = coords(1, :) + u_posn(1);
Obstacle.OU.yCoords = coords(2,:) + u_posn(2);

end