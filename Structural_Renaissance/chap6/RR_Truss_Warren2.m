% script RR_Truss_Warren2.m
% Set up a Warren truss with 2 sections, solve for its internal forces, and plot
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 6)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

% First, do 2D problem:
P=[ 0 20;   % Columns denote (x,y) locations of each of the p=2 fixed nodes (SI units)
    0  0];
Q=[10   5   15  ; % (x,y) locations of each of the n=3 free nodes (SI units)
    0 8.66 8.66];
U=[ 0  0  0;      % External forces on the n free nodes of the truss (SI units)
   -1  0  0];
  % m1 m2 m3 m4 m5 m6 m7 
CT=[ 1  1  0  0  1  1  0;  % q_1 Connectivity of the truss
     0  0  1  1 -1  0  0;  % q_2 Note: each of the m=7 columns of C^T
     0  0 -1  0  0 -1  1;  % q_3 has exactly one entry equal to +1 and one equal to -1
    -1  0  0 -1  0  0  0;  % p_1 
     0 -1  0  0  0  0 -1]; % p_2
% Now, convert the D*X*CQ=U problem in (6.3a) to the standard A*x=u form in (6.3b)
C=CT'; [A,b]=RR_Convert_DXCQ_eq_U_to_Ax_eq_b(Q,P,C,U); 
% Then, just solve for the tension and compression in the members, and plot.
x=pinv(A)*b;                % This just implements (6.4b),  Assumes zero pretension!
figure(1), RR_Plot_Truss(Q,P,C,U,x);  % Plot truss (red=positive=tension, blue=negative=compression)
axis tight, % print -dpdf Warren2.pdf
pause

% Then, do 3D version:
P=[ 0 20  0 20;           % (x,y,z) locations of the p=4 fixed nodes (SI units)
    0  0 10 10;
    0  0  0  0];
Q=[10  5   15   10  5   15;  % Locations of the n=6 free nodes (SI units)
    0  0    0   10 10   10;
    0 8.66 8.66  0 8.66 8.66];
U=[ 0  0    0    0  0    0;  % External forces on the n=6 free nodes (SI units)
    0  0    0    0  0    0;
 -500  0    0 -500  0    0];   
CT=[ 1  1  0  0  1  1  0  0  0  0  0  0  0  0  1  0  0;  % q_1 Connectivity
     0  0  1  1 -1  0  0  0  0  0  0  0  0  0  0  1  0;  % q_2
     0  0 -1  0  0 -1  1  0  0  0  0  0  0  0  0  0  1;  % q_3 
     0  0  0  0  0  0  0  1  1  0  0  1  1  0 -1  0  0;  % q_4
     0  0  0  0  0  0  0  0  0  1  1 -1  0  0  0 -1  0;  % q_5
     0  0  0  0  0  0  0  0  0 -1  0  0 -1  1  0  0 -1;  % q_6
    -1  0  0 -1  0  0  0  0  0  0  0  0  0  0  0  0  0;  % p_1
     0 -1  0  0  0  0 -1  0  0  0  0  0  0  0  0  0  0;  % p_2
     0  0  0  0  0  0  0 -1  0  0 -1  0  0  0  0  0  0;  % p_3
     0  0  0  0  0  0  0  0 -1  0  0  0  0 -1  0  0  0]; % p_4
% Now, convert the D*X*CQ=U problem in (6.3a) to the standard A*x=u form in (6.3b)
C=CT'; [A,b]=RR_Convert_DXCQ_eq_U_to_Ax_eq_b(Q,P,C,U); 
% Then, just solve for the tension and compression in the members, and plot.
x=pinv(A)*b;                % This just implements (6.4b),  Assumes zero pretension!
RR_Plot_Truss(Q,P,C,U,x,[],[],[m m m m m m]);  % Plot truss (red=positive=tension, blue=negative=compression)
axis tight, view(19.23,10.15), print -dpdf Warren2_3D.pdf
pause,

m=-1
CT=[1 1 1 1 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 1 0 0;  % q_1 Connectivity of the truss
    0 0 m 0 1 1 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0;  % q_2
    0 0 0 m m 0 1 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0;  % q_3 
    0 0 0 0 0 0 0 1 1 1 1 0 0 0 m 0 0 0 0 0 0 0 0 1 1;  % q_4
    0 0 0 0 0 0 0 0 0 m 0 1 1 0 0 m 0 0 m 0 0 0 0 0 0;  % q_5
    0 0 0 0 0 0 0 0 0 0 m m 0 1 0 0 m m 0 0 0 0 0 0 0;  % q_6
    m 0 0 0 0 m 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 m;  % p_1
    0 m 0 0 0 0 m 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 m 0;  % p_2
    0 0 0 0 0 0 0 m 0 0 0 0 m 0 0 0 0 0 0 m 0 0 m 0 0;  % p_3
    0 0 0 0 0 0 0 0 m 0 0 0 0 m 0 0 0 0 0 0 m m 0 0 0]; % p_4
% Now, convert the D*X*CQ=U problem in (6.3a) to the standard A*x=u form in (6.3b)
C=CT'; [A,b]=RR_Convert_DXCQ_eq_U_to_Ax_eq_b(Q,P,C,U); 
% Then, just solve for the tension and compression in the members, and plot.
x=pinv(A)*b;                 % This just implements (6.4b),  Assumes zero pretension!
RR_Plot_Truss(Q,P,C,U,x,[],[],[m m m m m m]);  % Plot truss (red=positive=tension, blue=negative=compression)
axis tight, view(19.23,10.15), print -dpdf Warren2_3D_extra2.pdf
pause

