% Define system
A = 1;
B = 2;
C = 3;
D = 0;
Uk = 0.1;   % real input trickle
initial_state_estimate = 10;

% Simulate system dynamics and measurement
N = 100;
timestep = B;               % time step duration in seconds
time = timestep * (0:N-1);  % time axis for plot

% Create 2D placeholder array for 3 different settings and N measured outputs
x = zeros(3, N);
y = zeros(3, N);

% Create the random noise
arr_Rand_Noise = randn(100, 1);

% Cycle through the 3 different settings
for i = 1:1
    if i == 1
        Q = 4;
        R = 5;
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
    x(i,1) = initial_state_estimate;
    
    % Simulate across time
    for k = 1:N-1
        % True system dynamics with process noise
        x(i,k+1) = A*x(i,k) + B*Uk + w(k);
        % Measured output with measurement noise
        y(i,k) = C*x(i,k) + D*Uk + v(k);
    end

    % cover the last data point
    y(i,N) = C*x(i,N) + D*Uk + v(N);
end

% Plot the results
figure;
plot(time, y(1,:), '-r');
legend('Q = 4 & R = 5');
title('Y(k) Measured Output, Constant Input U(k) = 0.1, Start at 10 with gain 3');
xlabel('Time (seconds)');
ylabel('Water Measured, Gain of 3');