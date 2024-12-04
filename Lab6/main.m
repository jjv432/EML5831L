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

%% Purepursuit
threshold = 0.05; % Threshold to determine if the robot has reached the waypoint
RC.setSpeed(0); % Reset any motion before starting
RC.setSteeringAngle(0);

for idx = 1:length(indices) - 1
    % Get the current and next waypoint
    Waypoint = [NodeList(1, indices(idx + 1)), NodeList(2, indices(idx + 1))];

    while sqrt((Waypoint(1) - RC.X)^2 + (Waypoint(2) - RC.Y)^2) > threshold
        phi = RC.Phi;
        
        % Transform waypoint to the robot's frame
        RotMatrix = [cos(phi), sin(phi); -sin(phi), cos(phi)];
        local = RotMatrix * [(Waypoint(1) - RC.X); (Waypoint(2) - RC.Y)];
        
        % Turn radius calculations
        l_squared = local(1)^2 + local(2)^2;
        if local(2) ~= 0
            radius = l_squared / (2 * local(2));
        else
            radius = inf; % If straight ahead, assume large radius
        end
        
        % Calculate steering angle (gamma)
        gamma = radius * (0.25 / 0.715); % Adjust constants based on your robot's dynamics
        
        % Determine motion based on waypoint position in the robot's frame
        localPhi = atan2(local(2), local(1));
        if localPhi < -pi/4
            % Too far left, reverse slightly
            RC.setSpeed(-0.25);
            RC.setSteeringAngle(0);
        elseif localPhi > pi/4
            % Too far right, reverse slightly
            RC.setSpeed(-0.25);
            RC.setSteeringAngle(0);
        else
            % Forward motion towards waypoint
            RC.setSpeed(0.25);
            RC.setSteeringAngle(min(max(gamma, -0.25), 0.25)); % Constrain steering angle
        end

        pause(0.05); % Small delay for command execution
    end
end

% Stop the robot at the end
RC.setSteeringAngle(0);
RC.setSpeed(0);