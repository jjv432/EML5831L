clc
close all
format compact

% One input, one hidden layer, one output

nsamp = 1000; %number of samples used

a = -2*pi;
b = 2*pi;

rx = a + (b-a) * rand(nsamp,1);  %random number between 0-1

ry = sin(rx) + 0.2*randn(nsamp,1); %nsamp random numbers from a uniform distribution

%Trying to 'learn' a sine wave (pretending we don't know it's a sine wave)
%Ry is a noisy input

x2 = a:.01:b; %Test set
y2 = sin(x2); %Theoretical function (in real life unknown)

% plotting 'theoretical' and 'measured'
figure()
    hold on
    plot(x2, y2) %theoretical
    plot(rx, ry, 'x') %measured

%% Training the Network

netconf = [10]; % 1 hidden layer with ten units % [10,10,5] if more than one layer

net = feedforwardnet(netconf); %by default sigmoud 
%Will iterate until no more improvements can be made

net = train(net, rx.', ry.'); 
%Notes^ rx: input matrix, ry: output matrix.
%Need to check sizes of rx and ry.
%Input matrix should be: [#Features (inputs) x #Samples]
%Output matrix: [#Targets (outputs) x #Samples]


%% Testing the matrix

y2_predicted = net(x2);

figure()
    hold on
    plot(rx,ry,'x') %"measurements" used to train network
    plot(x2, y2_predicted, 'LineWidth', 0.5)