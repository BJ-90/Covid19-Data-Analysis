%% Task 2 – Modelling progression of an epidemic
%% Flattening the curve
clear all
close all
clc
% Given parameters
days = 100;
timesteps = 1000;
gamma = 0.2;
N = 10000000;
beta_vec = 0.1:1.2/50:1.2;
S_end = zeros(length(beta_vec)); % Values of S at the end of each simulation
I_max = zeros(length(beta_vec)); % I_max for each value of beta_vec
t_max = zeros(length(beta_vec)); % time at which I_max occured
% use for loop to test individual values of beta
for i = 1:length(beta_vec)
    [S, I, ~] = SIR(beta_vec(i),gamma,N,timesteps,days);
    S_end(i) = S(end);
    [I_max(i),t] = max(I);
    t_max(i) = (days/timesteps)*t;
end

% Plot
figure
plot(beta_vec, I_max, 'linewidth',2)
xlabel(' \beta / days^{-1}')
ylabel('Maximum of I(t) / million')

figure
plot(beta_vec, t_max, 'linewidth',2)
xlabel(' \beta / days^{-1}')
ylabel('Time of peak infection (days)')

figure
plot(beta_vec, S_end, 'linewidth',2)
xlabel(' \beta / days^{-1}')
ylabel('S(t) at the end of simulation / million')