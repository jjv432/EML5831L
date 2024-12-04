function [distance] = euclideanRobot2Goal(Robot, goal)

distance = sqrt( (Robot.X - goal(1) )^2 + (Robot.Y - goal(2))^2 );

end
