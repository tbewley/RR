% script RR_truss_Roof_Fink.m
% Set up a Fink truss (or, frame...), solve for its internal forces, and plot
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 5)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear S L, disp('Analyze/plot a Fink truss, taking both supports as pinned')
S.P=[  0  30;   % Columns denote (x,y) locations of each of the p=2 fixed nodes (normalized)
       0   0];
S.Q=[ 7.5 10  15  20 22.5 ;    % Locations of each of the n=5 free nodes (normalized)
      2.5  0   5   0  2.5];
L.U=[  0   0   0   0   0  ;    % External forces on the n free nodes of the truss (normalized)
     -650  0 -650  0 -650];     
S.C=[  1   1   0   0   0   0   0;  % Connectivity as a TRUSS
       0   1   1   0   0   0   0;  
       0   0   1   1   0   0   0;  
       0   0   0   1   1   0   0;  
       0   1   0   0   0   1   0;  
       0   1   0   1   0   0   0;   
       0   0   0   1   0   0   1;   
       1   0   0   0   0   1   0;   
       1   0   1   0   0   0   0;   
       0   0   1   0   1   0   0;   
       0   0   0   0   1   0   1]; 
[A,b,S,L]=RR_Structure_Analyze(S,L); x=pinv(A)*b;     
figure(1); RR_Structure_Plot(S,L,x); error=norm(A*x-b), pause

disp('Repeat, taking right support as a roller');
S.P=[0; 0]; S.R=[30; 0];
[A,b,S,L]=RR_Structure_Analyze(S,L); x=pinv(A)*b;      
figure(2); RR_Structure_Plot(S,L,x); error=norm(A*x-b), pause

disp('Repeat, taking connectivity as a frame, with a continuous beam for the lower chord');
S.C=[ 1   1   0   0   0   0   0;  % Connectivity as a FRAME
      0   1   1   0   0   0   0;
      0   0   1   1   0   0   0; 
      0   0   0   1   1   0   0;
      1   0   0   0   0   1   0;  % upper-left  chord part A
      1   0   1   0   0   0   0;  % upper-left  chord part B
      0   0   1   0   1   0   0;  % upper-right chord part A 
      0   0   0   0   1   0   1;  % upper-right chord part B
      0   1   0   1   0   1   1]; % bottom chord (connects 4 nodes)
[A,b,S,L]=RR_Structure_Analyze(S,L); x=pinv(A)*b     
figure(3); RR_Structure_Plot(S,L,x); error=norm(A*x-b), pause

disp('Repeat, taking continuous beams for both the lower and the two upper chords)');
S.C=[ 1   1   0   0   0   0   0;  % Connectivity as a FRAME
      0   1   1   0   0   0   0;
      0   0   1   1   0   0   0; 
      0   0   0   1   1   0   0;
      0   1   0   1   0   1   1;  % bottom      chord (connects 4 nodes)
      1   0   1   0   0   1   0;  % upper-left  chord (connects 3 nodes)
      0   0   1   0   1   0   1]; % upper-right chord (connects 3 nodes)
[A,b,S,L]=RR_Structure_Analyze(S,L); x=pinv(A)*b;  
figure(4); RR_Structure_Plot(S,L,x); error=norm(A*x-b), pause


clear S L, disp('Now consider a 3D Fink structure (as a TRUSS, taking several support points as pinned)')
S.P=[  0   0   0   0;   
       0   6  12  18;
       0   0   0   0];
S.R=[ 30  30  30  30  10 20;   
       0   6  12  18  18 18;
       0   0   0   0   0  0];      
S.Q=[7.5 10  15  20 22.5 7.5 10  15  20 22.5  7.5 10  15  20 22.5  7.5  15  22.5;
     0   0   0   0   0    6   6   6   6   6   12  12  12  12  12   18   18   18  
    2.5  0   5   0  2.5  2.5  0   5   0  2.5  2.5  0   5   0  2.5  2.5   5   2.5];
L.U=[0   0   0   0   0    0   0   0   0   0    0   0   0   0   0    0    0    0  ;    
     0   0   0   0   0    0   0   0   0   0    0   0   0   0   0    0    0    0  ;
   -325  0 -325  0 -325 -650  0 -650  0 -650 -650  0 -650  0 -650 -325 -325 -325];     
