% script <a href="matlab:RR_SS2CanonicalFormTest">RR_SS2CanonicalFormTest</a>
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, NRchap20.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

n=4; ni=1; no=1; Ao=randn(n); Bo=randn(n,ni); Co=randn(no,n); Do=randn(no,ni);
disp('Initial random SISO state-space form {Ao,Bo,Co,Do}:'), RR_ShowSys(Ao,Bo,Co,Do)

[A,B,C]=RR_SS2CanonicalForm(Ao,Bo,Co,'Controller');         RR_ShowSys(A,B,C,Do), pause
[A,B,C]=RR_SS2CanonicalForm(Ao,Bo,Co,'Reachability');       RR_ShowSys(A,B,C,Do), pause
[A,B,C]=RR_SS2CanonicalForm(Ao,Bo,Co,'DTControllability');  RR_ShowSys(A,B,C,Do), pause
[A,B,C]=RR_SS2CanonicalForm(Ao,Bo,Co,'Observer');           RR_ShowSys(A,B,C,Do), pause
[A,B,C]=RR_SS2CanonicalForm(Ao,Bo,Co,'Observability');      RR_ShowSys(A,B,C,Do), pause
[A,B,C]=RR_SS2CanonicalForm(Ao,Bo,Co,'DTConstructibility'); RR_ShowSys(A,B,C,Do), pause

N=2; n=4*N; disp(' '); disp('Initialize a random MIMO state-space form with sparsity:')
AO=[rand(N)  zeros(N) rand(N)  zeros(N);
    rand(N)  rand(N)  rand(N)  rand(N);
    zeros(N) zeros(N) rand(N)  zeros(N);
    zeros(N) zeros(N) rand(N)  rand(N)];
BO=[rand(N); rand(N); zeros(N); zeros(N)];
CO=[rand(N)  zeros(N) rand(N)   zeros(N)]; DO=rand(N); RR_ShowSys(AO,BO,CO,DO)
disp(' '), disp('... scramble this state-space form:')
R=rand(n); [Abar,Bbar,Cbar]=RR_SSTransform(AO,BO,CO,R); RR_ShowSys(Abar,Bbar,Cbar,DO)

disp(' '), disp('... and transform to reveal structure in four different ways:'); pause
[A,B,C,rc,rnc]=RR_SS2CanonicalForm(AO,BO,CO,'ControllabilityBlockStaircase');
RR_ShowSys(A,B,C,DO), pause;
[A,B,C,ro,rno]=RR_SS2CanonicalForm(AO,BO,CO,'ObservabilityBlockStaircase');
RR_ShowSys(A,B,C,DO), pause;

[A,B,C,rco,rcno,rnco,rncno]=RR_SS2CanonicalForm(Abar,Bbar,Cbar,'BlockKalman');
RR_ShowSys(A,B,C,DO), disp(' ')
EOco  =RR_Eig(AO(1:N,1:N),'r');             Eco  =RR_Eig(A(1:N,1:N),'r');
EOcno =RR_Eig(AO(N+1:2*N,N+1:2*N),'r');     Ecno =RR_Eig(A(N+1:2*N,N+1:2*N),'r');
EOnco =RR_Eig(AO(2*N+1:3*N,2*N+1:3*N),'r'); Enco =RR_Eig(A(2*N+1:3*N,2*N+1:3*N),'r');
EOncno=RR_Eig(AO(3*N+1:4*N,3*N+1:4*N),'r'); Encno=RR_Eig(A(3*N+1:4*N,3*N+1:4*N),'r');
disp(sprintf('controllable/observable           eigenvalues before: %.4g %.4g %.4g',EOco))
disp(sprintf('                                              after:  %.4g %.4g %.4g',Eco))
disp(sprintf('controllable/null-observable      eigenvalues before: %.4g %.4g %.4g',EOcno))
disp(sprintf('                                              after:  %.4g %.4g %.4g',Ecno))
disp(sprintf('null-controllable/observable      eigenvalues before: %.4g %.4g %.4g',EOnco))
disp(sprintf('                                              after:  %.4g %.4g %.4g',Enco))
disp(sprintf('null-controllable/null-observable eigenvalues before: %.4g %.4g %.4g',EOncno))
disp(sprintf('                                              after:  %.4g %.4g %.4g',Encno))
pause;

[A,B,C,r]=RR_SS2CanonicalForm(Abar,Bbar,Cbar,'Minimal'); RR_ShowSys(A,B,C,DO), disp(' ')
E=RR_Eig(A,'r'); disp(sprintf('RR_Eigenvalues of minimal realization: %.4g %.4g %.4g',E))

disp(' '); disp('Next <a href="matlab:help RCchap20">RCchap20</a> demo: <a href="matlab:RR_BalancedFormTest">RR_BalancedFormTest</a>'), disp(' ')
% end script RR_SS2CanonicalFormTest
