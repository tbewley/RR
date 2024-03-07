% script <a href="matlab:RC_SS2TFTest">RC_SS2TFTest</a>
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.1.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

n=4; ni=2; no=3; A=randn(n); B=randn(n,ni); C=randn(no,n); D=randn(no,ni);
disp('Initial continuous-time system {A,B,C,D}:'), RC_ShowSys(A,B,C,D); disp(' ')

disp('Reduce to a SISO problem, and compare with Matlab''s built-in function.')
[b_RC_SISO,a_RC]        =RC_SS2TF(A,B(:,1),C(1,:),D(1,1)), b_size_SISO=size(b_RC_SISO)
[b_Matlab_SISO,a_Matlab]=ss2tf(A,B(:,1),C(1,:),D(1,1)), disp(' '), pause

disp('Reduce to a SIMO problem, and compare with Matlab''s built-in function.')
[b_RC_SIMO,a_RC]        =RC_SS2TF(A,B(:,1),C,D(:,1)), b_size_SIMO=size(b_RC_SIMO)
[b_Matlab_SIMO,a_Matlab]=ss2tf(A,B(:,1),C,D(:,1)), disp(' '), pause;

disp('Reduce to a MISO problem, which Matlab''s built-in functions can''t handle.')
[b_RC_MISO,a_RC]=RC_SS2TF(A,B,C(1,:),D(1,:));  b_size_MISO=size(b_RC_MISO)
for j=1:b_size_MISO(2), disp(sprintf('b_RC_MISO(:,%d,:)',j))
  for i=1:b_size_MISO(1), disp(reshape(b_RC_MISO(i,j,:),1,b_size_MISO(3))), end
end, a_RC, disp(' '), pause

disp('Test the full MIMO problem, which Matlab''s built-in functions can''t handle.')
[b_RC_MIMO,a_RC]=RC_SS2TF(A,B,C,D);           b_size_MIMO=size(b_RC_MIMO)
for j=1:b_size_MIMO(2), disp(sprintf('b_RC_MIMO(:,%d,:)',j))
  for i=1:b_size_MIMO(1), disp(reshape(b_RC_MIMO(i,j,:),1,b_size_MIMO(3))), end
end, a_RC

disp(' '); disp('Next <a href="matlab:help RCchap20">RCchap20</a> demo: <a href="matlab:RC_MaxEnergyGrowthTest">RC_MaxEnergyGrowthTest</a>'), disp(' ')
% end script RC_SS2TFTest
