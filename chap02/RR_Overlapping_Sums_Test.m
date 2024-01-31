% script RR_Overlapping_Sums_Test
% Demonstrates the use of the Overlapping Sums Test as
% one (of several!) statistical tests to confirm the "randomness"
% of a sequence of random real numbers x on [0,1].
% This test generates N sums y, each of M successive random numbers x,
% then plots the histogram of the values of y computed, normalized to
% reflect the corresponding pdf, and compares to the normal distribution
% of this result that is predicted by the central limit theorem.  
%% Renaissance Robotics codebase, Chapter 2, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

clear; close all, N=10^7, M=100  % <- fiddle with N and M to test
x=rand(N+M,1); for j=1:N, y(j)=sum(x(j:j+M-1)); end
avg=sum(y)/N, variance=sum((y-avg).^2)/N, 
histogram(y,50,'normalization','pdf'), hold on
mu=M/2, sigma_squared=M/12, sigma=sqrt(sigma_squared);
X=mu-4*sigma:.01:mu+4*sigma;
P=(1/(sigma*sqrt(2*pi))*exp(-0.5*((X-mu)/sigma).^2));
plot(X,P,'k-','LineWidth',2)
