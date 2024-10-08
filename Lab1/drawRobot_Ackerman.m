function [] = drawRobot_Ackerman(Box, Wheel)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% All for main body
length = Box.length; %y-direction
width = Box.width; % x-direction

y_box = [-length/2 -length/2 length/2 length/2 -length/2];
x_box = [width 0 0 width width];

x = Box.x;
y = Box.y;
phi = Box.phi;

rot_matrix = [cos(phi), -sin(phi); sin(phi), cos(phi)];
box_rotated = rot_matrix * [x_box; y_box];

box_translated_rotated = [box_rotated(1,:) + x; box_rotated(2,:) + y];


% Wheels
radius = Wheel.radius;
wheel_width = Wheel.wheel_width; %y direction


%Back Wheel

x_back_wheel = [(-radius), ( -radius), (radius), (radius), (-radius)];
y_back_wheel = [wheel_width, -wheel_width, -wheel_width, wheel_width, wheel_width];

back_wheel_rotated = rot_matrix * [x_back_wheel; y_back_wheel];

back_wheel_translated_rotated = [back_wheel_rotated(1,:) + x; back_wheel_rotated(2,:) + y];


%Front Wheel
gamma = Wheel.gamma;

x_front_wheel = [(-radius), ( -radius), (radius), (radius), (-radius)];
y_front_wheel = [wheel_width, -wheel_width, -wheel_width, wheel_width, wheel_width];

front_rot_matrix = [cos(gamma), -sin(gamma); sin(gamma), cos(gamma)];
front_wheel_steered = front_rot_matrix * [x_front_wheel; y_front_wheel];

front_wheel_translated = [(front_wheel_steered(1,:) + width); front_wheel_steered(2,:)];

front_wheel_rotated = rot_matrix * [front_wheel_translated(1,:); front_wheel_translated(2,:)];

%Plotting
figure()
fill(box_translated_rotated(1,:), box_translated_rotated(2,:), 'b')
hold on
fill(back_wheel_translated_rotated(1,:), back_wheel_translated_rotated(2,:), 'k');
hold on
fill(front_wheel_rotated(1,:), front_wheel_rotated(2,:), 'k')
axis equal