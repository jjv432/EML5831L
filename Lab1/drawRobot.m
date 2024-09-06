function [] = drawRobot(Box)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

x_box = [-1 -1 1 1 -1];
y_box = [0.5 -0.5 -0.5 0.5 0.5];

x = Box.x;
y = Box.y;
phi = Box.phi;

rot_matrix = [cos(phi), -sin(phi); sin(phi), cos(phi)];
box_rotated = rot_matrix * [x_box; y_box];

box_translated_rotated = [box_rotated(1,:) + x; box_rotated(2,:) + y];

figure()
    fill(box_translated_rotated(1,:), box_translated_rotated(2,:), 'r');
    grid on
    


end