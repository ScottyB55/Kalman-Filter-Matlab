% Define system matrices
A = 1;
U = 0.1;
H = 1;
Q = 0; % no process noise
R = 0; % no measurement noise

% Initialize state estimate and covariance estimate
x = 10;
P = 10;

% Generate process noise
w = sqrt(Q) * randn(100, 1);

% Generate measurement noise
v = sqrt(R) * randn(100, 1);

% Simulate system dynamics and measurement
N = 100;
x_true = zeros(N, 1);
y_meas = zeros(N, 1);
for k = 1:N
    % True system dynamics without noise
    x_true(k) = A*x(k) + U*0.1; % using U instead of B
    % Measured output without noise
    y_meas(k) = H*x_true(k);
    % Update state estimate and covariance estimate using Kalman filter equations
    K = P*H'/(H*P*H' + R);
    x(k+1) = A*x(k) + U*0.1 + K*(y_meas(k) - H*(A*x(k) + U*0.1)); % using U instead of B
    P = (eye(1) - K*H)*P*(eye(1) - K*H)' + K*R*K';
end

% Plot results
t = 1:N;
figure;
plot(t, x_true, '-b', t, y_meas, '-r', t, x(1:N), '-g');
legend('True State', 'Measured Output', 'Estimated State');
title('Kalman Filter Simulation with Constant Input U(k) = 0.1, Q = 0, R = 0');
xlabel('Time Step');
ylabel('State Value');




