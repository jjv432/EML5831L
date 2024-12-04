clc
close all
clearvars
addpath("../Lab5/rc-labs/rc-matlab-lib")

%% Step 0: Setup and Parameters

RC = RCCar();

resetMap(RC);
RC.setSteeringAngle(0);
RC.setSpeed(0);

mapAxes = [-5 5 -5 5];

inflate_size = 0.01; % m

start_position = [0 0];
goal_position = [4; 0];
goalBool = 0;
%% Run this loop until getting to the goal

while goalBool == 0

%% Step 1: Generate Map Using LIDAR

map = RC.getMap();
mapf = readOccupancyGrid(map);
map = mapf;

inflate(map, inflate_size)

show(map);
axis(mapAxes)


%% Step 2: Set start pose as RC.X and RC.Y

start_position = [RC.X RC.Y];

%% Step 3: Perform the RRT from Start to Goal

lookahead = .5;
plotBool = 0;

[NodeList, indices] = my_RRT(start_position, goal_position, lookahead, mapAxes, map, plotBool);

%% Step 4: Run Pure-Pursuit

% This is gonna run through all of the purepursuit rn
my_PurePursuit(NodeList, RC, indices);


%% Step 5: Check if the robot is close enough to the goal

distance2Goal = euclideanRobot2Goal(RC, goal_position);

goalThreshold = .5;

if distance2Goal <= goalThreshold
    goalBool = 1;
    
end

end

RC.setSpeed(0);
RC.setSteeringAngle(0);