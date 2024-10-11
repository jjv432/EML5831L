clc
clear
close all
format compact

%%

sample_length = 400;
dt= 0.01;
vx=0.2;
x_vals=0;
y_vals=0;
phi(1)=0;


for i = 2:sample_length
    x_vals(i) = x_vals(i-1) + vx*cos(phi(i-1))*dt;
    y_vals(i) = y_vals(i-1) + vx*sin(phi(i-1))*dt;
    phi(i) = phi(i-1) - (0)/sample_length;   
end

trajectoryPlotter(x_vals, y_vals, phi);

%%
%
% <include>drawRobot.m</include> 
%
%
% <include>trajectoryPlotter.m</include> 
%