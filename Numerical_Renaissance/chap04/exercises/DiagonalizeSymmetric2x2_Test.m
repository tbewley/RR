% script DiagonalizeSymmetric2x2_Test
A=randn(2); B=randn(2); A=A*A'-B*B'
[B,G] = DiagonalizeSymmetric2x2_atan(A), norm(A-G*B*G')
[B,G] = DiagonalizeSymmetric2x2_sqrt(A), norm(A-G*B*G')
% end script DiagonalizeSymmetric2x2_Test