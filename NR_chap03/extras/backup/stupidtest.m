format compact;
A=[1 -1 0 0 0 0 0;
   1 -2 1 0 0 0 0;
   0 1 -2 1 0 0 0;
   0 0 1 -2 1 0 0;
   0 0 0 1 -2 1 0;
   0 0 0 0 1 -2 1;
   0 0 0 0 0 -1 1] 
b=[0; randn(1); randn(1); randn(1); randn(1); randn(1); 0];
i=sum(b(2:6))/5;
b(2:6)=b(2:6)-i
A1=A; A1(4,:)=[0 0 0 1 0 0 0];  A1
b1=b; b1(4)=0; b1
x1=A1\b1; x1
A1_x1_minus_b1=A1*x1-b1
A_x_minus_b=A*x1-b
