% script RR_truss_Bridge_Warren.m
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 6)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a slight generalization of RR_truss_Warren4, with 4 parameters
% For the kitchen-sink generalization, see RR_truss_Bridge_GUI.  Easy.  Enjoy!
clear;
s=8      % number of horizontal sections in the truss (set as parameter!)
h=0.1    % height of the truss (set as parameter!)
parabolic_top_chord=true
roller_support=true
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1), clf
% Locations of the fixed nodes of the truss (normalized units)
if ~roller_support, S.P=[0 1; 0 0]; p=2; r=0; 
else,               S.P=[0; 0]; S.R=[1; 0]; p=1; r=1; end
% Locations of the free nodes of the Warren truss (for arbitrary s and h)
for i=1:s-1, S.Q(:,i)  =[i/s;       0]; end      % free nodes in bottom row
for i=0:s-1, S.Q(:,s+i)=[(i+0.5)/s; h]; end      % free nodes in top row (height=h)
if parabolic_top_chord, for i=0:s-1, S.Q(2,s+i)=[h-4*h*((i+0.5)/s-0.5)^2]; end, end
q=2*s-1; n=q+p+r;

% External forces on the free nodes of the truss (normalized)
L.U=zeros(2,q);  L.U(2,floor(s/2))=-1; % Tweak here if you want force applied elsewhere...

% Connectivity of the Warren truss with s sections
% Note: each column of C^T has exactly one entry equal to +1, and one entry equal to -1.
m=4*s-1; S.C=zeros(m,q+p+r);
S.C(1,n-1)=-1;   S.C(1,1)=1; j=1;                                 % bottom row to left fixed node
for i=1:s-2,     S.C(j+i,i)=-1; S.C(j+i,i+1)=1;  end, j=j+s-2;    % bottom row
S.C(j+1,s-1)=-1; S.C(j+1,n)=1; j=j+1;                             % bottom row to right fixed node
for i=1:s-1,     S.C(j+i,s-1+i)=-1; S.C(j+i,s+i)=1; end, j=j+s-1; % top row
S.C(j+1,n-1)=-1; S.C(j+1,s)=1; j=j+1;                             % left diagonal to fixed node
for i=1:s-1,     S.C(j+2*i-1,s+i-1)=-1; S.C(j+2*i-1,i)=1;         % internal diagonals
                 S.C(j+2*i,i)=1;        S.C(j+2*i,s+i)=-1; end, j=j+2*s-2;  
S.C(j+1,n-2)=-1; S.C(j+1,n)=1; j=j+1;                             % right diagonal to fixed node

% Convert the eqns for computing the interior & reaction forces to Ax=b, solve, and plot.
[A,b,S,L]=RR_Structure_Analyze(S,L);
% Then, just solve for the tension and compression in the members, and plot.
x=pinv(A)*b; error_norm=norm(A*x-b)   % This just implements (6.4b),  Assumes zero pretension!
RR_Structure_Plot(S,L,x) % Plot truss (red=positive=tension, blue=negative=compression)
