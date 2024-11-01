function distance = getDistanceToLeftWall(rc)

% Define scan sample range
angle_min = pi/4;
angle_max = 3*pi/4;

% Get distances in that range
distances = getDistancesInRange(rc, angle_min, angle_max);

% Distance to the wall is the minimum distance in sample
distance = min(distances);