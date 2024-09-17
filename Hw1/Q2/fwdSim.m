function [robot] = fwdSim(robot,dt)

%Current
X = robot.X;
Y = robot.Y;
Phi = robot.Phi;
Vel = robot.Vel;
angVel = robot.angVel;

%Future
X = X + Vel*cos(Phi)*dt;
Y = Y + Vel*sin(Phi)*dt;
Phi = Phi + angVel*dt;

%  if (Phi>=pi/2)
%       Phi = pi/2;
%   elseif (Phi<=-pi/2)
%           Phi=-pi/2;
%   end

%Passing
robot.X = X;
robot.Y = Y;
robot.Phi = Phi;


end