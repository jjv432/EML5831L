function [omega, gamma, error] = my_controller(robot, des, old_error, dt, gains)

  kp = gains(1);
  kd = gains(2);
  error = des.Y - robot.Y;

  
  gamma = kp*error + kd*(error-old_error)/dt;
  
  %gamma = atan2(sin(gamma), cos(gamma));

  if (gamma>=pi/3)
      gamma = pi/3;
  elseif (gamma<=-pi/3)
          gamma=-pi/3;
  end

 
  omega = (robot.Vel/robot.width) * tan(gamma);


end