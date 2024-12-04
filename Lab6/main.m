%% LAB 2
% Implement RRT from a saved map

% 1. Use the 'StartRCKeyboardWMap' command to drive the robot around an 
% obstacle course and see the map

% 2. Use 'RC.saveMap()' afterwards to save the map data to a file. Copy the
% file to this directory

clc
clearvars
close all

addpath("../Lab5/rc-labs/rc-matlab-lib")

%%

load('OccupancyGridSave.mat')


%% Step 0: Setup and Parameters

% RC = RCCar();
% 
% resetMap(RC);
% RC.setSteeringAngle(0);
% RC.setSpeed(0);

mapAxes = [0 5 -2 1];
% Use the inflate() function to inflate the obstacles
inflate_size = 0.01; % m

start_position = [0 0];
goal_position = [4; -.5];
%% Run this loop until getting to the goal

% while goalBool == 0

%% Step 1: Generate Map Using LIDAR

% map = RC.getMap();
% inflate(map, inflate_size)
% show(map);
% axis(mapAxes)

inflate(saved_map, inflate_size)
show(saved_map);
axis(mapAxes)

%% Step 2: Set start pose as RC.X and RC.Y

% Temporary
RC.X = 0; 
RC.Y = 0;

start_position = [RC.X RC.Y];

%% Step 3: Perform the RRT from Start to Goal

lookahead = .5;

[Nodelist] = my_RRT(start_position, goal_position, lookahead, mapAxes, saved_map);

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
      
            radius = l_squared / (2 * local(2));
        
        % Calculate steering angle (gamma)
        gamma = radius * (0.25 / 0.715); % Adjust constants based on your robot's dynamics

        % Determine motion based on waypoint position in the robot's frame
        localPhi = atan2(local(2), local(1));
        if localPhi < -pi/4
            % Too far left, reverse slightly
            RC.setSpeed(-0.25);
            RC.setSteeringAngle(.125);
        elseif localPhi > pi/4
            % Too far right, reverse slightly
            RC.setSpeed(-0.25);
            RC.setSteeringAngle(-.125);
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