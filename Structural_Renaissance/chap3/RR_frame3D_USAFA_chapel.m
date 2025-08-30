% script RR_frame_USAFA_chapel
% Geometry of USAFA chapel defined by just 5 numbers (measurements in feet - sorry)
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 6)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE
clear; s=17;              % number of spires being modelled (s=17 for full chapel)
length=75;                % length of long diagonal of each tetrahedron
depth=21;                 % depth of each tetrahedron
t=1.5;                    % width of strips between tetrahedra (somewhere between 1.5 and 2)
inc=17.5;                 % distance between spire tips
global RR_VERBOSE; RR_VERBOSE=1; % This controls the quantity of screen output
%%%%%%%%%%%%% Now set up 5 additional useful derived numbers
w=(inc-2*t)/2;            % half width of tetrahedron
phi=atan(depth/length);   % angle of tetrahedron in the y-z plane
H=sqrt(length^2-depth^2); % vertical height of tetrahedron 
h2=(length/2)/cos(phi);   % height of upper part of tetrahedron (note: h1+h2=H, h2>h1)
h1=H-h2;                  % height of lower part of tetrahedron

for i=1:s, S.P(:,i)  =[(i-1)*inc; +2*depth; 0]; end          % + side supports
for i=1:s, S.P(:,i+s)=[(i-1)*inc; -2*depth; 0]; end, p=2*s;  % - side supports

for i=1:s, S.Q(:,i      ) =[(i-1)*inc; 0; 2*H]; end, q=s; % peaks of the s spires

for i=1:s, S.Q(:,3*i-2+q)   =[(i-1)*inc-w;   0; H+h1]; % nodes on (longitudinal) rod #1 (top)
           S.Q(:,3*i-1+q)   =[(i-1)*inc+w;   0; H+h1];
           if i<s
             S.Q(:,3*i+q)   =[(i-1)*inc+w+t; 0; H+h1];
           end, end, q=q+3*s-1;  

for i=1:s, S.Q(:,3*i-2+q)   =[(i-1)*inc;       depth; H];   % nodes on rod #2 (upper, + side)
           if i<s
              S.Q(:,3*i-1+q)=[(i-1)*inc+t;     depth; H];
              S.Q(:,3*i  +q)=[(i-1)*inc+t+2*w; depth; H];
           end, end, q=q+3*s-2;

for i=1:s, S.Q(:,3*i-2+q)   =[(i-1)*inc;     -depth; H];  % nodes on rod #3 (upper, - side)
           if i<s
              S.Q(:,3*i-1+q)=[(i-1)*inc+t;   -depth; H];
              S.Q(:,3*i  +q)=[(i-1)*inc+t+2*w; -depth; H];
           end, end, q=q+3*s-2;

for i=1:s, S.Q(:,3*i-2+q)   =[(i-1)*inc-w;   depth; h1];  % nodes on rod #4 (lower, + side)
           S.Q(:,3*i-1+q)   =[(i-1)*inc+w;   depth; h1];
           if i<s
             S.Q(:,3*i+q)     =[(i-1)*inc+w+t; depth; h1];
           end, end, q=q+3*s-1;  

for i=1:s, S.Q(:,3*i-2+q)   =[(i-1)*inc-w;   -depth; h1]; % nodes on rod #5 (lower, - side)
           S.Q(:,3*i-1+q)   =[(i-1)*inc+w;   -depth; h1];
           if i<s
             S.Q(:,3*i+q)   =[(i-1)*inc+w+t; -depth; h1];
           end, end, q=q+3*s-1; n=q+p; N=[S.Q S.P];

S.C(1,:)=[zeros(1, s    ) ones(1,3*s-1) zeros(1,n-( 4*s-1))];      % longitudinal rod #1
S.C(2,:)=[zeros(1, 4*s-1) ones(1,3*s-2) zeros(1,n-( 7*s-3))];      % longitudinal rod #2
S.C(3,:)=[zeros(1, 7*s-3) ones(1,3*s-2) zeros(1,n-(10*s-5))];      % longitudinal rod #3
S.C(4,:)=[zeros(1,10*s-5) ones(1,3*s-1) zeros(1,n-(13*s-6))];      % longitudinal rod #4
S.C(5,:)=[zeros(1,13*s-6) ones(1,3*s-1) zeros(1,n-(16*s-7))]; m=5; % longitudinal rod #5

