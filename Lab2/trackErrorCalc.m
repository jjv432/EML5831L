function [XTE, ATE] = trackErrorCalc(desX, desZ, robX, robZ, phi)

theta = atan(desZ - robZ / desX - robX);
B = sqrt((desX - robX).^2 + (desZ - robZ).^2);
alpha = 90 - theta - phi;
XTE = B.*cos(alpha);
ATE = B.*sin(alpha);

end