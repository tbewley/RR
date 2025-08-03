% script RR_Tensegrity_Prism_3D.m
% Set up a tensegrity prism (Skelton p. 107), solve for internal forces, and plot

clear, P=[];    % Locations of the fixed nodes of the truss (normalized units)
L=1; m=-1; a=30; h=2; f=1;
Q=[cosd(0) cosd(120) cosd(240) cosd(0+a) cosd(120+a) cosd(240+a); % free nodes 
   sind(0) sind(120) sind(240) sind(0+a) sind(120+a) sind(240+a); 
   0       0         0         h         h           h];
U=[0  0  0  0  0  0;    % External forces on the free nodes
   0  0  0  0  0  0;    % of the truss (normalized)
   f  f  f -f -f -f];
% q1 q2 q3 q4 q5 q6 <- nodes
C=[1  0  0  0  m  0;   % <- bar #1 
   0  1  0  0  0  m;   % <- bar #2
   0  0  1  m  0  0;   % <- bar #3 
   1  0  0  m  0  0;   % <- string #1 (vertical)
   0  1  0  0  m  0;   % <- string #2 (vertical)
   0  0  1  0  0  m;   % <- string #3 (vertical)
   1  m  0  0  0  0;   % <- string #4 (bottom)
   0  1  m  0  0  0;   % <- string #5 (bottom)
   m  0  1  0  0  0;   % <- string #6 (bottom)
   0  0  0  1  m  0;   % <- string #7 (top)
   0  0  0  0  1  m;   % <- string #8 (top)
   0  0  0  m  0  1];  % <- string #9 (top)

% Now, convert the D*X*CQ=U problem in (16.3a) to the standard A*x=u form in (16.3b)
[A,b]=RR_Convert_DXCQ_eq_U_to_Ax_eq_b(Q,P,C,U); 
% Then, solve for the tensile and compressive forces x in the truss, assuming no pretension
x=pinv(A)*b;      % This implements (16.4b)... but, does it solve A*x=b?
r=rank(A), x, A_times_x=A*x, b, error=norm(A*x-b)        % Let's check!!
N=null(A)

% Plot the pretensions tensegrity structure (bars are blue, tendons are red) and its dual.
figure(1), clf; RR_Plot_Truss(Q,P,C,U,x+5*N(:,1)), axis equal, view(24,12.3), axis off
