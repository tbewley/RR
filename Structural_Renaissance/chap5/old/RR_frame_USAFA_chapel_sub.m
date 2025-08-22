% script RR_frame_USAFA_chapel_sub.m
% Set up a simple 3D pyramid truss, solve for its internal forces, and plot
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 5)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear
S.P =[3.5115 3.5115; % x coord (m)
      0      0;      % y coord (m)
      24.33  0];     % z coord (m)
     % q1    q2    q3     q4    q5     q6      q7    q8     q9     q10    q11    q12    q13    q14   q15
S.Q =[2.341  4.682  3.5115 1.170 5.8515 3.5115  0.000 7.0215 3.5115 1.170  5.5815 3.5115 2.341  4.682 3.5115; % x (m)
     -2.027 -2.027 0.00  -4.055 -4.055 0.00   -6.082 -6.082 0.00   -4.055 -4.055 0.00  -2.027 -2.027 0.00  ; % y (m)
     20.275 20.275 20.275 16.22 16.22  16.22  12.165 12.165 12.165 8.11   8.11   8.11   4.055  4.055 4.055]; % z (m)
% define u matrix (applied force on nodes)
% approximate each structural tube as 15kg = 150N
% 100N = approx 30 mph winds --> approx 50N each in x and z directions
y = -150; % y force (N)
z = -50;  % z force (N)
x = -50;  % x force (N)
L.U= [x x x x x x x x x x x x x x x;  % applied x force (N)
      y y y y y y y y y y y y y y y;  % applied y force (N)
      z z z z z z z z z z z z z z z]; % applied z force (N)
  % nodes (q=free, p=fixed)
  % q1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 p1 2
S.C=[1 0 0 0 0 0 0 0 0 0 0 0 0 0 0  1 0;  % m1
     0 1 0 0 0 0 0 0 0 0 0 0 0 0 0  1 0;  % m2
     0 0 1 0 0 0 0 0 0 0 0 0 0 0 0  1 0;  % m3
     1 0 1 0 0 0 0 0 0 0 0 0 0 0 0  0 0;  % m4
     0 1 1 0 0 0 0 0 0 0 0 0 0 0 0  0 0;  % m5
     1 1 0 0 0 0 0 0 0 0 0 0 0 0 0  0 0;  % m6
     1 0 0 0 0 1 0 0 0 0 0 0 0 0 0  0 0;  % m7
     0 1 0 0 0 1 0 0 0 0 0 0 0 0 0  0 0;  % m8
     0 0 1 0 0 1 0 0 0 0 0 0 0 0 0  0 0;  % m9
     1 0 0 1 0 0 0 0 0 0 0 0 0 0 0  0 0;  % m10
     0 1 0 0 1 0 0 0 0 0 0 0 0 0 0  0 0;  % m11
     0 0 0 1 0 1 0 0 0 0 0 0 0 0 0  0 0;  % m12
     0 0 0 0 1 1 0 0 0 0 0 0 0 0 0  0 0;  % m13
     0 0 0 1 1 0 0 0 0 0 0 0 0 0 0  0 0;  % m14
     0 0 0 1 0 0 0 0 1 0 0 0 0 0 0  0 0;  % m15
     0 0 0 0 1 0 0 0 1 0 0 0 0 0 0  0 0;  % m16
     0 0 0 0 0 1 0 0 1 0 0 0 0 0 0  0 0;  % m17
     0 0 0 1 0 0 1 0 0 0 0 0 0 0 0  0 0;  % m18
     0 0 0 0 1 0 0 1 0 0 0 0 0 0 0  0 0;  % m19
     0 0 0 0 0 0 1 0 1 0 0 0 0 0 0  0 0;  % m20
     0 0 0 0 0 0 0 1 1 0 0 0 0 0 0  0 0;  % m21
     0 0 0 0 0 0 1 1 0 0 0 0 0 0 0  0 0;  % m22
     0 0 0 0 0 0 1 0 0 1 0 0 0 0 0  0 0;  % m23
     0 0 0 0 0 0 0 1 0 0 1 0 0 0 0  0 0;  % m24
     0 0 0 0 0 0 0 0 1 1 0 0 0 0 0  0 0;  % m25
     0 0 0 0 0 0 0 0 1 0 1 0 0 0 0  0 0;  % m26
     0 0 0 0 0 0 0 0 1 0 0 1 0 0 0  0 0;  % m27
     0 0 0 0 0 0 0 0 0 1 0 1 0 0 0  0 0;  % m28
     0 0 0 0 0 0 0 0 0 0 1 1 0 0 0  0 0;  % m29
     0 0 0 0 0 0 0 0 0 1 1 0 0 0 0  0 0;  % m30
     0 0 0 0 0 0 0 0 0 1 0 0 1 0 0  0 0;  % m31
     0 0 0 0 0 0 0 0 0 0 1 0 0 1 0  0 0;  % m32
     0 0 0 0 0 0 0 0 0 0 0 1 1 0 0  0 0;  % m33
     0 0 0 0 0 0 0 0 0 0 0 1 0 1 0  0 0;  % m34
     0 0 0 0 0 0 0 0 0 0 0 1 0 0 1  0 0;  % m35
     0 0 0 0 0 0 0 0 0 0 0 0 1 0 1  0 0;  % m36
     0 0 0 0 0 0 0 0 0 0 0 0 0 1 1  0 0;  % m37
     0 0 0 0 0 0 0 0 0 0 0 0 1 1 0  0 0;  % m38
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 1  0 1;  % m39
     0 0 0 0 0 0 0 0 0 0 0 0 1 0 0  0 1;  % m40
     0 0 0 0 0 0 0 0 0 0 0 0 0 1 0  0 1]; % m41

[A,b,S,L]=RR_Structure_Analyze(S,L); x=pinv(A)*b;     
% Finally, plot the truss (blue = tension, red = compression)
figure(1), clf, RR_Structure_Plot(S,L,x); error=norm(A*x-b),
