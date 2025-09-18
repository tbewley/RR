% script RR_frame_Four_Bar_Seesaw
% This code sets up and solves the four-bar seesaw using codes from Structural Renaissance.
% Compare to the (very-difficult-to-debug) code in RR_frame_Four_Bar_Seesaw_SLOW_WAY
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 3)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, clc, global RR_VERBOSE, RR_VERBOSE=2; % {0,2} for {less,more} screen output

% This sets up the parameters defining the structure (in SI)
lA=0.5; lB=0.95;                   % Locations of the masses, in meters
fyA=-1; fyB=-1;                   % Values of the externally-applied forces, in Newtons
phi=15; c=cosd(phi); s=sind(phi); % Deflection of the frame, in degrees, and its sin and cos
h=1; w=2;                         % Parameters defining {height,width} of the physical frame

% All we do below is set up the geometry, the connectivity, and the applied loads.
S.P=[ 0  0;   % The columns of {Q,P} denote the x,y locations of each of the {free,pinned} nodes
      0 2*h]; % There are p=2 pinned support nodes and q=10 free nodes in this structure
S.Q=[-w*c -w*c       w*c  w*c     -w*c   -w*c*1.5 -w*c-lA  w*c   w*c*1.5  w*c+lB;
      w*s  w*s+2*h  -w*s -w*s+2*h  w*s+h  w*s+h   w*s+h  -w*s+h -w*s+h   -w*s+h ];
L.U=[0  0  0  0  0  0  0  0  0  0;        % External forces on the q free nodes
     0  0  0  0  0  0 fyA 0  0 fyB];      % Note: m=4 members, n=q+p=10+2=12 total nodes
S.C=[1  1  0  0  1  1  1  0  0  0  0  0;  % m x n connectivity of the pin-jointed frame
     0  0  1  1  0  0  0  1  1  1  0  0;  % Note: members may connect 3 or more nodal points,
     0  1  0  1  0  0  0  0  0  0  0  1;  % and nodes may have 3 or more members attached, 
     1  0  1  0  0  0  0  0  0  0  1  0]; % in addition to having an applied external load

% Convert the eqns for computing the interior forces to Ax=b, solve, and plot
[A,b,S,L]=RR_Structure_Analyze(S,L); x=pinv(A)*b;    
figure(2); RR_Structure_Plot(S,L,x); x_error=norm(A*x-b)
print -vector -dpdf Four_Bar_Seesaw_sol.pdf

% Also plot the direction of the nullspace vector
L.U=zeros(2,10); xn=null(A); figure(3); RR_Structure_Plot(S,L,xn); xn_error=norm(A*xn)
print -vector -dpdf Four_Bar_Seesaw_nullspace.pdf
