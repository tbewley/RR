format short
A=[1 0 0 s 0 -s 0; 0 1 0 -c -c -c -c; 0 0 1 0 s 0 -s; ...
   L 0 0 0 0  0 0; 0 0 0  0  0  0  0; 0 0 L 0 0 0  0]
w=100, b=[0; w; 0; 0; 0; 0]
rank(A), null(A), x=pinv(A)*b
syms T1, n1=[0; 2*c*T1; 0; T1; 0; T1; 0]; A*n1
syms T2, n2=[0; 2*c*T2; 0; 0; T2; 0; T2]; A*n2
