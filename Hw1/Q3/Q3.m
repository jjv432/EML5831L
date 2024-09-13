%% Format
clc
format compact
close all

%% Organizing provided training data
y_train = load('./dataForStudents/Ytrain.mat');
x_train = load('./dataForStudents/Xtrain.mat');
y_test = load('./dataForStudents/Ytest.mat');
x_test = load('./dataForStudents/Xtest.mat');

%% 3.1 Train the Network
%Use the provided training data to train a 2-layer feed-forward neural
%network that predicts vehicle velocities as a function of wheel velocities
%and current temperature.

netconf = [10 10]; %two layers

net = feedforwardnet(netconf);

net = train(net, x_train.X, y_train.Y); 

%% 3.2 

theta_dot_r_test = x_test.Xtest(1,:);
theta_dot_l_test = x_test.Xtest(2,:);
temp_test = x_test.Xtest(3,:);

vehicle_velo_measured = y_test.Ytest(1,:);
vehicle_omega_measured = y_test.Ytest(2,:);

vehicle_predicted = net(x_test.Xtest);
vehicle_velo_predicted = vehicle_predicted(1,:);
vehicle_omega_predicted = vehicle_predicted(2,:);

figure()
    plot3(theta_dot_r_test, theta_dot_l_test, vehicle_velo_measured, 'x');
    hold on
    plot3(theta_dot_r_test, theta_dot_l_test, vehicle_velo_predicted, 'o');
    hold off
    xlabel("\omega_r")
    ylabel("\omega_l")
    zlabel("Velocity")

figure()
    plot3(theta_dot_r_test, theta_dot_l_test, vehicle_omega_measured, 'x');
    hold on
    plot3(theta_dot_r_test, theta_dot_l_test, vehicle_omega_predicted, 'o');
    hold off
    xlabel("\omega_r")
    ylabel("\omega_l")
    zlabel("\omega")