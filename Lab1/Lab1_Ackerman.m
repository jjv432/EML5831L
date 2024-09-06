clc
clear
close all
format compact

Box.x = 0;
Box.y = 0;
Box.phi = 0;
Box.radius = 1;
Box.width = 2;
Box.length = 1;

Wheel.radius = .25;
Wheel.wheel_width = 0.125;

Wheel.gamma = -10*pi/180;

drawRobot_Ackerman(Box, Wheel);

%% 
%
% <include>drawRobot_Ackerman.m</include>
%