function [] = drawRobot(Box, Wheel)

% All for main body
length = Box.length; %y-direction
width = Box.width; % x-direction

y_box = [-length/2 -length/2 length/2 length/2 -length/2];
x_box = [width/2 -width/2 -width/2 width/2 width/2];

x = Box.x;
y = Box.y;
phi = Box.phi;

rot_matrix = [cos(phi), -sin(phi); sin(phi), cos(phi)];
box_rotated = rot_matrix * [x_box; y_box];

box_translated_rotated = [box_rotated(1,:) + x; box_rotated(2,:) + y];


% Wheels
radius = Wheel.radius;
wheel_width = Wheel.wheel_width; %y direction

% Left wheel
x_left_wheel = [(-width/2 - radius), (-width/2 -radius), (-width/2 + radius), (-width/2 + radius), (-width/2 - radius)]; 
y_left_wheel = [(length/2 + wheel_width), (length/2), (length/2), (length/2 + wheel_width), (length/2 + wheel_width)];

left_wheel_rotated = rot_matrix * [x_left_wheel; y_left_wheel];

left_wheel_rotated_translated = [left_wheel_rotated(1,:) + x; left_wheel_rotated(2,:) + y];

% Right Wheel

x_right_wheel = [(-width/2 - radius), (-width/2 -radius), (-width/2 + radius), (-width/2 + radius), (-width/2 - radius)]; 
y_right_wheel = [(-length/2 - wheel_width), (-length/2), (-length/2), (-length/2 - wheel_width), (-length/2 - wheel_width)];

right_wheel_rotated = rot_matrix * [x_right_wheel; y_right_wheel];

right_wheel_rotated_translated = [right_wheel_rotated(1,:) + x; right_wheel_rotated(2,:) + y];

%Plotting
clf
hold on


    fill(right_wheel_rotated_translated(1,:), right_wheel_rotated_translated(2,:), 'k')
    hold on
    fill(left_wheel_rotated_translated(1,:), left_wheel_rotated_translated(2,:), 'k')
    hold on
    fill(box_translated_rotated(1,:), box_translated_rotated(2,:), 'r');
    grid on
    axis equal
    axis([-10 10 -10 10])


end