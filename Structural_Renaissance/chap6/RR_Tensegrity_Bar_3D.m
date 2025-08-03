% script RR_Tensegrity_Bar_3D.m
% Set up a tensegrity surrogate for a bar in 3D, solve for its internal forces, and plot

clear, P=[];    % Locations of the fixed nodes of the truss (normalized units)
L=1; phi=15; R=L*tand(phi); m=-1; s1=R*sind(120); s2=R*sind(240); c1=R*cosd(120); c2=R*cosd(240); 
Q=[0  1 -1  0  0  0;
   0  0  0  0 s1 s2;    % Locations of the free nodes of the truss
   0  0  0  R c1 c2];
f=.5
U=[0 -f  f  0  0  0;    % External forces on the free nodes
   0  0  0  0  0  0;    % of the truss (normalized)
   0  0  0  0  0  0];

% q1 q2 q3 q4 q5 q6 <- nodes
C=[0  1  0  m  0  0;   % <- bar #1 
   0  1  0  0  m  0;
   0  1  0  0  0  m;
   0  0  1  m  0  0;
   0  0  1  0  m  0;
   0  0  1  0  0  m;
   0  0  0  1  m  0;
   0  0  0  0  1  m;
   0  0  0  m  0  1;   % <- bar #9
   1  m  0  0  0  0;   % <- string #1
   1  0  m  0  0  0;   
   1  0  0  m  0  0;
   1  0  0  0  m  0;
   1  0  0  0  0  m];  % <- string #5

% Now, convert the D*X*CQ=U problem in (16.3a) to the standard A*x=u form in (16.3b)
[A,b]=RR_Convert_DXCQ_eq_U_to_Ax_eq_b(Q,P,C,U); 
% Then, solve for the tensile and compressive forces x in the truss, assuming no pretension
x=pinv(A)*b;      % This implements (16.4b)... but, does it solve A*x=b?
r=rank(A), x, A_times_x=A*x, b, error=norm(A*x-b)        % Let's check!!
N=null(A)

% Plot the pretensions tensegrity structure (bars are blue, tendons are red) and its dual.
figure(1), clf; RR_Plot_Truss(Q,P,C,U,x-3*N(:,2)), axis equal, view(24,12.3), axis off
figure(2), clf; RR_Plot_Truss(Q,P,C,U,x+3*N(:,2)), axis equal, view(24,12.3), axis off
pause

alpha=(x(14)-0.5*N(14,2))/N(14,1)
figure(3), clf, RR_Plot_Truss(Q,P,C,U,x-0.5*N(:,2)-alpha*N(:,1)), axis equal, view(24,12.3), axis off
alpha=(x(10)-0.5*N(10,2))/N(10,1)
figure(4), clf, RR_Plot_Truss(Q,P,C,U,x-0.5*N(:,2)-alpha*N(:,1)), axis equal, view(24,12.3), axis off

alpha=(x(14)+1*N(14,2))/N(14,1)
figure(5), clf, RR_Plot_Truss(Q,P,C,U,x+1*N(:,2)-alpha*N(:,1)), axis equal, view(24,12.3), axis off
alpha=(x(10)+8*N(10,2))/N(10,1)
figure(6), clf, RR_Plot_Truss(Q,P,C,U,x+8*N(:,2)-alpha*N(:,1)), axis equal, view(24,12.3), axis off

% print -dpdf -d_vector -bestfit 
