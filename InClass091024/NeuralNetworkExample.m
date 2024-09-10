clc
clear all
close all
format compact

% One input, one hidden layer, one output

nsamp = 1000; %number of samples used

a = -2*pi;
b = 2*pi;

rx = a + (b-a) * rand(nsamp,1);