clc;
clear all;
close all;
format compact;

%%

nobst = 4;
rad_min = .25;
rad_max = 1.25;
map = [0 10; 0 10];

Obstacle = makeObstacles(nobst, rad_min, rad_max, map);

%%
figure();

for i = 1:nobst
    hold on
    fill(Obstacle.(strcat("O", num2str(i))).xCoords, Obstacle.(strcat("O", num2str(i))).yCoords, 'r')
    axis equal
end

%%
% point = [4, 0];
% [inPoint] = checkPoint(point, Obstacle, nobst);

%% Generating q_goal and q_init

[q_goal_x, q_goal_y] = ginput(1);
[q_init_x, q_init_y] = ginput(1);

plot(q_goal_x, q_goal_y, 'kx')
plot(q_init_x, q_init_y,'kx')

goalBool = 0;

lookahead = .2;

NodeList = [q_init_x; q_init_y];
currentNode = [q_init_x, q_init_y];

waypointThreshold = lookahead/2;



%% Drawing nodes
j = 1;
while curDistance > waypointThreshold
    smallestDistance = inf;
    xmin = map(1);
    xmax = map(3);
    ymin = map(2);
    ymax = map(4);

    if (mod(j, 10) == 0)
        randPointX = q_goal_x;
        randPointY = q_goal_y;
    else
        randPointX  = xmin + (xmax - xmin)*rand(1);
        randPointY = ymin + (ymax - ymin)*rand(1);
    end

    % Checking for the nearest node
    for i = 1:size(NodeList, 2)

        % Get euclidean distance from current rand point to each node in
        % the list
        curDistance = sqrt((randPointX-NodeList(1, i))^2 + (randPointY-NodeList(2, i))^2);

        if curDistance < smallestDistance
            bestNodeIndex = i;
            smallestDistance = curDistance;
        end

    end

    bestNodeX = NodeList(1, bestNodeIndex);
    bestNodeY= NodeList(2, bestNodeIndex);
    newNodeX = bestNodeX + lookahead * cos(atan2((randPointY - bestNodeY), (randPointX- bestNodeX)));
    newNodeY = bestNodeY + lookahead * sin(atan2((randPointY - bestNodeY), (randPointX- bestNodeX)));

    NodeList = horzcat(NodeList, [newNodeX; newNodeY]);

    plot(newNodeX, newNodeY, 'gx');
    drawnow;

    j = j+1;



end