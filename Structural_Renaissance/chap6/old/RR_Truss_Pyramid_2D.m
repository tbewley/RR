% script RR_Truss_Pyramid_2D.m
% Set up a simple 2D pyramid truss, solve for its internal forces, and plot
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 6)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, P=[ 0  1;            % Locations of the fixed nodes of the truss (normalized units)
           0  0];
Q=[.5 .5   .25  .75  .5;    % Locations of the free nodes of the truss
    0 .866 .433 .433 .289];
U=[ 0  0  0  0  0;    % External forces on the free nodes of the truss (normalized)
  -1 0  0  0  0];   
for i=1:3
  switch i
    case 1
      CT=[1  1  0  0  0  0  0  0  1;          % This one does not have solution...
          0  0  0 -1  1  0  0  0  0;
          0  0  1  1  0  0  1  0  0;
          0  0  0  0 -1  1  0  1  0;
          0  0  0  0  0  0 -1 -1 -1;
         -1  0 -1  0  0  0  0  0  0;
          0 -1  0  0  0 -1  0  0  0];
    case 2
      CT=[1  1  0  0  0  0  0  0  1  0  0  0; % This adds three more members to above truss.
          0  0  0 -1  1  0  0  0  0  0  0 -1;
          0  0  1  1  0  0  1  0  0  0  0  0;
          0  0  0  0 -1  1  0  1  0  0  0  0;
          0  0  0  0  0  0 -1 -1 -1  1  1  1;
         -1  0 -1  0  0  0  0  0  0 -1  0  0;
          0 -1  0  0  0 -1  0  0  0  0 -1  0];
    case 3
      CT=[1  0  1  0  0  0  0 -1 -1;          % This reconnects truss as some triangles.
          0  0  0  0 -1 -1  0  0  0;
          0  1  0  0  1  0  1  0  1;
          0  0  0  1  0  1 -1  1  0;
          0  0  0  0  0  0  0  0  0;
         -1 -1  0  0  0  0  0  0  0;
          0  0 -1 -1  0  0  0  0  0];
  end
  % Now, convert the D*X*CQ=U problem in (16.3a) to the standard A*x=u form in (16.3b)
  C=CT'; [A,b]=RR_Convert_DXCQ_eq_U_to_Ax_eq_b(Q,P,C,U); 
  % Then, solve for the tensile and compressive forces x in the truss, assuming no pretension
  x=pinv(A)*b;      % This implements (16.4b)... but, does it solve A*x=b?
  r=rank(A), error=norm(A*x-b)        % Let's check!!

  % Finally, plot the truss (blue = tension, red = compression)
  if error<1e-10, figure(1); clf; RR_Plot_Truss(Q,P,C,U,x); axis equal, end
  if i<3, pause, end
end
