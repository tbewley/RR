% script RR_frame_USAFA_chapel_sub
% Analyzes a single tetrahedron of the USAFA chapel
% There are 17*4+16*2=100 such tetrahedra in the full USAFA_chapel.
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 6)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear                     % (measurements in feet - sorry...)
length=75;                % length of long diagonal of tetrahedron
depth=21;                 % depth of tetrahedron
t=1.5;                    % width of strips between tetrahedra (somewhere between 1.5 and 2)
inc=17.5;                 % distance between spires
%%%%%%%%%%%%% Now set up 5 additional useful derived numbers
w=(inc-2*t)/2;            % half width of tetrahedron
phi=atan(depth/length);   % angle of tetrahedron in the y-z plane
H=sqrt(length^2-depth^2); % vertical height of tetrahedron 
h2=(length/2)/cos(phi);   % height of upper part of tetrahedron (note: h1+h2=H, h2>h1)
h1=H-h2;                  % height of lower part of tetrahedron

S.P(:,1)=[ 0; 2*depth; 0]; S.P_vec(:,1)=[0;0;1];
S.P(:,2)=[ 0;  depth;  H]; S.P_vec(:,2)=[0;1;0];
S.R(:,1)=[+w;  depth; h1]; S.R_vec(:,1)=[0;1;0];
S.R(:,2)=[-w;  depth; h1]; S.R_vec(:,2)=[0;1;0];

for i=1:5, S.Q(:,i   )=((6-i)/6)*S.P(:,1)+(i/6)*S.P(:,2); end
for i=1:2, S.Q(:,i+ 5)=((3-i)/3)*S.P(:,1)+(i/3)*S.R(:,1); end
for i=1:2, S.Q(:,i+ 7)=((3-i)/3)*S.P(:,1)+(i/3)*S.R(:,2); end
for i=1:2, S.Q(:,i+ 9)=((3-i)/3)*S.P(:,2)+(i/3)*S.R(:,1); end
for i=1:2, S.Q(:,i+11)=((3-i)/3)*S.P(:,2)+(i/3)*S.R(:,2); end, q=13;

   % 1 2 3 4 5 6 7 8 9 0 1 2 3 1 2 1 2
S.C=[1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 0 0;
     0 0 0 0 0 1 1 0 0 0 0 0 0 1 0 1 0;
     0 0 0 0 0 0 0 1 1 0 0 0 0 1 0 0 1;
     0 0 0 0 0 0 0 0 0 1 1 0 0 0 1 1 0;
     0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 0 1;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1;     
     1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0;
     1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0;
     0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0;
     0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0;
     0 1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0;
     0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0;
     0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0;
     0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0;
     0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0;
     0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
     0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0;
     0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0;
     0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0;
     0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0;
     0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0;
     0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0;
     0 0 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0;
     0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0;
     0 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 0];

L.U=zeros(3,q);
[A,b,S,L]=RR_Structure_Analyze(S,L); x=pinv(A)*b;     
figure(5); RR_Structure_Plot(S,L,x); error=norm(A*x-b), view(15.4, 11.4)