for i=1:s, S.C(m+1:m+8,:)=zeros(8,n); k=3*(i-1);     % top double-tetrahedra
  S.C(m+1,i)=1;     S.C(m+1,4*s  +k)=1;
  S.C(m+2,i)=1;     S.C(m+2,7*s-2+k)=1;
  S.C(m+3,i)=1;     S.C(m+3,s+1  +k)=1;
  S.C(m+4,i)=1;     S.C(m+4,s+2  +k)=1;
  S.C(m+5,s+1+k)=1; S.C(m+5,4*s  +k)=1;
  S.C(m+6,s+2+k)=1; S.C(m+6,4*s  +k)=1;
  S.C(m+7,s+1+k)=1; S.C(m+7,7*s-2+k)=1;
  S.C(m+8,s+2+k)=1; S.C(m+8,7*s-2+k)=1; m=m+8;
end

for i=1:s, S.C(m+1:m+5,:)=zeros(5,n); k=3*(i-1);     % + side lower tetrahedra
  S.C(m+1,q+i)=1;      S.C(m+1,4*s  +k)=1;
  S.C(m+2,q+i)=1;      S.C(m+2,10*s-4+k)=1;
  S.C(m+3,q+i)=1;      S.C(m+3,10*s-3+k)=1;
  S.C(m+4,10*s-4+k)=1; S.C(m+4,4*s  +k)=1;
  S.C(m+5,10*s-3+k)=1; S.C(m+5,4*s  +k)=1; m=m+5;
end

for i=1:s, S.C(m+1:m+5,:)=zeros(5,n); k=3*(i-1);     % - side lower tetrahedra
  S.C(m+1,q+s+i)=1;    S.C(m+1, 7*s-2+k)=1;
  S.C(m+2,q+s+i)=1;    S.C(m+2,13*s-5+k)=1;
  S.C(m+3,q+s+i)=1;    S.C(m+3,13*s-4+k)=1;
  S.C(m+4,13*s-5+k)=1; S.C(m+4, 7*s-2+k)=1;
  S.C(m+5,13*s-4+k)=1; S.C(m+5, 7*s-2+k)=1; m=m+5;
end

for i=1:s-1, S.C(m+1:m+5,:)=zeros(5,n); k=3*(i-1);   % + side inverted tetrahedra
  S.C(m+1,s+3+k)=1;   S.C(m+1,10*s-2+k)=1;
  S.C(m+2,s+3+k)=1;   S.C(m+2, 4*s+1+k)=1;
  S.C(m+3,s+3+k)=1;   S.C(m+3, 4*s+2+k)=1;
  S.C(m+4,4*s+1+k)=1; S.C(m+4,10*s-2+k)=1;
  S.C(m+5,4*s+2+k)=1; S.C(m+5,10*s-2+k)=1; m=m+5;
end

for i=1:s-1, S.C(m+1:m+5,:)=zeros(5,n); k=3*(i-1);   % - side inverted tetrahedra
  S.C(m+1,s+3+k)=1;   S.C(m+1,13*s-3+k)=1;
  S.C(m+2,s+3+k)=1;   S.C(m+2, 7*s-1+k)=1;
  S.C(m+3,s+3+k)=1;   S.C(m+3, 7*s  +k)=1;
  S.C(m+4,7*s-1+k)=1; S.C(m+4,13*s-3+k)=1;
  S.C(m+5,7*s  +k)=1; S.C(m+5,13*s-3+k)=1; m=m+5;
end, m

L.U=zeros(3,q); L.U(2,7*s-2+(3*((round((s+1)/2))-1)))=1;

tic, [A,b,S,L]=RR_Structure_Analyze(S,L); toc, disp('Set up complete')
tic, x=pinv(A)*b; toc, disp('Forces and moments solved')    
figure(1); RR_Structure_Plot(S,L,x); error=norm(A*x-b), view(15.4, 11.4)

