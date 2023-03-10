% Define system
A = 1;
B = 2;
C = 3;
D = 0;
Uk = 0.1;   % real input trickle
initial_state_estimate = 10;

% Simulate system dynamics and measurement
N_samples = 100;
timestep = B;               % time step duration in seconds
time = timestep * (0:N_samples-1);  % time axis for plot

% Create the random noise
arr_Rand_Noise = randn(100, 1);

% Define the different settings
settings = [struct('Q', 4, 'R', 5, 'initial_p_estimate', 10)
            struct('Q', 400, 'R', 5, 'initial_p_estimate', 10)
            struct('Q', 4, 'R', 500, 'initial_p_estimate', 10)];
            %struct('Q', 4, 'R', 5, 'initial_p_estimate', 1000)];

% Cycle through the different settings
N_settings = length(settings);

% Create placeholder arrays for states, measurements, and Kalman filter variables
x_real = zeros(1, N_samples);
y_meas = zeros(1, N_samples);
x_est = zeros(N_settings, N_samples);
y_est = zeros(N_settings, N_samples);
K = zeros(N_settings, N_samples);
P = zeros(N_settings, N_samples);

% Generate process and measurement noise for the first setting
Q = settings(1).Q;
R = settings(1).R;
w = sqrt(Q) * arr_Rand_Noise;
v = sqrt(R) * arr_Rand_Noise;

% Generate the Simulated Real State and Measurements for the first setting
x_real(1) = initial_state_estimate;
% Simulate across time
for k = 1:N_samples
    % True system dynamics with process noise
    if (k ~= N_samples)
        x_real(k+1) = A*x_real(k) + B*Uk + w(k); end
    % Measured output with measurement noise
    y_meas(k) = C*x_real(k) + D*Uk + v(k);
end

% Perform Kalman filter estimation for each setting
for i = 1:N_settings
    Q = settings(i).Q;
    R = settings(i).R;
    initial_p_estimate = settings(i).initial_p_estimate;
    
    % Initial state estimate
    x_est(i,1) = initial_state_estimate;
    P(i,1) = initial_p_estimate;
    
    % Simulate across time
    for k = 1:N_samples
        %% Kalman Filter Equations
            % xˆk|k−1 = Axˆk + Buk
                % Get what we expected to measure based on the previous 
                % estimation and velocity trends
                x_est(i,k) = A*x_est(i,k) + B*Uk;
            % Pˆk|k−1 = APˆk−1|k−1A^T + Q
                P(i,k) = A*P(i,k)*A' + Q;
            % y˜k = yk − Cxˆk|k−1
                % Get the difference between what we currently measure and
                % what we expected to measure
                y_est(i,k) = y_meas(k) - C * x_est(i,k);
            % Sk = CPˆk|k−1C^T + R
                S = C*P(i,k)*C' + R;
            % Kk = Pˆk|k−1C^T S^−1
                K(i,k) = P(i,k)*C'/S;
            % xˆk|k = ˆxk|k−1 + Kky˜k
                % K should be <= 1
                % Update the estimate as a weighted between the previous
                % estimate and the current measurement
                x_est(i,k) = x_est(i,k) + K(i,k)*y_est(i,k);
            % Pk|k = (I − KkC)Pk|k−1(I − KkC)^T + KkRkK^T
                if (k ~= N_samples)
                    P(i,k+1) = (eye(1) - K(i,k)*C)*P(i,k)*(eye(1) - K(i,k)*C)' + K(i,k)*R*K(i,k)'; end
    end
end

% Plot the results
figure;
hold on;
plot(time, x_real(:));
for i = 1:N_settings
    plot(time, x_est(i,:));
end
title('True States & Estimated States');
xlabel('Time (seconds)');
ylabel('Water');
legendEntries = {'Real State'};
for i = 1:length(settings)
    legendEntries{i+1} = ...
            sprintf('Q=%d, R=%d, P=%d', ...
            settings(i).Q, settings(i).R, settings(i).initial_p_estimate);
end
legend(legendEntries);
hold off;