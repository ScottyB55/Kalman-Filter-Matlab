% Generate 100 samples of normally distributed noise with 0 mean and variance 10
noise = sqrt(10) * randn(100, 1);

% Plot the noise samples
plot(noise);
title('Normally Distributed Noise with 0 Mean and Variance 10');
xlabel('Sample Index');
ylabel('Noise Value');