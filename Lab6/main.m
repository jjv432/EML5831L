%% LAB 2
% Implement RRT from a saved map

% 1. Use the 'StartRCKeyboardWMap' command to drive the robot around an 
% obstacle course and see the map

% 2. Use 'RC.saveMap()' afterwards to save the map data to a file. Copy the
% file to this directory

clc
clear
close all

addpath("../Lab5/rc-labs/rc-matlab-lib")
%%

load('OccupancyGridSave.mat')
mapAxes = [0 5 -2 1];
% Use the inflate() function to inflate the obstacles
inflate_size = 0.01; % m
inflate(saved_map, inflate_size)

% Use the show() function to plot your map
show(saved_map)
axis(mapAxes)

% Use the checkOccupancy() function to check the occupancy at some position
check_x = 0; % m
check_y = 0; % m
val = checkOccupancy(saved_map, [check_x check_y]); % < 0.5 for empty, > 0.5 for occupied

% Set your start and goal positions
start_position = [0 0];
goal_position = [4; -.5];

%% Perform RRT search

map = mapAxes;

radius_min = .5;

%%

xmin = map(1);
xmax = map(2);
ymin = map(3);
ymax = map(4);


%% Generating q_goal and q_init
q_init_x = start_position(1);
q_init_y = start_position(2);
q_goal_x = goal_position(1);
q_goal_y = goal_position(2);

hold on
plot(q_goal_x, q_goal_y, 'kx')
plot(q_init_x, q_init_y,'kx')

goalBool = 0;

lookahead = .1;

NodeList = [q_init_x; q_init_y; 1];
currentNode = [q_init_x, q_init_y];

waypointThreshold = lookahead/2;


%% Drawing nodes
goalBool = 1;
phi = 0;

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


    % Checking for obstacles
    [inPolygon, newX, newY] = checkPoint([possibleX, possibleY], [bestNodeX, bestNodeY], saved_map, phi, lookahead, radius_min);

    % Assign the waypoint x and y position to the 'radius-fixed' waypoint
    possibleX = newX;
    possibleY = newY;

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
        % This is for the modulus thing
        j = j+1;
    end

    

    phi = atan2(NodeList(2, j) - NodeList(2, j-1), NodeList(1,j)- NodeList(1, j-1));

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
% Plot your results on the saved map