% Definitition of the geometry of the USAFA chapel (measurements in feet - sorry...)
clear; L=75;       % length of long diagonal of tetrahedron
d=21;              % depth of tetrahedron
w=(17.5-2*t)/2;    % half width of tetrahedron
phi=atan(d/L);     % angle of tetrahedron in the y-z plane
H=sqrt(L^2-d^2);   % vertical height of tetrahedron 
h2=(L/2)/cos(phi); % height of upper part of tetrahedron (note: h1+h2=H, h2>h1)
h1=H-h2;           % height of lower part of tetrahedron

P(:,1)=[ 0; 2*d; 0];
P(:,2)=[+w;  d; h1];
P(:,3)=[-w;  d; h1];
P(:,4)=[ 0;  d;  H]; p=4;

for i=1:5, Q(:,i   )=((6-i)/6)*P(:,1)+(i/6)*P(:,4); end
for i=1:2, Q(:,i+ 5)=((3-i)/3)*P(:,1)+(i/3)*P(:,2); end
for i=1:2, Q(:,i+ 7)=((3-i)/3)*P(:,1)+(i/3)*P(:,3); end
for i=1:2, Q(:,i+ 9)=((3-i)/3)*P(:,4)+(i/3)*P(:,2); end
for i=1:2, Q(:,i+11)=((3-i)/3)*P(:,4)+(i/3)*P(:,3); end, q=13;

C(1,14)=1; C(1,17)=1; C(1,1:4)=1;
C(2,14)=1; C(2,17)=1; C(2,1:4)=1;
C(3,14)=1; C(2,17)=1; C(2,1:4)=1;
C(4,14)=1; C(2,17)=1; C(2,1:4)=1;
C(5,14)=1; C(2,17)=1; C(2,1:4)=1;
C(6,14)=1; C(2,17)=1; C(2,1:4)=1;
C(7,14)=1; C(2,17)=1; C(2,1:4)=1;
C(8,14)=1; C(2,17)=1; C(2,1:4)=1;

U=zeros(3,q);
[A,b]=RR_Convert_Frame_to_Ax_eq_b(Q,C,U,P);
% x=pinv(A)*b;
x=zeros(size(A,1));
RR_Plot_Frame(Q,C,U,x,P)

