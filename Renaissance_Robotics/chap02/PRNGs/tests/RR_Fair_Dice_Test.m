% script RR_Fair_Dice_Test
% Demonstrates the use of the matlab's randi function to simulate
% the sum of 2,3,4, fair dice, and plots a histogram of the result.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear, close all, N=10^4  % <- Fiddle with N to test
figure(1)
y=randi(6,N)+randi(6,N);
histogram(y,[1.5:12.5],'Normalization','pdf'), hold on % plot histogram as PDF 
plot([2 7 ],[1 6]/36,'k-','LineWidth',2)          % result predicted by theory
plot([7 12],[6 1]/36,'k-','LineWidth',2)

figure(2)
y=randi(6,N)+randi(6,N)+randi(6,N);
histogram(y,[2.5:18.5],'Normalization','pdf'), hold on % plot histogram as PDF 
x=[3:18]; y=[1,3,6,10,15,21,25,27,27,25,21,15,10,6,3,1]/216;
plot(x,y,'k-','LineWidth',2)          % result predicted by theory

figure(3)
y=randi(6,N)+randi(6,N)+randi(6,N)+randi(6,N);
histogram(y,[3.5:24.5],'Normalization','pdf'), hold on % plot histogram as PDF 
x=[4:24]; y=[1,4,10,20,35,56,80,104,125,140,146,140,125,104,80,56,35,20,10,4,1]/1296;
plot(x,y,'k-','LineWidth',2)          % result predicted by theory

figure(4)
y=randi(6,N)+randi(6,N)+randi(6,N)+randi(6,N)+randi(6,N);
histogram(y,[4.5:30.5],'Normalization','pdf'), hold on % plot histogram as PDF 
x=[5:30]; y=[1,5,15,35,70,126,205,305,420,540,651,735,780, ...
             780,735,651,540,420,305,205,126,70,35,15,5,1]/7776;
plot(x,y,'k-','LineWidth',2)          % result predicted by theory

disp('Hopefully you see the Central Limit Theorem at work here...')