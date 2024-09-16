%% Hw 1
%Due 9/27/24
%Jack Vranicar
%jjv20@fsu.edu

%{
    Implement the PSO algorithm to minimize the following function
    𝑓(𝑥, 𝑦) = (𝑥 − 4)2 − 7 ∗ 𝑐𝑜𝑠(2𝜋(𝑥 − 4)) + 𝑦2 − 7𝑐𝑜𝑠(2𝜋𝑦)
    with 𝑥 ∈ [−7 7] 𝑎𝑛𝑑 𝑦 ∈ [−7 7]
%}

%https://www.mathworks.com/matlabcentral/answers/66763-generate-random-numbers-in-range-from-0-8-to-4

%r = a + (b-a).*rand(100,1); from source above
%%
clc
clearvars
format compact
close all

%% NOTES
% Need to implement max vel!
%Particles get 'stuck.' Is this bc I just told them to stay where they are
%if they go out of bounds? Shouldn't this be taken care of by the fact that
%they are randomized?

%% Parameters/ Initialization
N = 100; %Number of Particles

%termconditions = (Cost==0)&&(time >=100); for ex
termconditions = 0;

xvals = linspace(-7, 7, 100);
yvals = linspace(-7, 7, 100);

zvals = hwFn(xvals, yvals);

% figure()
% plot3(xvals, yvals, zvals)

ya = -7;
yb = 7;
xa = -7;
xb = 7;

paricle_name = zeros(1, N);

G.best_cost = 10;
G.best_pos = [0 0];

alpha_1_max = 10;
alpha_1_min = 1;
alpha_1_delta = 0.05; %Chnage in alpha 1 each try
alpha_1 = alpha_1_max;

alpha_2 = 3;
alpha_3 = 7;

dt = 0.05;
max_time = 20;
sim_time = 0; % seconds

tick = 1;

max_vel = 10; %split into dimensions this is lazy rn
global_cost(1) = G.best_cost;
%% Iterations

%Generating initial positions and velcities
for j = 1:N
    rand_x = xa + (xb-xa)*rand(1);
    rand_y = ya + (yb-ya)*rand(1);

    particle_name = string(strcat('p', num2str(j)));
    particle_names(j) = particle_name;

    p.(particle_name).vel = [1, 1];
    p.(particle_name).pos = [rand_x, rand_y];
    p.(particle_name).best_cost = 1000;
    p.(particle_name).best_pos = p.(particle_name).pos;

    positions(j, :, 1) = p.(particle_name).pos; %third dimension is time

end

while((G.best_cost ~= 0) && (sim_time <= max_time))
    sim_time = sim_time + dt %simulating passage of time (for change in position)
    tick = tick + 1;
    global_cost(tick) = G.best_cost;

    if (alpha_1 > alpha_1_min)
    alpha_1 = alpha_1 - alpha_1_delta;
    end
    for i = 1:N

        particle_name = particle_names(i);
        pos = p.(particle_name).pos;
        new_cost = hwFn(pos(1), pos(2));
        old_PB_cost = p.(particle_name).best_cost; %Old personal best cost

        if(abs(new_cost) < abs(old_PB_cost))
            p.(particle_name).best_cost = new_cost;
            p.(particle_name).best_pos = pos;
        end

        if(abs(new_cost) < abs(G.best_cost))
            G.best_cost = new_cost;
            G.best_pos = pos;

        end


        cur_vel = p.(particle_name).vel;
        cur_pos = pos;
        best_pos = p.(particle_name).best_pos;
        g_best_pos = G.best_pos;
        new_vel = alpha_1*cur_vel + alpha_2*rand(1)*(best_pos-cur_pos) + alpha_3*rand(1)*(g_best_pos-cur_pos);
        new_pos = (new_vel - cur_vel) * dt + cur_pos;

        if (abs(new_vel) < max_vel)
            p.(particle_name).vel = new_vel;
        end
        if ((abs(new_pos(1)) <=7) && (abs(new_pos(2))<=7))
            p.(particle_name).pos = new_pos;
        end

        positions(i,:, tick) = p.(particle_name).pos;

    end
end



figure()
pause(1)
for z = 1:tick
    clf
    plot(positions(:, 1, z), positions(:, 2, z), 'x');
    axis([-7 7 -7 7])
    pause(.1);

end

figure()
max_cost = max(global_cost);
pause(1)

for z = 1:tick
    clf
    plot(1:z, global_cost(1:z));
    axis([0 tick 0 max_cost+2]);
    pause(.1);

end
%% Class Example:
% N = 1000; %number of particles
%
% while(1)%termination condition is not met)
%     for i = 1:N
%         %Evaluate the cost
%         %update P_b ^ i (personal best for i)
%         %update G (global best)
%     end
%
%     %update alpha1
%
%     for i =1:N
%         %Compute velcity of each particle
%         %compute new position
%     end
%
% end