% script <a href="matlab:NR_Random_Eigenvalue_Test">NR_Random_Eigenvalue_Test</a>
% This sample script finds the eigenvalues and eigenvectors of a few randomly-generated matrices
% constructed with special structure.  This sample script uses Matlab's built-in commands
% <a href="matlab:doc eig">eig</a> (lower case) and <a href="matlab:doc inv">inv</a>.
% NR develops, from first principles, alternatives to matlab's built-in commands, such as
% <a href="matlab:help NR_Eig">NR_Eig</a> and <a href="matlab:help NR_Inv">NR_Inv</a> (mixed case).
% Numerical Renaissance codebase, Appendix A, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

clear, R = randn(4), [S,Lambda] = eig(R), S_times_Sprime=S*S'
disp('As R has random real entries, it may have real or complex-conjugate pairs of eigenvalues,')
disp('(appearing on main diagonal of Lambda).  Eigenvectors are (almost always) NOT orthogonal')
fprintf('Press return to continue\n\n'), pause
R_plus_Rprime = R+R',  [S,Lambda] = eig(R_plus_Rprime), S_times_Sprime=S*S'
disp('Notice that R+R'' is symmetric, with real eigenvalues.  Eigenvectors are orthogonal.')
fprintf('Press return to continue\n\n'), pause
R_minus_Rprime = R-R', [S,Lambda] = eig(R_minus_Rprime), S_times_Sprime=S*S'
disp('The matrix R-R'' is skew-symmetric, with pure imaginary eigenvalues.  Eigenvectors are orthogonal.')
fprintf('Press return to continue\n\n'), pause
Rprime_times_R = R'*R, [S,Lambda] = eig(Rprime_times_R), S_times_Sprime=S*S'
disp('This matrix R''*R is symmetric, with real POSITIVE eigenvalues.  Eigenvectors are orthogonal.')
fprintf('Press return to continue\n\n'), pause
R_times_Rprime = R*R', [S,Lambda] = eig(R_times_Rprime), S_times_Sprime=S*S'
disp('R*R'' has the same eigenvalues as R''*R, but different (orthogonal) eigenvectors.')
fprintf('Press return to continue\n\n'), pause
S = rand(4);  Lambda = diag([1 2 3 4]); A = S * Lambda * inv(S),  eigenvalues_of_A = eig(A)
disp('You can also create a matrix with desired eigenvalues (say, 1, 2, 3, 4)')
disp('from A=S Lambda inv(S) for any invertible S.'), disp(' ')
% end script NR_Random_Eigenvalue_Test
