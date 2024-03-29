% script RR_Fair_Dice_Test
% Demonstrates the use of the matlab's randi function to simulate
% the sum of two fair dice, and plots a histogram of the result.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear; close all; N=10^3  % <- Fiddle with N to test
y=randi(6,N)+randi(6,N);
histogram(y,[1.5:12.5],'Normalization','pdf'), hold on % plot histogram as PDF 

plot([2 7 ],[1 6]/36,'k-','LineWidth',2)          % result predicted by theory
plot([7 12],[6 1]/36,'k-','LineWidth',2)
