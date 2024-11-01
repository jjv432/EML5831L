% Retrieves the distance from the LIDAR scan at a specified angle.
function distance = getDistancesInRange(obj, angle_min, angle_max)

% Get the latest LIDAR scan data
scan = obj.getScan();

% Validate if the provided angle lies within the scan's range
if (angle_min < scan.AngleMin) || (angle_max > scan.AngleMax)
    fprintf("Provided scan angle range [%f, %f] is out of the  lidar range [%f, %f].\n", ...
        angle_min, angle_max, scan.AngleMin, scan.AngleMax);
    distance = -1;  % Return an error code for out-of-range angle
    return;
end

% Create angle range vector
angle_range = angle_min:scan.AngleIncrement:angle_max;

% Calculate the index of the scan data corresponding to the given angle
indices = round((angle_range - scan.AngleMin) / scan.AngleIncrement);

% Fetch and return the distance at the calculated index from the scan ranges
distance = scan.Ranges(indices);

% Change 0 distance (unknown) to nan
distance(distance == 0) = nan;

end