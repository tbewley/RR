% script RR_Truss_Pyramid_3D.m
% Set up a simple 3D pyramid truss, solve for its internal forces, and plot
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 6)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, P=[-1  1 -1 1;    % Locations of the fixed nodes of the truss (normalized units)
          -1 -1  1 1;
           0  0  0 0]/2;
h=0.707; % Data from https://www.lmgt.com/?q=height+of+an+equilateral+square+pyramid
cg=h/4;  % Data from https://www.lmgt.com/?q=center+of+mass+of+a+square+pyramid
Q=[-1   1  -1   1  -2   0   2   0   0   0;    % Locations of the free nodes of the truss
   -1  -1   1   1   0  -2   0   2   0   0;
   2*h 2*h 2*h 2*h  0   0   0   0  4*h  h]/4;
U=[ 0 -0.2  0   0   0   0   0   0   0   0;    % External forces on the free nodes
    0   0   0   0   0   0   0   0  -1   0;    % of the truss (normalized)
    0 -0.2  0   0   0   0   0   0   0   0];
m=-1; for i=1:3
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
        0 0 0 0 0 0 0 0 0 0 0 0 m m m m 0 0 0 0 0 0 0 0 1 0 0 0 0;  % q_9
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 m m m m m m m m m m m m m;  % q_10
        m m m 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0;  % p_1
        0 0 0 m m m 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0;  % p_2
        0 0 0 0 0 0 m m m 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0;  % p_3
        0 0 0 0 0 0 0 0 0 m m m 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]; % p_4
  elseif i==2
    CT=[1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 0 0 0 0 0 0 0 m 0 1;    % q_1  
        0 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 m 0 1 1 1 0 0 0 0 0 0 0;    % q_2
        0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 m 0 1 1 1 0;    % q_3
        0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 m 0 1 1 1 0 0 0 0;    % q_4
        0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 m m;    % q_5
        0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 m m 0 0 0 0 0 0 0 0 0;    % q_6
        0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 m m 0 0 0 0 0 0;    % q_7
        0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 m m 0 0 0;    % q_8
        0 0 0 0 0 0 0 0 0 0 0 0 m m m m 0 0 0 0 0 0 0 0 0 0 0 0;    % q_9
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;    % q_10
        m m m 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;    % p_1
        0 0 0 m m m 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;    % p_2
        0 0 0 0 0 0 m m m 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;    % p_3
        0 0 0 0 0 0 0 0 0 m m m 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];   % p_4
  else
    CT=[1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 0 0 0 0 0 0 0 m 0 1 0 0 0 0;    % q_1  
        0 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 m 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0;    % q_2
        0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 m 0 1 1 1 0 0 0 0 0;    % q_3
        0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 m 0 1 1 1 0 0 0 0 0 0 0 0;    % q_4
        0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 m m 1 0 0 m;    % q_5
        0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 m m 0 0 0 0 0 0 0 0 0 m 1 0 0;    % q_6
        0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 m m 0 0 0 0 0 0 0 m 1 0;    % q_7
        0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 m m 0 0 0 0 0 m 1;    % q_8
        0 0 0 0 0 0 0 0 0 0 0 0 m m m m 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;    % q_9
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;    % q_10
        m m m 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;    % p_1
        0 0 0 m m m 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;    % p_2
        0 0 0 0 0 0 m m m 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;    % p_3
        0 0 0 0 0 0 0 0 0 m m m 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];   % p_4
  end
  % Now, convert the D*X*CQ=U problem in (16.3a) to the standard A*x=u form in (16.3b)
  C=CT'; [A,b]=RR_Convert_DXCQ_eq_U_to_Ax_eq_b(Q,P,C,U); 
  % Then, solve for the tensile and compressive forces x in the truss, assuming no pretension
  x=pinv(A)*b;      % This implements (16.4b)... but, does it solve A*x=b?
  r=rank(A), error=norm(A*x-b)        % Let's check!!
  figure(1); clf;   % Finally, plot the truss (blue = tension, red = compression)
  if error<1e-10, figure(1); RR_Plot_Truss(Q,P,C,U,x); axis equal, end, pause
end

% print -dpdf -d_vector -bestfit pyramid_disturbed.pdf
