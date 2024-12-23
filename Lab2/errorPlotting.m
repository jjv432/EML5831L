clearvars -except SLRobot PTRobot CWRobot CCWRobot
close all;
format compact;
clc;

%%

dataBool = 1;

if dataBool
    SLRobot = readstruct("G2/G2StraightLine.json");
    PTRobot = readstruct("G2/G2PointTurn.json");
    CWRobot = readstruct("G2/G2CWNinety_001.json");
    CCWRobot = readstruct("G2/G2CCWNinety_001.json");
end

%% Straight Line

sample_length = numel(SLRobot.MobRobX);
dt= SLRobot.Time(2) - SLRobot.Time(1);
vx= (SLRobot.MobRobX(sample_length/2) - SLRobot.MobRobX(sample_length/2 -1)) / dt;
startIndex = 320;
endIndex = 788;

x_vals=0;
z_vals=0;
phi(1)=0;

for i = 2:(endIndex - startIndex)
    x_vals(i) = x_vals(i-1) + vx*cos(phi(i-1))*dt;
    z_vals(i) = z_vals(i-1) + vx*sin(phi(i-1))*dt;
    phi(i) = phi(i-1) - (0)/sample_length;
    
end

figure()
hold on
plot(x_vals, z_vals, '--r')
plot(SLRobot.MobRobX(startIndex:endIndex), -SLRobot.MobRobZ(startIndex:endIndex), 'k');
legend("Theoretical", "Measured")
axis('equal')
hold off
saveas(gcf, "StraightLine", 'jpg');

[XTE, ATE] = trackErrorCalc(x_vals, z_vals, SLRobot.MobRobX(startIndex:(endIndex-1)), SLRobot.MobRobZ(startIndex:(endIndex-1)), phi);

figure()
plot(XTE)
title("Cross Track Error vs Index")
ylabel("Error (m)")
xlabel("Index ()")
saveas(gcf, "StraightLineXTE", 'jpg')

figure()
plot(ATE)
title("Along Track Error vs Index")
ylabel("Error (m)")
xlabel("Index ()")
saveas(gcf, "StraightLineATE", 'jpg')

clear x_vals z_vals phi


%% Point Turn
sample_length = numel(PTRobot.MobRobX);
dt= PTRobot.Time(2) - PTRobot.Time(1);
vx= (PTRobot.MobRobX(sample_length/2) - PTRobot.MobRobX(sample_length/2 -1)) / dt;
vz= (PTRobot.MobRobZ(sample_length/2) - PTRobot.MobRobZ(sample_length/2 -1)) / dt;
v = sqrt(vx^2 + vz^2);

figure();
plot(PTRobot.MobRobX);

startIndex = 210;
endIndex = 712;


x_vals(1)=0;
z_vals(1)=0;
phi(1)=0;

for i = 2:(endIndex - startIndex)
    x_vals(i) = x_vals(i-1) + 0*v*cos(phi(i-1))*dt;
    z_vals(i) = z_vals(i-1) + 0*v*sin(phi(i-1))*dt;
    phi(i) = phi(i-1) + (2*pi)/sample_length;
end

figure()
hold on
plot(x_vals, z_vals, 'xr')
plot(PTRobot.MobRobX, -PTRobot.MobRobZ, 'k');
legend("Theoretical", "Measured")
axis('equal')
hold off
saveas(gcf, "PointTurn", 'jpg');

[XTE, ATE] = trackErrorCalc(x_vals, z_vals, PTRobot.MobRobX(startIndex:(endIndex-1)), PTRobot.MobRobZ(startIndex:(endIndex-1)), phi);

figure()
plot(XTE)
title("Cross Track Error vs Index")
ylabel("Error (m)")
xlabel("Index ()")
saveas(gcf, "PointTurnXTE", 'jpg')

figure()
plot(ATE)
title("Along Track Error vs Index")
ylabel("Error (m)")
xlabel("Index ()")
saveas(gcf, "PointTurnATE", 'jpg')

