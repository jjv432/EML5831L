%% LAB 1 - PART 1
% Maintain a fixed distance from the wall by implementing a PD controller

clc
clear
close all

%%

addpath('../rc-labs/rc-matlab-lib');

% ConnectToROS();
% Connect to RC
RC = RCCar();

% Params
KP = .5; % UPDATE THIS
KD = 17; % UPDATE THIS

divisor = 1;

KP = KP / divisor;
KD = KD/ divisor;
desiredDistance = 0.5; % m
duration = 10.0; % s
frequency = 20.0; % Hz
totalTimeSteps = duration * frequency;
speed = 0.5; % m/s

% Variable histories
currentTime_History = nan(1, totalTimeSteps);
distanceError_History = nan(1, totalTimeSteps);
steeringAngle_History = nan(1, totalTimeSteps);

% Keep track of last error and time to calculate rate of change
lastDistanceError = 0;
startTime = datetime("now");
lastTime = startTime;

% Control loop
for k = 1:totalTimeSteps

    % Get the current time
    currentTime = datetime('now');

    % Calculate the time difference from the last function call
    deltaTime = seconds(currentTime - lastTime); % s

    % Obtain the current distance to the right wall
    currentDistance = getDistanceToRightWall(RC); % m

    %% FIX THIS SECTION

    % Calculate the error in distance
    distanceError = -currentDistance + desiredDistance; % m

    % Calculate the change in distance error since last iteration
    
    deltaDistanceError = distanceError - lastDistanceError; % m

    % Rate of change of error with respect to time
    rateOfChangeError = deltaDistanceError/deltaTime; % m/s

    % Calculate the steering angle using PD control law
    steeringAngle = KP * distanceError + KD * rateOfChangeError;

    lastDistanceError = distanceError;

    %%

    % Send steering angle command
    RC.setSteeringAngle(steeringAngle);

    % Send speed command
    RC.setSpeed(speed); % constant

    % Add variables to history
    currentTime_History(k) = seconds(currentTime - startTime);
    distanceError_History(k) = distanceError;
    steeringAngle_History(k) = steeringAngle;

     % Display the current information for debugging or monitoring
    fprintf("Distance Error = %.3f m\n", distanceError);
    fprintf("Rate of Change of Error = %.3f m/s\n", rateOfChangeError);
    fprintf("Steering Angle: %.4f rad\n", steeringAngle);
    
    % Maintain fixed frequency
    pause(1/frequency);
end

% Plot results
figure()

subplot(1, 2, 1)
plot(currentTime_History, distanceError_History)
xlabel("Time (s)")
ylabel("Distance Error (m)")

subplot(1, 2, 2)
plot(currentTime_History, steeringAngle_History)
xlabel("Time (s)")
ylabel("Steering Angle (rad)")

sgtitle("RC Wall Follower Results")

%% 
%
% <include>getDistanceToRightWall.m</include>
%
% <include>getDistanceToLefttWall.m</include>
%
% <include>getDistancesInRange.m</include>
%