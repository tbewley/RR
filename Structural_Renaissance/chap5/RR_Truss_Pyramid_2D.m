% script RR_truss_Pyramid_2D.m
% Set up a simple 2D pyramid truss, solve for its internal forces, and plot
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 5)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

for i=1:3
   clear S L, q=5;
   S.P=[ 0; 0];                  % Locations of the fixed nodes of the truss (normalized units)
   S.R=[ 1; 0];
   S.Q=[.5 .5   .25  .75  .5;    % Locations of the free nodes of the truss
         0 .866 .433 .433 .289];
   L.U=[ 0  0    0    0    0;    % External forces on the free nodes of the truss (normalized)
        -1  0    0    0    0];
   L.U_in=false(q,1)  
  switch i
    case 1
      CT=[1 1 0 0 0 0 0 0 1;     % This one does not have solution...
          0 0 0 1 1 0 0 0 0;
          0 0 1 1 0 0 1 0 0;
          0 0 0 0 1 1 0 1 0;
          0 0 0 0 0 0 1 1 1;
          1 0 1 0 0 0 0 0 0;
          0 1 0 0 0 1 0 0 0];
    case 2
      CT=[1 1 0 0 0 0 0 0 1 0 0 0; % This adds three more members to above truss.
          0 0 0 1 1 0 0 0 0 0 0 1;
          0 0 1 1 0 0 1 0 0 0 0 0;
          0 0 0 0 1 1 0 1 0 0 0 0;
          0 0 0 0 0 0 1 1 1 1 1 1;
          1 0 1 0 0 0 0 0 0 1 0 0;
          0 1 0 0 0 1 0 0 0 0 1 0];
    case 3
      CT=[1 0 1 0 0 0 0 1 1;       % This reconnects truss as some triangles.
          0 0 0 0 1 1 0 0 0;
          0 1 0 0 1 0 1 0 1;
          0 0 0 1 0 1 1 1 0;
          0 0 0 0 0 0 0 0 0;
          1 1 0 0 0 0 0 0 0;
          0 0 1 1 0 0 0 0 0];
  end
  S.C=CT';
  % Convert the eqns for computing the interior & reaction forces to Ax=b, solve, and plot.
  [A,b,S,L]=RR_Structure_Analyze(S,L); x=pinv(A)*b;     
  % Finally, plot the truss (blue = tension, red = compression)
  figure(1), clf, RR_Structure_Plot(S,L,x); error=norm(A*x-b),
  if error>1e-8, disp('NOT A VALID SOLUTION!!!'), end
  if i<3, pause, end
end
