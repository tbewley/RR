% script RR_Birthday_Problem_Test
% Demonstrates the use of the Birthday Problem (the likelihood that at least 2
% of n people have the same birthday, as a function of n) as one (of several!)
% statistical tests to confirm the "randomness" of a sequence of random integers.
% This test plots the histogram of minimum number of people in several random
% groupings for 2 people to have the same birthday, and compares to the
% distribution (as a CDF) of this result that is predicted by theory.  
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear; close all, N=10^6   % <- fiddle with N to test
b=365; max=70; x=randi(b,N+max,1);
for i=1:N, t=1; while t+1==length(unique(x(i:i+t))), t=t+1; end, y(i)=t+1; end
histogram(y,[0.5:max+0.5],'normalization','cdf') % plot histogram as CDF 

X=(365-[0:max-1])/365; X_cumulative=cumprod(X);  % result predicted by theory
hold on, plot(1-X_cumulative,'k-','LineWidth',2), axis([0 max 0 1])
