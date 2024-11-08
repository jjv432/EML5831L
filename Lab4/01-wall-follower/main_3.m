clc; close all; format compact;

addpath('../rc-labs/rc-matlab-lib');

%RC = RCCar();

resetMap(RC);

%Second dimension is left and right
Waypoint = [.5 0];

threshold = .05;

RC.setSteeringAngle(0);
RC.setSpeed(0);

while sqrt((Waypoint(1) - RC.X)^2 + (Waypoint(2) - RC.Y)^2) > threshold

    phi = RC.Phi;

    RotMatrix = [cos(phi) sin(phi); -sin(phi) cos(phi)];

    local = RotMatrix * [(Waypoint(1) - RC.X); (Waypoint(2) -RC.Y)];

    l_squared = local(1)^2 + local(2)^2;

    radius = l_squared / (2 * local(2));

    localPhi = atan2(local(2), local(1));

    gamma = radius * (.25/.715);

    % If it needs to steer too hard, back up a bit to make the turn less
    % brutal
    localPhi * 180/pi

    if localPhi < -pi/4
        RC.setSpeed(-.25);
        RC.setSteeringAngle(0)
    elseif localPhi > pi/4
        RC.setSpeed(-.25);
        RC.setSteeringAngle(0)
    else
        RC.setSpeed(.25);
        RC.setSteeringAngle(gamma)
    end

    if gamma > .25
        RC.setSteeringAngle(.25);

    elseif gamma < -.25
        RC.setSteeringAngle(-.25);
    end

    % if gamma > .25
    %     RC.setSteeringAngle(-.25)
    %     RC.setSpeed(-.25);
    % elseif gamma < -.25
    %     RC.setSteeringAngle(.25)
    %     RC.setSpeed(.25);
    % else
    %     RC.setSpeed(.25);
    %     RC.setSteeringAngle(gamma);
    % end
    %
    % if local(1) > 0
    %     gamma = -gamma;
    % end

    pause(.05);

end

RC.setSteeringAngle(0);
RC.setSpeed(0);

