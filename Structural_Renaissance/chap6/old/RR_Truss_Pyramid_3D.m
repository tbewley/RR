% script RR_Truss_Pyramid_3D.m
% Set up a simple 3D pyramid truss, solve for its internal forces, and plot
clear, P=[-1  1 -1 1;    % Locations of the fixed nodes of the truss (normalized units)
          -1 -1  1 1;
           0  0  0 0]/2;
h=0.707; % Data from https://www.lmgt.com/?q=height+of+an+equilateral+square+pyramid
cg=h/4;  % Data from https://www.lmgt.com/?q=center+of+mass+of+a+square+pyramid
Q=[-1   1  -1   1  -2   0   2   0   0   0;    % Locations of the free nodes of the truss
   -1  -1   1   1   0  -2   0   2   0   0;
   2*h 2*h 2*h 2*h  0   0   0   0  4*h  h]/4;
U=[ 0   0   0   0   0   0   0   0   0   0;    % External forces on the free nodes
    0   0   0   0   0   0   0   0  -1   0;    % of the truss (normalized)
    0   0   0   0   0   0   0   0   0   0];
m=-1; for i=1:2
  if i==1;
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
  else
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
  end
  % Now, convert the D*X*CQ=U problem in (16.3a) to the standard A*x=u form in (16.3b)
  C=CT'; [A,b]=RR_Convert_DXCQ_eq_U_to_Ax_eq_u(Q,P,C,U); 
  % Then, solve for the tensile and compressive forces x in the truss, assuming no pretension
  x=pinv(A)*b;      % This implements (16.4b)... but, does it solve A*x=b?
  r=rank(A), x, A_times_x=A*x, b, error=norm(A*x-b)        % Let's check!!

  % Finally, plot the truss (blue = tension, red = compression)
  figure(1); clf; 
  if error<1e-10, figure(1); RR_Plot_Truss(Q,P,C,U,x); axis equal, end
  if i==1, pause, end
end

% print -dpdf -d_vector -bestfit pyramid_disturbed.pdf
