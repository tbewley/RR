% script RR_beam_simply_supported_a_shear_moment.m
% This code sets up and solves the four-bar seesaw.
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 3)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, global RR_VERBOSE, RR_VERBOSE=2; % {0,2} for {less,more} screen output

% All we do below is set up the geometry, the connectivity, and the applied loads.
S.P=[ 0   4;  % Columns of {P,Q} denote x,y locations of each of the {pinned,free} supports
      0   0];
S.Q=[ 2  3.5;         % Locations of each of the n=2 free nodes
      0   0];
L.U=[ 0  1  ;        % External forces on the n=2 free nodes
     -1 1.4];  
S.C=[ 1   1   1   1];

% Convert the eqns for computing the interior forces to Ax=b, solve, and plot.
[A,b,S,L]=RR_Structure_Analyze(S,L); x=pinv(A)*b; n=null(A), x1=x+n
figure(1); RR_Structure_Plot(S,L,x1); error=norm(A*x1-b)
% print -vector -dpdf beam_simply_supported_a_shear_moment_sol.pdf
