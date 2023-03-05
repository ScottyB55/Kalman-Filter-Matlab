clear all
close all
clc

% PID gains
Kp = 0;  % proportional
Kd = 0;   % derivative
Ki = 0;   % integral


deltaT = 0.01;         % in seconds
totalTime = 3;         % also in seconds
N = totalTime/deltaT;  % total number of discrete time samples
setPoint = 0;          % horizontal
times = linspace(0,totalTime,N);  % real time samples, used for plotting

g = 9.81;     % m/s/s
m = 3;        % kg
l = 0.5;      % m
friction = 2; % N/rad/sec
maxIntegral = 4*m*g; % to avoid spectacular overshoots
maxThrust = 4*m*g; % this is maximum thrust for the motor
integralTerm = 0; % integral term for integrating the error, starts at zero

theta = zeros(1,N);        %make space for the angles (will be overwritten)
thetadot = zeros(1,N);     %make space for the first derivative
thetadotdot = zeros(1,N);  %make space of the second derivative

theta(1)=-pi/4; % starts diagonally down
thetadot(1)=0;  % starts static
thetadotdot(1)=0;  % starts with no acceleration
forces = [0];   % initialize the list of forces with zero


% The main loop computing everything in the simulation
for step=2:N
  error(step)=setPoint - theta(step-1); % computer the error at each step

  %PID calculation
  proportional   = Kp*error(step);
  derivative     = Kd*(error(step)-error(step-1))/deltaT;
  integralTerm   = integralTerm+Ki*error(step)*deltaT;
  % limit the integral accumulation both up and down
  integralTerm     = max([integralTerm, 0]);
  integralTerm     = min([integralTerm, maxIntegral]);
  F   = proportional + derivative + integralTerm; % commanded force

  %  saturate the force between 0 and maxThrust
  F = min([F, maxThrust]);
  F = max([0, F]);
  forces = [forces F]; % save the current force for plotting it later

  thetadotdot(step) = F/(m*l)-cos(theta(step-1))*g/l - friction*thetadot(step-1);
  thetadot(step) = thetadot(step-1)+thetadotdot(step)*deltaT;
  theta(step) = theta(step-1)+thetadot(step)*deltaT;
end

% Now let's see how it looks

figure(1)

% Fist subplot is for the arm position
subplot(2,1,1);
plot(times,theta);
hold on

% Various useful limits:
plot(times,ones(1,N)*setPoint,'g'); % the set point
plot(times,ones(1,N)*pi/2,'k-'); % top of travel
plot(times,-1*ones(1,N)*pi/2,'k-'); % bottom of travel
plot(times,ones(1,N)*pi*10/180,'r'); % 10 degree overshoot
plot(times,-ones(1,N)*pi*10/180,'r'); % 10 degree undershoot
xlabel('Time [s]');
ylabel('Angular position [rad]');


% Second subplot is for the force applied
subplot(2,1,2);
plot(times, forces);
xlabel('Time [s]');
ylabel('Force applied [N]');
