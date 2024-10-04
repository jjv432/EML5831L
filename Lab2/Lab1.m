clc
clear
close all
format compact

Box.x = 5;
Box.y = 5;
Box.phi = pi/4;
Box.radius = 0.0635;
Box.width = 2*0.131;
Box.length = .2032;

Wheel.radius = 0.0635;
Wheel.wheel_width = 0.06;

drawRobot(Box, Wheel);

sample_length = 100;
circle_radius = 3;

x_vals = circle_radius * cos(linspace(0, 2*pi, sample_length));
y_vals = circle_radius * sin(linspace(0, 2*pi, sample_length));

%figure()
Box.phi = pi/2;
for i = 1:length(x_vals)
    Box.x = x_vals(i);
    Box.y = y_vals(i);
    Box.phi = Box.phi + 2*pi/sample_length;
    drawRobot(Box, Wheel);
    pause(0)


end
%%
%
% <include>drawRobot.m</include> 
%