CT=[1 1 1 1 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0;  % q_1 Connectivity of the truss
    0 0 m 0 1 1 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 1 0;  % q_2
    0 0 0 m m 0 1 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 1;  % q_3 
    0 0 0 0 0 0 0 1 1 1 1 0 0 0 m 0 0 0 0 0 0 0 0 1 1 0 0 0 0;  % q_4
    0 0 0 0 0 0 0 0 0 m 0 1 1 0 0 m 0 0 m 0 0 0 0 0 0 1 0 0 0;  % q_5
    0 0 0 0 0 0 0 0 0 0 m m 0 1 0 0 m m 0 0 0 0 0 0 0 0 1 0 0;  % q_6
    m 0 0 0 0 m 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 m m 0 0 0;  % p_1
    0 m 0 0 0 0 m 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 m 0 0 m 0 0;  % p_2
    0 0 0 0 0 0 0 m 0 0 0 0 m 0 0 0 0 0 0 m 0 0 m 0 0 0 0 m 0;  % p_3
    0 0 0 0 0 0 0 0 m 0 0 0 0 m 0 0 0 0 0 0 m m 0 0 0 0 0 0 m]; % p_4
% Now, convert the D*X*CQ=U problem in (6.3a) to the standard A*x=u form in (6.3b)
C=CT'; [A,b]=RR_Convert_DXCQ_eq_U_to_Ax_eq_b(Q,P,C,U); 
% Then, just solve for the tension and compression in the members, and plot.
x=pinv(A)*b;                 % This just implements (6.4b),  Assumes zero pretension!
RR_Plot_Truss(Q,P,C,U,x,[],[],[m m m m m m]);  % Plot truss (red=positive=tension, blue=negative=compression)
axis tight, view(19.23,10.15), print -dpdf Warren2_3D_extra3.pdf
pause

CT=abs(CT); C=CT'; 
% Now, convert the linear eqns for computing the interior forces in the frame
% into standard A*x=u form
[A,b]=RR_Convert_Frame_to_Ax_eq_b(Q,C,U,P); 
% Then, solve for the interior forces in the frame
x=pinv(A)*b; error=norm(A*x-b)
if error>1e-8, disp('No equilibrium solution'), else,
    RR_Plot_Frame(Q,C,U,x,P,[],[],[],[],[],[m m m m m m])
end
view(19.23,10.15), pause,

Q=[10   5    15 10   5    15   5*2/3   5*2/3   20-5*2/3   20-5*2/3    ;    % Locations of each of the n=8 free nodes (normalized)
    0   0     0 10  10    10   0       10        0       10       ;
    0 8.66 8.66  0 8.66 8.66  8.66*2/3 8.66*2/3 8.66*2/3 8.66*2/3 ];
U=[ 0 0 0  0 0 0 0 0 0 0;    % External forces on the n free nodes of the truss (normalized)
    0 0 0  0 0 0 0 0 0 0;
   -1 0 0 -1 0 0 0 0 0 0];

CT=[1 1 1 1 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 1 0 0 0 0;  % q_1 Connectivity of the truss
    0 0 m 0 1 1 0 0 0 0 0 0 0 0 0 1 0 1 0 0 1 0 0 0 0 0 0 0 0;  % q_2
    0 0 0 m m 0 0 1 0 0 0 0 0 0 0 0 1 0 1 0 0 0 1 0 0 0 0 0 0;  % q_3 
    0 0 0 0 0 0 0 0 0 1 1 1 1 0 m 0 0 0 0 0 0 0 0 0 0 1 1 0 0;  % q_4
    0 0 0 0 0 0 1 0 0 0 0 m 0 1 0 1 0 0 m 1 0 0 0 0 0 0 0 0 0;  % q_5
    0 0 0 0 0 0 0 0 1 0 0 0 m m 0 0 m m 0 0 0 1 0 0 0 0 0 0 0;  % q_6
    0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 m 0 0 0 0 0 0 0 0 0;  % q_7
    0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 m 0 0 0 0 0 0 0 0;  % q_8
    0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 m 0 0 0 0 0 0 0;  % q_9
    0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 m 0 0 0 0 0 0;  % q_10
    m 0 0 0 0 m 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 m 1 0;  % p_1
    0 m 0 0 0 0 0 m 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 m 0 0 1;  % p_2
    0 0 0 0 0 0 m 0 0 m 0 0 0 0 0 0 0 0 0 0 0 0 0 0 m 0 0 m 0;  % p_3
    0 0 0 0 0 0 0 0 m 0 m 0 0 0 0 0 0 0 0 0 0 0 0 m 0 0 0 0 m]; % p_4
CT=abs(CT); C=CT';
% The following applies some pretension
% ?
% Now, convert the linear eqns for computing the interior forces in the frame
% into standard A*x=u form
[A,b]=RR_Convert_Frame_to_Ax_eq_b(Q,C,U,P); 
% Then, solve for the interior forces in the frame
x=pinv(A)*b; error=norm(A*x-b)
if error>1e-8, disp('No equilibrium solution'), else,
    RR_Plot_Frame(Q,C,U,x,P,[],[],[],[],[],[m m m m m m m m m m])
end, view(19.23,10.15), % print -dpdf Warren2_3D_rigid1.pdf, pause

view(82.40,5.17), % print -dpdf Warren2_3D_rigid2.pdf