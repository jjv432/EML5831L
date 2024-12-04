function [] = my_PurePursuit(NodeList, RC, indices)

%% Purepursuit
threshold = 0.2; % Threshold to determine if the robot has reached the waypoint

idx = 1;
    % Get the current and next waypoint
    Waypoint = [NodeList(1, indices(idx + 1)), NodeList(2, indices(idx + 1))];

    while sqrt((Waypoint(1) - RC.X)^2 + (Waypoint(2) - RC.Y)^2) > threshold
        phi = RC.Phi;
        
        % Transform waypoint to the robot's frame
        RotMatrix = [cos(phi), sin(phi); -sin(phi), cos(phi)];
        local = RotMatrix * [(Waypoint(1) - RC.X); (Waypoint(2) - RC.Y)];
        
        % Turn radius calculations
        l_squared = local(1)^2 + local(2)^2;
      
            radius = l_squared / (2 * local(2));
        
        % Calculate steering angle (gamma)
        gamma = radius * (0.25 / 0.715); % Adjust constants based on your robot's dynamics

        % Determine motion based on waypoint position in the robot's frame
        localPhi = atan2(local(2), local(1));
        if localPhi < -pi/4
            % Too far left, reverse slightly
            RC.setSpeed(-0.25);
            RC.setSteeringAngle(.125);
        elseif localPhi > pi/4
            % Too far right, reverse slightly
            RC.setSpeed(-0.25);
            RC.setSteeringAngle(-.125);
        else
            % Forward motion towards waypoint
            RC.setSpeed(0.25);
            RC.setSteeringAngle(min(max(gamma, -0.25), 0.25)); % Constrain steering angle
        end

        pause(0.05); % Small delay for command execution
    end
end
