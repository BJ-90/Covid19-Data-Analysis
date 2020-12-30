%% Task 2 – Modelling progression of an epidemic
%% Task 2(c) – The effect of intervention
close all
clear all
clc
% Given Parameters
beta = 0.8;
gamma = 0.2;
N = 10000000;
I0 = 100;
S0 = N - I0;
R0 = 0;
timesteps = 1000;
days = 150;
h = days/timesteps; % step size

%% Susceptible, Infectious and Recovered
x = [0:h:days]'; % the range of x
S = zeros(size(x)); % allocate the result of Susceptible
I = zeros(length(x),3); % allocate the result of Infectious
S(1) = S0; % the initial of Susceptible
I(1) = I0; % the initial of Infectious
n = numel(S);
% Test different values of beta

% loop to solve DE using Euler's Method
for i = 1:n-1
    % Values at time i using given formula
    dSdt = -(beta*S(i)*I(i))/N;
    dIdt = ((beta*S(i)*I(i))/N)-gamma*I(i);
    % Append time step
    S(i+1) = S(i) + h*dSdt;
    I(i+1) = I(i) + h*dIdt;
    days = round(h*i); % find the 8th day
    if days == 8
        beta = 0.1; % test differeent values of beta here
    end
end

% Plot all the calcuated values
plot(x,I, 'linewidth',2)
xlabel('Time/Days')
ylabel('Number of individual/millions')
title('SIR Simulation with \beta = 0.8 days^{-1}')