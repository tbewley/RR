% script RR_Tensegrity_Bar_3D.m
% Set up a tensegrity surrogate for a bar in 3D, solve for its internal forces, and plot
clear, P=[];    % Locations of the fixed nodes of the truss (normalized units)
L=1; phi=15; R=L*tand(phi); m=-1;
Q=[0 1 -1 0 0           0          ;
   0 0  0 0 R*sind(120) R*sind(240);    % Locations of the free nodes of the truss
   0 0  0 R R*cosd(120) R*cosd(240)];
f=.5
U=[0 -f f 0 0 0;    % External forces on the free nodes
   0  0 0 0 0 0;    % of the truss (normalized)
   0  0 0 0 0 0];
for i=1:3
  if i==1
      %     bar #        | string #
      % 1 2 3 4 5 6 7 8 9 1 2 3 4 5   % node #
    CT=[0 0 0 0 0 0 0 0 0 1 1 1 1 1;  %  q_1
        1 1 1 0 0 0 0 0 0 m 0 0 0 0;  %  q_2
        0 0 0 1 1 1 0 0 0 0 m 0 0 0;  %  q_3
        m 0 0 m 0 0 1 0 m 0 0 m 0 0;  %  q_4
        0 m 0 0 m 0 m 1 0 0 0 0 m 0;  %  q_5
        0 0 m 0 0 m 0 m 1 0 0 0 0 m]; %  q_6
  end
  % Now, convert the D*X*CQ=U problem in (16.3a) to the standard A*x=u form in (16.3b)
  C=CT'; [A,b]=RR_Convert_DXCQ_eq_U_to_Ax_eq_b(Q,P,C,U); 
  % Then, solve for the tensile and compressive forces x in the truss, assuming no pretension
  x=pinv(A)*b;      % This implements (16.4b)... but, does it solve A*x=b?
  r=rank(A), x, A_times_x=A*x, b, error=norm(A*x-b)        % Let's check!!
  figure(1); clf;   % Finally, plot the truss (blue = tension, red = compression)
  N=5*null(A)
  if error<1e-10, figure(1); RR_Plot_Truss(Q,P,C,U,x-N(:,2)); axis equal, end, pause
end

% print -dpdf -d_vector -bestfit pyramid_disturbed.pdf
