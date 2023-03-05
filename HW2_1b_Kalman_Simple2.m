% Define system matrices

A = 1;
B = 2;
C = 3;
D = 0;

Uk = 0.1;   % real input trickle

% Initialize state estimate and covariance estimate
% P = 10;

% Simulate system dynamics and measurement
N = 100;
timestep = 2;               % time step duration in seconds
time = timestep * (0:N-1);  % time axis for plot

% create 2D array
x = zeros(3, N);

y = zeros(3, N);

arr_Rand_Noise = randn(100, 1);

for i = 1:3
    if i == 1
        Q = 0;
        R = 0;
    elseif i == 2
        Q = 4;
        R = 0;
    else
        Q = 0;
        R = 5;
    end

    % Generate process noise
    w = sqrt(Q) * arr_Rand_Noise;

    % Generate measurement noise
    v = sqrt(R) * arr_Rand_Noise;

    % Initial state estimate
    x(i,1) = 10;
    

    for k = 1:N-1
        % True system dynamics with process noise
        x(i,k+1) = A*x(i,k) + B*Uk + w(k);
        % Measured output with measurement noise
        y(i,k) = C*x(i,k) + D*Uk + v(k);
        % Update state estimate and covariance estimate using Kalman filter equations
        % K = P*H'/(H*P*H' + R);
        % x(k+1) = A*x(k) + B*Uk + K*(y_meas(k) - H*(A*x(k) + B*Uk));
        % P = (eye(1) - K*H)*P*(eye(1) - K*H)' + K*R*K';
    end

    % cover the last data point
    y(i,N) = C*x(i,N) + D*Uk + v(N);
end

% Plot results
figure;
plot(time, y(1,:), '-r', time, y(2,:), '-g', time, y(3,:), '-b');
legend('Q = 0 & R = 0', 'Q = 4 & R = 0', 'Q = 0 & R = 5');
title('Kalman Filter Y(k) Output Simulation with Constant Input U(k) = 0.1 starting at 10, Gain 3');
xlabel('Time (seconds)');
ylabel('Water Measured, Gain of 3');