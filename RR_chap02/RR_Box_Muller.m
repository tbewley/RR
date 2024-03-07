% script RR_Box_Muller
% Demonstrates the use of the Box Muller transform to convert
% a sequence of random real numbers x on [0,1],
% to a sequence of normally-distrubuted real numbers z
% with specified mean mu and standard deviation sigma, and
% plots histograms of both, normalized to reflect the corresponding pdf.
%% Renaissance Robotics codebase, Chapter 2, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

N=10^6, mu=5, sigma=4  % <- fiddle with N, mu, and sigma to test
x=rand(N,1); for i=1:N/2
  a=sqrt(-2*log(x(i))); b=2*pi*x(i+1); z(i)=a*cos(b); z(i+1)=a*sin(b);
end
z=z*sigma+mu;

close all
figure(1); histogram(x,50,'normalization','pdf')
figure(2); histogram(z,50,'normalization','pdf'); hold on;
X=[mu-5*sigma:.01:mu+5*sigma]; Y=exp(-0.5*((X-mu)/sigma).^2)/(sigma*sqrt(2*pi)); 
plot(X,Y,'k-','LineWidth',2)
