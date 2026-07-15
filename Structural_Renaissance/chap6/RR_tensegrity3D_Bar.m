% script RR_tensegrity3D_Bar.m
% Set up a tensegrity surrogate for a bar in 3D, solve for its internal forces, and plot

clear, P=[];    % Locations of the fixed nodes of the truss (normalized units)
length=1; phi=15; R=length*tand(phi); s1=R*sind(120); s2=R*sind(240); c1=R*cosd(120); c2=R*cosd(240); 
S.Q=[0  1 -1  0  0  0;
     0  0  0  0 s1 s2;    % Locations of the free nodes of the truss
     0  0  0  R c1 c2];
L.U=[0 -1  1  0  0  0;    % External forces on the free nodes
     0  0  0  0  0  0;    % of the truss (normalized)
     0  0  0  0  0  0]/2;
% q1 q2 q3 q4 q5 q6 <- nodes
S.C=[0  1  0  1  0  0;   % <- bar #1 
     0  1  0  0  1  0;
     0  1  0  0  0  1;
     0  0  1  1  0  0;
     0  0  1  0  1  0;
     0  0  1  0  0  1;
     0  0  0  1  1  0;
     0  0  0  0  1  1;
     0  0  0  1  0  1;   % <- bar #9
     1  1  0  0  0  0;   % <- string #1
     1  0  1  0  0  0;   
     1  0  0  1  0  0;
     1  0  0  0  1  0;
     1  0  0  0  0  1];  % <- string #5
% Convert the eqns for computing the interior & reaction forces to Ax=b, solve, and plot.
[A,b,S,L]=RR_Structure_Analyze(S,L); x=pinv(A)*b; error_norm=norm(A*x-b), r=rank(A), N=null(A)
% Finally, plot the truss (blue = tension, red = compression)

% Plot the pretensions tensegrity structure (bars are blue, tendons are red) and its dual.
figure(1), clf; RR_Structure_Plot(S,L,x-3*N(:,2)), axis equal, view(24,12.3), axis off, pause
figure(2), clf; RR_Structure_Plot(S,L,x+3*N(:,2)), axis equal, view(24,12.3), axis off, pause

alpha=(x(14)-0.5*N(14,2))/N(14,1)
figure(3), clf, RR_Structure_Plot(S,L,x-0.5*N(:,2)-alpha*N(:,1)), axis equal, view(24,12.3), axis off
alpha=(x(10)-0.5*N(10,2))/N(10,1)
figure(4), clf, RR_Structure_Plot(S,L,x-0.5*N(:,2)-alpha*N(:,1)), axis equal, view(24,12.3), axis off, pause

alpha=(x(14)+1*N(14,2))/N(14,1)
figure(5), clf, RR_Structure_Plot(S,L,x+1*N(:,2)-alpha*N(:,1)), axis equal, view(24,12.3), axis off, pause
alpha=(x(10)+8*N(10,2))/N(10,1)
figure(6), clf, RR_Structure_Plot(S,L,x+8*N(:,2)-alpha*N(:,1)), axis equal, view(24,12.3), axis off

% print -dpdf -d_vector -bestfit 
