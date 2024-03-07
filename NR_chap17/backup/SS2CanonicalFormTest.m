% script <a href="matlab:RC_SS2CanonicalFormTest">RC_SS2CanonicalFormTest</a>
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, NRchap20.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

n=4; ni=1; no=1; Ao=randn(n); Bo=randn(n,ni); Co=randn(no,n); Do=randn(no,ni);
disp('Initial random SISO state-space form {Ao,Bo,Co,Do}:'), RC_ShowSys(Ao,Bo,Co,Do)

[A,B,C]=RC_SS2CanonicalForm(Ao,Bo,Co,'Controller');         RC_ShowSys(A,B,C,Do), pause
[A,B,C]=RC_SS2CanonicalForm(Ao,Bo,Co,'Reachability');       RC_ShowSys(A,B,C,Do), pause
[A,B,C]=RC_SS2CanonicalForm(Ao,Bo,Co,'DTControllability');  RC_ShowSys(A,B,C,Do), pause
[A,B,C]=RC_SS2CanonicalForm(Ao,Bo,Co,'Observer');           RC_ShowSys(A,B,C,Do), pause
[A,B,C]=RC_SS2CanonicalForm(Ao,Bo,Co,'Observability');      RC_ShowSys(A,B,C,Do), pause
[A,B,C]=RC_SS2CanonicalForm(Ao,Bo,Co,'DTConstructibility'); RC_ShowSys(A,B,C,Do), pause

N=2; n=4*N; disp(' '); disp('Initialize a random MIMO state-space form with sparsity:')
AO=[rand(N)  zeros(N) rand(N)  zeros(N);
    rand(N)  rand(N)  rand(N)  rand(N);
    zeros(N) zeros(N) rand(N)  zeros(N);
    zeros(N) zeros(N) rand(N)  rand(N)];
BO=[rand(N); rand(N); zeros(N); zeros(N)];
CO=[rand(N)  zeros(N) rand(N)   zeros(N)]; DO=rand(N); RC_ShowSys(AO,BO,CO,DO)
disp(' '), disp('... scramble this state-space form:')
R=rand(n); [Abar,Bbar,Cbar]=RC_SSTransform(AO,BO,CO,R); RC_ShowSys(Abar,Bbar,Cbar,DO)

disp(' '), disp('... and transform to reveal structure in four different ways:'); pause
[A,B,C,rc,rnc]=RC_SS2CanonicalForm(AO,BO,CO,'ControllabilityBlockStaircase');
RC_ShowSys(A,B,C,DO), pause;
[A,B,C,ro,rno]=RC_SS2CanonicalForm(AO,BO,CO,'ObservabilityBlockStaircase');
RC_ShowSys(A,B,C,DO), pause;

[A,B,C,rco,rcno,rnco,rncno]=RC_SS2CanonicalForm(Abar,Bbar,Cbar,'BlockKalman');
RC_ShowSys(A,B,C,DO), disp(' ')
EOco  =RC_Eig(AO(1:N,1:N),'r');             Eco  =RC_Eig(A(1:N,1:N),'r');
EOcno =RC_Eig(AO(N+1:2*N,N+1:2*N),'r');     Ecno =RC_Eig(A(N+1:2*N,N+1:2*N),'r');
EOnco =RC_Eig(AO(2*N+1:3*N,2*N+1:3*N),'r'); Enco =RC_Eig(A(2*N+1:3*N,2*N+1:3*N),'r');
EOncno=RC_Eig(AO(3*N+1:4*N,3*N+1:4*N),'r'); Encno=RC_Eig(A(3*N+1:4*N,3*N+1:4*N),'r');
disp(sprintf('controllable/observable           eigenvalues before: %.4g %.4g %.4g',EOco))
disp(sprintf('                                              after:  %.4g %.4g %.4g',Eco))
disp(sprintf('controllable/null-observable      eigenvalues before: %.4g %.4g %.4g',EOcno))
disp(sprintf('                                              after:  %.4g %.4g %.4g',Ecno))
disp(sprintf('null-controllable/observable      eigenvalues before: %.4g %.4g %.4g',EOnco))
disp(sprintf('                                              after:  %.4g %.4g %.4g',Enco))
disp(sprintf('null-controllable/null-observable eigenvalues before: %.4g %.4g %.4g',EOncno))
disp(sprintf('                                              after:  %.4g %.4g %.4g',Encno))
pause;

[A,B,C,r]=RC_SS2CanonicalForm(Abar,Bbar,Cbar,'Minimal'); RC_ShowSys(A,B,C,DO), disp(' ')
E=RC_Eig(A,'r'); disp(sprintf('RC_Eigenvalues of minimal realization: %.4g %.4g %.4g',E))

disp(' '); disp('Next <a href="matlab:help RCchap20">RCchap20</a> demo: <a href="matlab:RC_BalancedFormTest">RC_BalancedFormTest</a>'), disp(' ')
% end script RC_SS2CanonicalFormTest
