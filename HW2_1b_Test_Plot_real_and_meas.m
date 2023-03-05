% Define system matrices

% The equations if we scroll down in the pdf
% Those define what our parameters ar
% Use the equations in a loop
% 100 or 200 samples
% Iterate through, update the stats as we go

A = 1;
B = 2;
C = 3;
D = 0;

Uk = 0.1;   % real input trickle
Q = 0;      % process noise
R = 5;      % measurement noise

% Initialize state estimate and covariance estimate
% P = 10;

% Generate process noise
w = sqrt(Q) * randn(100, 1);

% Generate measurement noise
v = sqrt(R) * randn(100, 1);

% Simulate system dynamics and measurement
N = 100;
timestep = 2;               % time step duration in seconds
time = timestep * (0:N-1);  % time axis for plot
x = zeros(N, 1);
% Initial state estimate
x(1) = 10;
y = zeros(N, 1);
% Indexes start at 1
for k = 1:N-1
    % True system dynamics with process noise
    x(k+1) = A*x(k) + B*Uk + w(k);
    % Measured output with measurement noise
    y(k) = C*x(k) + D*Uk + v(k);
    % Update state estimate and covariance estimate using Kalman filter equations
    % K = P*H'/(H*P*H' + R);
    % x(k+1) = A*x(k) + B*Uk + K*(y_meas(k) - H*(A*x(k) + B*Uk));
    % P = (eye(1) - K*H)*P*(eye(1) - K*H)' + K*R*K';
end

% cover the last data point
y(N) = C*x(N) + D*Uk + v(N);

% Modify X data
x_scaled = x*C;

% Plot results
t = 1:N;
figure;
plot(time, x_scaled, '-b', time, y, '-r');
legend('X(k) Water in Pool * 3', 'Y(k) Water Measured With Gain 3');
title('Kalman Filter Simulation with Constant Input U(k) = 0.1 starting at 10');
xlabel('Time (seconds)');
ylabel('State Value');

