% script RR_Repeat_Symbol_Test
% Demonstrates the use of the Repeat Symbol Test as
% one (of several!) statistical tests to confirm the "randomness"
% of a sequence of random integers x between a=1 and b.
% This test plots the histogram of minimum j>0 for which x_i=x_(i+j),
% normalized to reflect the corresponding pdf, and compares to the
% exponential distribution of this result that is predicted by theory.  
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chap02
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear; close all, N=10^6, b=6  % <- fiddle with N and b to test
max=30; x=randi(b,N+max,1);
for i=1:N, for j=1:max, if x(i)==x(i+j), break, end, end, js(i)=j; end
histogram(js,'normalization','pdf')        % plot histogram as PDF

X=1:max; c=(b-1)/b; P=c.^(X-1)/b; plot(X,P,'k-','LineWidth',2)
hold on, ax=axis; axis([0 max-5 0 ax(4)])  % result predicted by theory