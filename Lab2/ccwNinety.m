clc
clear
close all
format compact

%%

sample_length = 400;
circle_radius = .25;

phi(1) = 0;

x_vals = circle_radius * cos(linspace(-pi/2, 0, sample_length));
y_vals = circle_radius * sin(linspace(-pi/2, 0, sample_length));

x_vals = x_vals - x_vals(1);
y_vals = y_vals - y_vals(1);

for i = 2:sample_length
    temp = phi(i-1) + (pi/2)/sample_length;
    phi(i) = temp;
end

trajectoryPlotter(x_vals, y_vals, phi);