clear x_vals z_vals phi

%% CCW Ninety

sample_length = numel(CCWRobot.MobRobX);
dt= CCWRobot.Time(2) - CCWRobot.Time(1);
vx= (CCWRobot.MobRobX(sample_length/2) - CCWRobot.MobRobX(sample_length/2 -1)) / dt;
vz= (CCWRobot.MobRobZ(sample_length/2) - CCWRobot.MobRobZ(sample_length/2 -1)) / dt;
v = sqrt(vx^2 + vz^2);

figure();
plot(CCWRobot.MobRobZ)

startIndex = 30;
endIndex = 526;

x_vals=0;
z_vals=0;
phi(1)=0;
circle_radius = .5;
AngVel= v/circle_radius;


for i = 2:(endIndex - startIndex)
    x_vals(i) = x_vals(i-1) + v*cos(phi(i-1))*dt;
    z_vals(i) = z_vals(i-1) + v*sin(phi(i-1))*dt;
    phi(i) = phi(i-1) + AngVel*dt;
end

figure()
hold on
plot(x_vals, z_vals, '--r')
plot(CCWRobot.MobRobX, -CCWRobot.MobRobZ, 'k');
legend("Theoretical", "Measured")
axis('equal')
hold off
saveas(gcf, "CCW", 'jpg');

[XTE, ATE] = trackErrorCalc(x_vals, z_vals, CCWRobot.MobRobX(startIndex:(endIndex-1)), CCWRobot.MobRobZ(startIndex:(endIndex-1)), phi);

figure()
plot(XTE)
title("Cross Track Error vs Index")
ylabel("Error (m)")
xlabel("Index ()")
saveas(gcf, "CCWXTE", 'jpg')

figure()
plot(ATE)
title("Along Track Error vs Index")
ylabel("Error (m)")
xlabel("Index ()")
saveas(gcf, "CCWATE", 'jpg')

clear x_vals z_vals phi

%% CW Ninety
sample_length = numel(CWRobot.MobRobX);
dt= CWRobot.Time(2) - CWRobot.Time(1);
vx= (CWRobot.MobRobX(sample_length/2) - CWRobot.MobRobX(sample_length/2 -1)) / dt;
vz= (CWRobot.MobRobZ(sample_length/2) - CWRobot.MobRobZ(sample_length/2 -1)) / dt;
v = sqrt(vx^2 + vz^2);

figure();
plot(CWRobot.MobRobZ)

startIndex = 257;
endIndex = 490;

circle_radius = .3;

x_vals=0;
z_vals=0;
phi(1)=0;
AngVel= v/circle_radius;


for i = 2:(endIndex - startIndex)
    x_vals(i) = x_vals(i-1) + v*cos(phi(i-1))*dt;
    z_vals(i) = z_vals(i-1) + v*sin(phi(i-1))*dt;
    phi(i) = phi(i-1) - AngVel*dt;
end

figure()
hold on
plot(x_vals, z_vals, '--r')
plot(CWRobot.MobRobX, -CWRobot.MobRobZ, 'k');
legend("Theoretical", "Measured")
axis('equal')
hold off
saveas(gcf, "CW", 'jpg');

[XTE, ATE] = trackErrorCalc(x_vals, z_vals, CWRobot.MobRobX(startIndex:(endIndex-1)), CWRobot.MobRobZ(startIndex:(endIndex-1)), phi);

figure()
plot(XTE)
title("Cross Track Error vs Index")
ylabel("Error (m)")
xlabel("Index ()")
saveas(gcf, "CWXTE", 'jpg')

figure()
plot(ATE)
title("Along Track Error vs Index")
ylabel("Error (m)")
xlabel("Index ()")
saveas(gcf, "CWATE", 'jpg')


clear x_vals z_vals phi

%%
%
% <include>trackErrorCalc.m</include>
%