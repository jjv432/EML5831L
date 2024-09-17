function [omega, gamma, error] = my_controller(robot, des, old_error,error_sum, dt, gains, width, drift)

  kp = gains(1);
  kd = gains(2);
  ki = gains(3);

  error = des.Y - (robot.Y + (width*sin(robot.Phi)));
  error_sum = error_sum + error * dt;
  
  gamma = kp*error + kd*(error-old_error)/dt + ki*error_sum;

  gamma = gamma + drift;
  
%gamma = atan2(sin(gamma), cos(gamma));

  if (gamma>=pi/3)
      gamma = pi/3;
  elseif (gamma<=-pi/3)
          gamma=-pi/3;
  end

 
  omega = (robot.Vel/robot.width) * tan(gamma);


end