S.C=[1   1   0   0   0    0   0   0   0   0    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   1   1   0   0    0   0   0   0   0    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   0   1   1   0    0   0   0   0   0    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   0   0   1   1    0   0   0   0   0    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   1   0   0   0    0   0   0   0   0    0   0   0   0   0    0    0    0  1  0  0  0  0  0  0  0  0  0;  
     0   1   0   1   0    0   0   0   0   0    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;   
     0   0   0   1   0    0   0   0   0   0    0   0   0   0   0    0    0    0  0  0  0  0  1  0  0  0  0  0;   
     1   0   0   0   0    0   0   0   0   0    0   0   0   0   0    0    0    0  1  0  0  0  0  0  0  0  0  0;   
     1   0   1   0   0    0   0   0   0   0    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;   
     0   0   1   0   1    0   0   0   0   0    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;   
     0   0   0   0   1    0   0   0   0   0    0   0   0   0   0    0    0    0  0  0  0  0  1  0  0  0  0  0; 
     0   0   0   0   0    1   1   0   0   0    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   1   1   0   0    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   0   1   1   0    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   0   0   1   1    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   1   0   0   0    0   0   0   0   0    0    0    0  0  1  0  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   1   0   1   0    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;   
     0   0   0   0   0    0   0   0   1   0    0   0   0   0   0    0    0    0  0  0  0  0  0  1  0  0  0  0;   
     0   0   0   0   0    1   0   0   0   0    0   0   0   0   0    0    0    0  0  1  0  0  0  0  0  0  0  0;   
     0   0   0   0   0    1   0   1   0   0    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;   
     0   0   0   0   0    0   0   1   0   1    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;   
     0   0   0   0   0    0   0   0   0   1    0   0   0   0   0    0    0    0  0  0  0  0  0  1  0  0  0  0;
     0   0   0   0   0    0   0   0   0   0    1   1   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   0   0   0   0    0   1   1   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   0   0   0   0    0   0   1   1   0    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   0   0   0   0    0   0   0   1   1    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   0   0   0   0    0   1   0   0   0    0    0    0  0  0  1  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   0   0   0   0    0   1   0   1   0    0    0    0  0  0  0  0  0  0  0  0  0  0;   
     0   0   0   0   0    0   0   0   0   0    0   0   0   1   0    0    0    0  0  0  0  0  0  0  1  0  0  0;   
     0   0   0   0   0    0   0   0   0   0    1   0   0   0   0    0    0    0  0  0  1  0  0  0  0  0  0  0;   
     0   0   0   0   0    0   0   0   0   0    1   0   1   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;   
     0   0   0   0   0    0   0   0   0   0    0   0   1   0   1    0    0    0  0  0  0  0  0  0  0  0  0  0;   
     0   0   0   0   0    0   0   0   0   0    0   0   0   0   1    0    0    0  0  0  0  0  0  0  1  0  0  0;
     0   0   0   0   0    0   0   0   0   0    0   0   0   0   0    1    0    0  0  0  0  0  0  0  0  0  1  0;  
     0   0   0   0   0    0   0   0   0   0    0   0   0   0   0    0    1    0  0  0  0  0  0  0  0  0  1  0;  
     0   0   0   0   0    0   0   0   0   0    0   0   0   0   0    0    1    0  0  0  0  0  0  0  0  0  0  1;  
     0   0   0   0   0    0   0   0   0   0    0   0   0   0   0    0    0    1  0  0  0  0  0  0  0  0  0  1;  
     0   0   0   0   0    0   0   0   0   0    0   0   0   0   0    0    0    0  0  0  0  1  0  0  0  0  1  0;  
     0   0   0   0   0    0   0   0   0   0    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  1  1;   
     0   0   0   0   0    0   0   0   0   0    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  1  0  1;   
     0   0   0   0   0    0   0   0   0   0    0   0   0   0   0    1    0    0  0  0  0  1  0  0  0  0  0  0;   
     0   0   0   0   0    0   0   0   0   0    0   0   0   0   0    1    1    0  0  0  0  0  0  0  0  0  0  0;   
     0   0   0   0   0    0   0   0   0   0    0   0   0   0   0    0    1    1  0  0  0  0  0  0  0  0  0  0;   
     0   0   0   0   0    0   0   0   0   0    0   0   0   0   0    0    0    1  0  0  0  0  0  0  0  1  0  0;
     0   0   0   0   0    0   0   0   0   0    0   0   0   0   0    0    0    0  1  1  0  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   0   0   0   0    0   0   0   0   0    0    0    0  0  1  1  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   0   0   0   0    0   0   0   0   0    0    0    0  0  0  1  1  0  0  0  0  0  0;  
     0   0   0   0   0    0   0   0   0   0    0   0   0   0   0    0    0    0  0  0  0  0  1  1  0  0  0  0;  
     0   0   0   0   0    0   0   0   0   0    0   0   0   0   0    0    0    0  0  0  0  0  0  1  1  0  0  0;  
     0   0   0   0   0    0   0   0   0   0    0   0   0   0   0    0    0    0  0  0  0  0  0  0  1  1  0  0;
     1   0   0   0   0    1   0   0   0   0    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   0   0   0   0    1   0   0   0   0    1   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   0   0   0   0    1   0   0   0   0    1    0    0  0  0  0  0  0  0  0  0  0  0;
     0   1   0   0   0    0   1   0   0   0    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   1   0   0   0    0   1   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   0   0   0   0    0   1   0   0   0    0    0    0  0  0  0  0  0  0  0  0  1  0;
     0   0   1   0   0    0   0   1   0   0    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   0   1   0   0    0   0   1   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   0   0   0   0    0   0   1   0   0    0    1    0  0  0  0  0  0  0  0  0  0  0;
     0   0   0   1   0    0   0   0   1   0    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   0   0   1   0    0   0   0   1   0    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   0   0   0   0    0   0   0   1   0    0    0    0  0  0  0  0  0  0  0  0  0  1;
     0   0   0   0   1    0   0   0   0   1    0   0   0   0   0    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   0   0   0   1    0   0   0   0   1    0    0    0  0  0  0  0  0  0  0  0  0  0;  
     0   0   0   0   0    0   0   0   0   0    0   0   0   0   1    0    0    1  0  0  0  0  0  0  0  0  0  0];
[A,b,S,L]=RR_Structure_Analyze(S,L); x=pinv(A)*b;     
figure(5); RR_Structure_Plot(S,L,x); error=norm(A*x-b), view(15.4, 11.4)
