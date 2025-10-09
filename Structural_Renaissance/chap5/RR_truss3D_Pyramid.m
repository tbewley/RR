% script RR_truss3D_Pyramid.m
% Set up a simple 3D pyramid truss, solve for its internal forces, and plot
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 5)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, S.P=[-1  1 -1 1;    % Locations of the fixed nodes of the truss (normalized units)
            -1 -1  1 1;
             0  0  0 0]/2;
h=0.707; % Data from https://www.lmgt.com/?q=height+of+an+equilateral+square+pyramid
cg=h/4;  % Data from https://www.lmgt.com/?q=center+of+mass+of+a+square+pyramid
S.Q=[-1   1  -1   1  -2   0   2   0   0   0;    % Locations of the free nodes of the truss
     -1  -1   1   1   0  -2   0   2   0   0;
     2*h 2*h 2*h 2*h  0   0   0   0  4*h  h]/4;
for i=1:3
  clear L
  L.U=[ 0 -0.2  0   0   0   0   0   0   0   0;    % External forces on the free nodes
        0   0   0   0   0   0   0   0  -1   0;    % of the truss (normalized)
        0 -0.2  0   0   0   0   0   0   0   0];
  if i==1
      % 1 2 3 4 5 ... member number         % comments below corresponds to node number     
    CT=[1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0;  % q_1
        0 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0;  % q_2
        0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0;  % q_3
        0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0;  % q_4
        0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0;  % q_5
        0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0;  % q_6
        0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0;  % q_7
        0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0;  % q_8
        0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 1 0 0 0 0;  % q_9
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1;  % q_10
        1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0;  % p_1
        0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0;  % p_2
        0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0;  % p_3
        0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]; % p_4
  elseif i==2
    CT=[1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 0 0 0 0 0 0 0 1 0 1;    % q_1  
        0 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 1 0 1 1 1 0 0 0 0 0 0 0;    % q_2
        0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 1 1 1 0;    % q_3
        0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 1 0 1 1 1 0 0 0 0;    % q_4
        0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1;    % q_5
        0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0;    % q_6
        0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0;    % q_7
        0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0;    % q_8
        0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0;    % q_9
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;    % q_10
        1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;    % p_1
        0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;    % p_2
        0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;    % p_3
        0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];   % p_4
  else
    CT=[1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0;    % q_1  
        0 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 1 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0;    % q_2
        0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 1 1 1 0 0 0 0 0;    % q_3
        0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 1 0 1 1 1 0 0 0 0 0 0 0 0;    % q_4
        0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 1;    % q_5
        0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 1 1 0 0;    % q_6
        0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 1 1 0;    % q_7
        0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 1 1;    % q_8
        0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;    % q_9
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;    % q_10
        1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;    % p_1
        0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;    % p_2
        0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;    % p_3
        0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];   % p_4
  end
 
  % Convert the eqns for computing the interior & reaction forces to Ax=b, solve, and plot.
  S.C=CT'; [A,b,S,L]=RR_Structure_Analyze(S,L); x=pinv(A)*b;     
  % Finally, plot the truss (blue = tension, red = compression)
  figure(1), clf, RR_Structure_Plot(S,L,x); error=norm(A*x-b), if i<3, pause, end
end

% print -dpdf -d_vector -bestfit pyramid_disturbed.pdf
