% script RR_rotate_test
% Test RR_rotate_compute & RR_rotate on a random matrix.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap01
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

disp('These two tests take i=2 and k=3 and which=B (i.e., it computes G^H * X * G),')
disp('so they only modify the 2nd and 3rd rows, and 2nd and 3rd columns, of A.')
disp('The rotations are designed to drive the (3,1) elements of A to zero.')
disp('They preserve the symmetric/Hermitian structure, and eigenvalues, of A.')
for c=0:1
  switch i
    case 0, disp('Testing RR_rotate on a real, random, symmetrix matrix.')
    case 1, disp('Testing RR_rotate on a complex, random, Hermitian matrix.')
  end  	
  R=randn(4)+c*sqrt(-1)*randn(4); A=R*R'
  [c,s]=RR_rotate_compute(A(2,1),A(3,1));
  [A_rotated]=RR_rotate(A,c,s,2,3,1,4,'B')
  eig_of_A        =sort(eig(A),        'ComparisonMethod','real')'
  eig_of_A_rotated=sort(eig(A_rotated),'ComparisonMethod','real')'
end