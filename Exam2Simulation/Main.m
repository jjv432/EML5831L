clc; clear all; close all; format compact;

%% Notes

%{

    Need to implement the PID part that is in the notes

%}

%% Robot Characteristics
Robot.x = 0;
Robot.y = 0;
Robot.phi = pi/4;
Robot.radius = 1;
Robot.width = .125;
Robot.length = Robot.width/2;
Robot.velocity = 1;

Wheel.radius = Robot.length/4;
Wheel.wheel_width = Wheel.radius;

%% Obstacle creation

obst_radius = .1;

obstPosns = [1 1.5; 3 1; 3 2];
map = [0 5 0 5];

figure;
grid on

Obstacle = makeObstacles(obstPosns, obst_radius, [3.5 2 pi/4], map);
nobst = size(obstPosns, 1);

for i = 1:nobst
    hold on
    fill(Obstacle.(strcat("O", num2str(i))).xCoords, Obstacle.(strcat("O", num2str(i))).yCoords, 'r')
    axis equal
    axis(map)
end

fill(Obstacle.OU.xCoords, Obstacle.OU.yCoords, "g")
numsegments = size(Obstacle.OU.xCoords, 2) - 1;

for i = 1:numsegments

    segment_x(i) = mean(Obstacle.OU.xCoords(i:i+1));
    segment_y(i) = mean(Obstacle.OU.yCoords(i:i+1));
    segment_phi(i) = atan2(Obstacle.OU.yCoords(i+1) - Obstacle.OU.yCoords(i), Obstacle.OU.xCoords(i+1) - Obstacle.OU.xCoords(i));

end


%% Go to Goal

y_goal = 4;
x_goal = 4;
plot(x_goal, y_goal, 'bo')
goalThreshold = .1;
dt = .05;
state = 1;

obstTolTowards = .5;
obstTolAway = .75;
wallToleranceTowards = .3;
wallToleranceAway = .3;

while getEuclideanDist([Robot.x Robot.y], [x_goal y_goal]) > goalThreshold
    closestDistance = inf;
    
    distToGoal = getEuclideanDist([Robot.x Robot.y], [x_goal y_goal]);

    distToObstacle1 = getEuclideanDist([Robot.x Robot.y], [obstPosns(1, 1), obstPosns(1, 2)]);
    distToObstacle2 = getEuclideanDist([Robot.x Robot.y], [obstPosns(2, 1), obstPosns(2, 2)]);
    distToObstacle3 = getEuclideanDist([Robot.x Robot.y], [obstPosns(3, 1), obstPosns(3, 2)]);

    phiObst1 = atan2(obstPosns(1,2) - Robot.y, obstPosns(1,1) - Robot.x);
    phiObst2 = atan2(obstPosns(2,2) - Robot.y, obstPosns(2,1) - Robot.x);
    phiObst3 = atan2(obstPosns(3,2) - Robot.y, obstPosns(3,1) - Robot.x);

    % Finding out which segment of the wall the robot is the closest to
    for z = 1:numsegments 
        curDistance = getEuclideanDist([Robot.x Robot.y], [segment_x(z) segment_y(z)]);
        if curDistance < closestDistance
            closestDistance = curDistance;
            closestSegmentIndex = z;
        end
    end
    closestSegmentIndex

phi_goal = atan((y_goal - Robot.y) / (x_goal - Robot.x));

    switch state

        case 1 % Go to goal case
            
            phi_d = phi_goal;
     
            if (distToObstacle1 < obstTolTowards)
                state = 2;
                phi_d = phiObst1 + pi;
            elseif (distToObstacle2 < obstTolTowards)
                state = 2;
                phi_d = phiObst2 + pi;
            elseif (distToObstacle3 < obstTolTowards)
                state = 2;
                phi_d = phiObst3 + pi;
            elseif (closestDistance < wallToleranceTowards)
                state = 3;
            end

        case 2 % Obstacle avoidance
       
            if distToObstacle1 > obstTolAway
                state = 1;
            end

        case 3 % Wall Following
            
            mu_CW = segment_phi(closestSegmentIndex);
            mu_CCW = -segment_phi(closestSegmentIndex);

            if abs(phi_d) - abs(mu_CW) <= pi
                phi_d = mu_CW;
            else
                phi_d = mu_CCW;
            end

            if (closestDistance > wallToleranceAway) && (abs(phi_goal - phi_d) <= pi)
                state = 1;
            end


    end

    x_dot = Robot.velocity * cos(phi_d);
    y_dot = Robot.velocity * sin(phi_d);
    Robot.phi = phi_d;
    Robot.y = y_dot * dt + Robot.y;
    Robot.x = x_dot * dt + Robot.x;
    

    [h1, h2, h3] = drawRobot(Robot, Wheel);
    pause(dt);
    delete(h1);
    delete(h2);
    delete(h3);
   
end
