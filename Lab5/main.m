clc;
clear all;
close all;
format compact;

%%

nobst = 10;
rad_min = .25;
rad_max = 1.25;
map = [0 10; 0 10];

Obstacle = makeObstacles(nobst, rad_min, rad_max, map);

%%
figure();
xmin = map(1);
xmax = map(3);
ymin = map(2);
ymax = map(4);

axis([xmin xmax ymin ymax])

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

lookahead = .1;

NodeList = [q_init_x; q_init_y; 1];
currentNode = [q_init_x, q_init_y];

waypointThreshold = lookahead/2;



%% Drawing nodes
goalBool = 1;


j = 1;
while goalBool
    smallestDistance = inf;


    % Every 10 loops, make x and y the goal, otherwise random
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

    % Assigning position for the new node
    bestNodeX = NodeList(1, bestNodeIndex);
    bestNodeY= NodeList(2, bestNodeIndex);
    possibleX = bestNodeX + lookahead * cos(atan2((randPointY - bestNodeY), (randPointX- bestNodeX)));
    possibleY = bestNodeY + lookahead * sin(atan2((randPointY - bestNodeY), (randPointX- bestNodeX)));

    [inPolygon] = checkPoint([possibleX, possibleY], Obstacle, nobst);

    if inPolygon == 0
        newNodeX = possibleX;
        newNodeY = possibleY;

        % Adding the current node to the list of nodes
        NodeList = horzcat(NodeList, [newNodeX; newNodeY; bestNodeIndex]);

        % Plot the new node on the same figure
        plot(newNodeX, newNodeY, 'gx');
        drawnow;

        % Find the distance to the goal and stop if it closer than the
        % threshold
        dist2goal = sqrt((newNodeX-q_goal_x)^2 + (newNodeY-q_goal_y)^2);
        if dist2goal < waypointThreshold

            goalBool = 0;
        end
    end



    % This is for the modulus thing
    j = j+1;

end

%% Finding the path from end to beginning
plotIndex = size(NodeList, 2);
indices = plotIndex;
while plotIndex > 1

    plotIndex = NodeList(3, plotIndex);
    indices = [indices, plotIndex];

end

indices = flip(indices);

for i = 1:length(indices)
    plot(NodeList(1, indices(i)), NodeList(2, indices(i)), 'bo');
    drawnow;
end