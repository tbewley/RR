% script <a href="matlab:RC_SSTransformTest">RC_SSTransformTest</a>
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.1.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

n=4; ni=1; no=1; A=randn(n); B=randn(n,ni); C=randn(no,n); D=randn(no,ni);
disp('Initial state-space form:'), RC_ShowSys(A,B,C,D)
disp('RC_Eigenvalues of A'); disp(RC_Eig(A,'r')), R=rand(n);
[A1,B1,C1]=RC_SSTransform(A,B,C,R);
disp('Transformed state-space form, taking A=inv(R)*A*R, B=inv(R)*B, C=C*R for random R:')
RC_ShowSys(A1,B1,C1,D)
disp('RC_Eigenvalues of the transformed A'); disp(RC_Eig(A1,'r'))

disp(' '); disp('Next <a href="matlab:help RCchap20">RCchap20</a> demo: <a href="matlab:RC_MatrixExponentialTest">RC_MatrixExponentialTest</a>'), disp(' ')
% end script RC_SSTransformTest
