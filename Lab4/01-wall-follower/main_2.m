clc;

close all;
format compact;

addpath('../rc-matlab-lib');

%RC = RCCar();

% This code was used to determine the turn radius of the car
x = .25;
for i = 1:2250
RC.setSpeed(0.5);
RC.setSteeringAngle(x);% where x [-0.25,0.25]
end

% 143 cm diameter when speed is .25 and angle is .25

%L = (143/2) * tan(.25);
% L = .1826