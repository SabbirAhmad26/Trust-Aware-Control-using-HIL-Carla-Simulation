sx = 0.5;                      % threshold for x̂_i and x̂_j
s_tau = 0.3;                   % threshold for τ_j
epsilon = [0.01, 0.01];        % [ε1, ε1]^T
epsilon_term = 2 * (epsilon * epsilon'); 

t_steps = linspace(0, 10, 1000); 
x_hat_i = sin(t_steps);       
x_hat_j = cos(t_steps);         
tau_j = t_steps / 10;           

% initialization
t_i_k = 0;                      
time_to_solve = [];             


for idx = 2:length(t_steps)     
    t = t_steps(idx);
    
    delta_xi = abs(x_hat_i(idx) - x_hat_i(find(t_steps == t_i_k, 1)));
    delta_xj = abs(x_hat_j(idx) - x_hat_j(find(t_steps == t_i_k, 1)));
    delta_tau = abs(tau_j(idx) - tau_j(find(t_steps == t_i_k, 1)));
    
    % check conditions
    cond1 = delta_xi >= (sx - epsilon_term);
    cond2 = any(delta_xj >= (sx - epsilon_term));
    cond3 = any(delta_tau >= s_tau);
    
    if cond1 || cond2 || cond3
        t_i_k = t;
        time_to_solve = [time_to_solve, t]; 
    end
end

disp('Times to solve QP:');
disp(time_to_solve);

% Plotting
figure;
hold on;
plot(t_steps, x_hat_i, 'b', 'DisplayName', 'x̂_i');
plot(t_steps, x_hat_j, 'g', 'DisplayName', 'x̂_j');
yline(sx, 'r--', 'DisplayName', 'Threshold (sx)');
scatter(time_to_solve, sx * ones(size(time_to_solve)), 'ro', 'DisplayName', 'QP solve times');
xlabel('Time');
ylabel('Value');
title('Dynamic Model Validation');
legend show;
hold off;
