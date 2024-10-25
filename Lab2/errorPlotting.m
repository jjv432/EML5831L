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

sample_length = 400;
dt= 0.01;
vx=0.2;
x_vals=0;
y_vals=0;
phi(1)=0;


for i = 2:sample_length
    x_vals(i) = x_vals(i-1) + vx*cos(phi(i-1))*dt;
    y_vals(i) = y_vals(i-1) + vx*sin(phi(i-1))*dt;
    phi(i) = phi(i-1) - (0)/sample_length;   
end

figure()
hold on
plot(x_vals, y_vals, '--r')
plot(SLRobot.MobRobX, -SLRobot.MobRobZ, 'k');
legend("Theoretical", "Measured")
axis('equal')
hold off

clear x_vals y_vals phi


%% Point Turn
sample_length = 400;
dt= 0.01;
vx=0.2;
x_vals=0;
y_vals=0;
phi(1)=0;

for i = 2:sample_length
     x_vals(i) = x_vals(i-1) + 0*vx*cos(phi(i-1))*dt;
    y_vals(i) = y_vals(i-1) + 0*vx*sin(phi(i-1))*dt;
    phi(i) = phi(i-1) + (2*pi)/sample_length;
end

figure()
hold on
plot(x_vals, y_vals, 'xr')
plot(PTRobot.MobRobX, -PTRobot.MobRobZ, 'k');
legend("Theoretical", "Measured")
axis('equal')
hold off

clear x_vals y_vals phi

%% CCW Ninety

sample_length = 400;
circle_radius = .5;
dt= 0.01;
vx=0.2;
x_vals=0;
y_vals=0;
phi(1)=0;
AngVel= vx/circle_radius;


for i = 2:sample_length
     x_vals(i) = x_vals(i-1) + vx*cos(phi(i-1))*dt;
    y_vals(i) = y_vals(i-1) + vx*sin(phi(i-1))*dt;
    phi(i) = phi(i-1) + AngVel*dt;
end

figure()
hold on
plot(x_vals, y_vals, '--r')
plot(CCWRobot.MobRobX, -CCWRobot.MobRobZ, 'k');
legend("Theoretical", "Measured")
axis('equal')
hold off

clear x_vals y_vals phi

%% CW Ninety

sample_length = 400;
circle_radius = .25;
dt= 0.005;
vx=0.2;
x_vals=0;
y_vals=0;
phi(1)=0;
AngVel= vx/circle_radius;


for i = 2:sample_length
     x_vals(i) = x_vals(i-1) + vx*cos(phi(i-1))*dt;
    y_vals(i) = y_vals(i-1) + vx*sin(phi(i-1))*dt;
    phi(i) = phi(i-1) - AngVel*dt;
end

figure()
hold on
plot(x_vals, y_vals, '--r')
plot(CWRobot.MobRobX, -CWRobot.MobRobZ, 'k');
legend("Theoretical", "Measured")
axis('equal')
hold off

clear x_vals y_vals phi