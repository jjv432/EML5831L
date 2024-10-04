clc
clear
close all
format compact

%%

sample_length = 100;

x_vals = (linspace(0, 2*pi, sample_length));
y_vals = 0*(ones(sample_length, 1));

trajectoryPlotter(x_vals, y_vals);

%%
%
% <include>drawRobot.m</include> 
%
%
% <include>trajectoryPlotter.m</include> 
%