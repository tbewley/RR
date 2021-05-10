function encoders(m,Rmin,Rmax,Rgap)
% function encoders(m,Rmin,Rmax,Rgap)
% Draws incremental+reset, binary, and Gray encoder disks at specified resolution.
% INPUTS: m=resolution
%         Rmin=inner radius
%         Rmax=outer radius
%         Rgap=gap between marks
% EXAMPLE CALL: encoders(6,0.2,1,0.01)
% Renaissance Robotics codebase, Chapter 6, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under BSD-3-Clause license.

DeltaR=Rmax-Rmin; dr=DeltaR/(m+1);

% Standard ABZ (incremental+reset) encoder, 2^m slots
figure(1), circ(Rmax)  
plot_slots(2^m,Rmax-dr,Rmax-Rgap), plot_slots(2^m,Rmax-2*dr,Rmax-dr-Rgap,0,1)
print -deps ABZ.eps

% Binary encoder with i=0:m rows, each with 2^i slots
figure(2), circ(Rmax) 
for i=0:m, plot_slots(2^i,Rmin+dr*i,Rmin+dr*(i+1)-Rgap), end
print -deps binary.eps

% Gray code encoder with i=0:m rows
figure(3), circ(Rmax)  
for i=0:m
  if i==0, N=1; off=0; else, N=2^(i-1); off=-pi/2^i; end   
  plot_slots(N,Rmin+dr*i,Rmin+dr*(i+1)-Rgap,off)
end
print -deps Gray.eps
end

function circ(Rmax)
clf, plot(Rmax*exp(j*(0:pi/100:2*pi)),'k-'), axis equal, axis off, hold on
end

function plot_slots(N1,r1,r2,off,N2)
if nargin<5; N2=N1; end,  if nargin<4; off=0; end
for i=0:N2-1
    t1=(i/N1)*2*pi; t2=((i+0.5)/N1)*2*pi; dt=t2-t1;
    n_inc=dt/.01; t_inc=dt/ceil(n_inc);
    X=[r1*cos(t1+off:t_inc:t2+off) r2*cos(t2+off:-t_inc:t1+off)];
    Y=[r1*sin(t1+off:t_inc:t2+off) r2*sin(t2+off:-t_inc:t1+off)];
    fill(X,Y,'k')
end
end