for i=1:s, k=3*(i-1);       % Now, plot the patches between the members patches
  for j=1:6
    switch j
      case 1, a=i; b=s+1+k; r=4*s+k;            % top double-tetrahedra
      case 2, a=i; b=s+1+k; r=7*s-2+k;
      case 3, a=i; b=s+2+k; r=4*s+k;
      case 4, a=i; b=s+2+k; r=7*s-2+k;
      case 5, a=4*s+k;   b=s+1+k; r=s+2+k;
      case 6, a=7*s-2+k; b=s+1+k; r=s+2+k;
    end
    fill3([N(1,a) N(1,b) N(1,r)],[N(2,a) N(2,b) N(2,r)],[N(3,a) N(3,b) N(3,r)],'w')
  end
  for j=1:4
    switch j
      case 1, a=q+i;   b=4*s+k;    c=10*s-4+k;  % + side lower tetrahedra
      case 2, a=q+i;   b=4*s+k;    c=10*s-3+k;  
      case 3, a=q+i;   b=10*s-4+k; c=10*s-3+k;
      case 4, a=4*s+k; b=10*s-4+k; c=10*s-3+k;
    end
    fill3([N(1,a) N(1,b) N(1,c)],[N(2,a) N(2,b) N(2,c)],[N(3,a) N(3,b) N(3,c)],'w')
  end
  for j=1:4
    switch j
      case 1, a=q+s+i;   b=7*s-2+k;  c=13*s-5+k;  % - side lower tetrahedra
      case 2, a=q+s+i;   b=7*s-2+k;  c=13*s-4+k;  
      case 3, a=q+s+i;   b=13*s-5+k; c=13*s-4+k;
      case 4, a=7*s-2+k; b=13*s-5+k; c=13*s-4+k;
    end
    fill3([N(1,a) N(1,b) N(1,c)],[N(2,a) N(2,b) N(2,c)],[N(3,a) N(3,b) N(3,c)],'w')
  end
end
for i=1:s-1, k=3*(i-1);
  for j=1:4
    switch j
      case 1, a=s+3+k;    b=10*s-2+k; c=4*s+1+k;  % + side inverted tetrahedra
      case 2, a=s+3+k;    b=10*s-2+k; c=4*s+2+k;  
      case 3, a=s+3+k;    b=4*s+1+k;  c=4*s+2+k;
      case 4, a=10*s-2+k; b=4*s+1+k;  c=4*s+2+k;
    end
    fill3([N(1,a) N(1,b) N(1,c)],[N(2,a) N(2,b) N(2,c)],[N(3,a) N(3,b) N(3,c)],[.87 .88 .89])
  end
  for j=1:4
    switch j
      case 1, a=s+3+k;    b=13*s-3+k; c=7*s-1+k;  % - side inverted tetrahedra
      case 2, a=s+3+k;    b=13*s-3+k; c=7*s  +k;  
      case 3, a=s+3+k;    b=7*s-1+k;  c=7*s  +k;
      case 4, a=13*s-3+k; b=7*s-1+k;  c=7*s  +k;
    end
    fill3([N(1,a) N(1,b) N(1,c)],[N(2,a) N(2,b) N(2,c)],[N(3,a) N(3,b) N(3,c)],[.87 .88 .89])
  end
  for j=1:8
    switch j
      case 1, a=s+2+k;    b=s+3+k;    c=4*s+1+k; d=4*s  +k; % slits (yellow)
      case 2, a=s+3+k;    b=s+4+k;    c=4*s+3+k; d=4*s+2+k;
      case 3, a=10*s-3+k; b=10*s-2+k; c=4*s+1+k; d=4*s  +k;
      case 4, a=10*s-2+k; b=10*s-1+k; c=4*s+3+k; d=4*s+2+k;
      case 5, a=s+2+k;    b=s+3+k;    c=7*s-1+k; d=7*s-2+k;
      case 6, a=s+3+k;    b=s+4+k;    c=7*s+1+k; d=7*s  +k;
      case 7, a=13*s-4+k; b=13*s-3+k; c=7*s-1+k; d=7*s-2+k;
      case 8, a=13*s-3+k; b=13*s-2+k; c=7*s+1+k; d=7*s  +k;
    end
    fill3([N(1,a) N(1,b) N(1,c) N(1,d)],[N(2,a) N(2,b) N(2,c) N(2,d)], ...
          [N(3,a) N(3,b) N(3,c) N(3,d)],'y')
  end
end
view(-43.37,18.05), axis off
print -vector -depsc USAFA_full.eps
