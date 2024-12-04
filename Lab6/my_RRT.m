function [NodeList] = my_RRT(startPos, goalPos, lookahead, mapAxes, saved_map)


xmin = mapAxes(1);
xmax = mapAxes(2);
ymin = mapAxes(3);
ymax = mapAxes(4);

%% Generating q_goal and q_init
q_init_x = startPos(1);
q_init_y = startPos(2);
q_goal_x = goalPos(1);
q_goal_y = goalPos(2);

hold on
plot(q_goal_x, q_goal_y, 'kx')
plot(q_init_x, q_init_y,'kx')

goalBool = 0;

NodeList = [q_init_x; q_init_y; 1];
currentNode = [q_init_x, q_init_y];

waypointThreshold = lookahead/2;


%% Drawing nodes
goalBool = 1;
phi = 0;

j = 1;
k = 1;
while goalBool
    smallestDistance = inf;

    % Every 10 loops, make x and y the goal, otherwise random
    if (mod(k, 10) == 0)
        randPointX = q_goal_x;
        randPointY = q_goal_y;
    else
        randPointX  = xmin + (xmax - xmin)*rand(1);
        randPointY = ymin + (ymax - ymin)*rand(1);
    end

    % Checking for the nearest node
    for i = 1:size(NodeList, 2)

        % Get euclidean distance from current rand point to each node in
        % the list
        curDistance = sqrt((randPointX-NodeList(1, i))^2 + (randPointY-NodeList(2, i))^2);

        if curDistance < smallestDistance
            bestNodeIndex = i;
            smallestDistance = curDistance;
        end

    end

    % Assigning position for the new node
    bestNodeX = NodeList(1, bestNodeIndex);
    bestNodeY= NodeList(2, bestNodeIndex);
    possibleX = bestNodeX + lookahead * cos(atan2((randPointY - bestNodeY), (randPointX- bestNodeX)));
    possibleY = bestNodeY + lookahead * sin(atan2((randPointY - bestNodeY), (randPointX- bestNodeX)));


    % Checking for obstacles
    [inPolygon, newx, newy] = checkPoint([possibleX, possibleY], [bestNodeX, bestNodeY], saved_map);

    % Assign the waypoint x and y position to the 'radius-fixed' waypoint
    possibleX = newx;
    possibleY = newy;

    if inPolygon == 0
        newNodeX = possibleX;
        newNodeY = possibleY;

        % Adding the current node to the list of nodes
        NodeList = horzcat(NodeList, [newNodeX; newNodeY; bestNodeIndex]);

        % Plot the new node on the same figure
        plot(newNodeX, newNodeY, 'gx');
        drawnow;

        % Find the distance to the goal and stop if it closer than the
        % threshold
        dist2goal = sqrt((newNodeX-q_goal_x)^2 + (newNodeY-q_goal_y)^2);
        if dist2goal < waypointThreshold

            goalBool = 0;
        end
        % This is for the modulus thing
        j = j+1;
        
    end

    
    k = k+1;    
    phi = atan2(NodeList(2, j) - NodeList(2, j-1), NodeList(1,j)- NodeList(1, j-1));

end

%% Finding the path from end to beginning
plotIndex = size(NodeList, 2);
indices = plotIndex;
while plotIndex > 1

    plotIndex = NodeList(3, plotIndex);
    indices = [indices, plotIndex];

end

indices = flip(indices);

for i = 1:length(indices)
    plot(NodeList(1, indices(i)), NodeList(2, indices(i)), 'bo');
    drawnow;
end

end