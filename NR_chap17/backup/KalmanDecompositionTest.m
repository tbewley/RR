% script <a href="matlab:RC_KalmanDecompositionTest">RC_KalmanDecompositionTest</a>
% Test <a href="matlab:help RC_KalmanDecomposition">RC_KalmanDecomposition</a> on a random state space form.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.6.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

clear; N=2; disp(' '); disp('Start with a random initial state-space form with sparsity:')
AO=[rand(N)  zeros(N) rand(N)  zeros(N);
   rand(N)  rand(N)  rand(N)  rand(N);
   zeros(N) zeros(N) rand(N)  zeros(N);
   zeros(N) zeros(N) rand(N)  rand(N)]
BO=[rand(N); rand(N); zeros(N); zeros(N)]
CO=[rand(N)  zeros(N) rand(N)   zeros(N)]
disp('Now, scramble this state-space form:')
R=rand(N*4); Ri=inv(R); Abar=Ri*AO*R, Bbar=Ri*BO, Cbar=CO*R
disp('Finally, reorder to recover the original sparsity pattern:')
[A,B,C] = RC_KalmanDecomposition(Abar,Bbar,Cbar,N*4)
EOco=eig(AO(1:N,1:N));               Eco=eig(A(1:N,1:N));
EOcno=eig(AO(N+1:2*N,N+1:2*N));      Ecno=eig(A(N+1:2*N,N+1:2*N));
EOnco=eig(AO(2*N+1:3*N,2*N+1:3*N));  Enco=eig(A(2*N+1:3*N,2*N+1:3*N));
EOncno=eig(AO(3*N+1:4*N,3*N+1:4*N)); Encno=eig(A(3*N+1:4*N,3*N+1:4*N));
disp(sprintf('controllable/observable           evals before: %.4g %.4g %.4g',EOco))
disp(sprintf('                                        after:  %.4g %.4g %.4g',Eco))
disp(sprintf('controllable/null-observable      evals before: %.4g %.4g %.4g',EOcno))
disp(sprintf('                                        after:  %.4g %.4g %.4g',Ecno))
disp(sprintf('null-controllable/observable      evals before: %.4g %.4g %.4g',EOnco))
disp(sprintf('                                        after:  %.4g %.4g %.4g',Enco))
disp(sprintf('null-controllable/null-observable evals before: %.4g %.4g %.4g',EOncno))
disp(sprintf('                                        after:  %.4g %.4g %.4g',Encno))

% end script RC_KalmanDecompositionTest