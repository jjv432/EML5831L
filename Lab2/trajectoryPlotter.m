function [] = trajectoryPlotter(x_vals, y_vals, phi)

Box.x = 5;
Box.y = 0;
Box.phi = pi/4;
Box.radius = 0.0635;
Box.width = 2*0.131;
Box.length = .2032;

Wheel.radius = 0.0635;
Wheel.wheel_width = 0.06;

drawRobot(Box, Wheel);

sample_length = 100;

%figure()
Box.phi = pi/2;
for i = 1:length(x_vals)
    Box.x = x_vals(i);
    Box.y = y_vals(i);
    Box.phi = phi(i);
    drawRobot(Box, Wheel);
    pause(0);


end

end