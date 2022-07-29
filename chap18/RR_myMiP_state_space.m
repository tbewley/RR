% Initialize all constants.
clear all; mw=0.027; r=0.034; mb=0.180; l=0.0477; G=35.5; g=9.8;
Ib=2.63e-4; Im=3.6e-8; sbar=0.003; omega_f=1760; k=sbar/omega_f;
Iw=2*(mw*r^2/2 + G^2*Im);
c1=Iw+(mw+mb)*r^2; c2=mb*r*l;     c3=2*G^2*k;
c4=2*G*sbar;       c5=Ib+mb*l^2;  c6=mb*g*l;
% Now set up equations of motion derived from mechanical and electrical
% properties using the state vector x=(phi theta phidot thetadot)^T
Ebar=[1 0 0 0; 0 1 0 0; 0 0  c1 c2; 0  0 c2  c5];
Abar=[0 0 1 0; 0 0 0 1; 0 0 -c3 c3; 0 c6 c3 -c3];
Bbar=[0; 0; c4; -c4]; A=Ebar\Abar; lambda=eig(A); B=Ebar\Bbar;
C=[0 0 1 -1; 0 1 0 0]; 
Con=[B  A*B  A*A*B  A*A*A*B]; rank_Con=rank(Con)
Obs=[C; C*A; C*A*A; C*A*A*A]; rank_Obs=rank(Obs)
[U,Sig,V]=svd(Obs); format short; sigma_Obs=diag(Sig), pause, disp(' ')

disp('Problem 1 (look at A, B, C, and eigenvalues)')
A, B, C, lambda
disp('The system has a pure integrator, to determine phi from phidot, plus')
disp('one fast stable mode, and a pair of slow modes (one stable, one unstable).')
disp('[MAE144 grads: this separation of timescales renders this system well suited for SLC!]')
disp('Note the column of zeros in A: the evolution of x(1)=phi is completely decoupled')
disp('from the evolution of the rest of the system, and may be eliminated.')
pause, disp(' ')

disp('Problem 2a (eliminate the decoupled state x(1)=phi from the four-state model)')
Ebar=Ebar(2:4,2:4); Abar=Abar(2:4,2:4); Bbar=Bbar(2:4);
A=Ebar\Abar, B=Ebar\Bbar, C=C(:,2:4), lambda=eig(A)
disp('Note the nonzero eigenvalues remain unchanged.'), pause, disp(' ')

disp('Problem 2b (The reduced system, with 2 measurements, is controllable/observable)')
Con=[B  A*B  A*A*B]; rank_Con=rank(Con)
Obs=[C; C*A; C*A*A]; rank_Obs=rank(Obs)
[U,Sig,V]=svd(Obs); sigma_min=Sig(3,3)
disp('The distance sigma_min is from zero quantifies, in effect, how "close" the')
disp('observability matrix is to being singular.'), pause, disp(' ')

disp('Problem 2c (including a 3rd measurement, of thetadot, increases sigma_min)')
C=[0 1 -1; 1 0 0; 0 0 1]
Obs=[C; C*A; C*A*A]; rank_Obs=rank(Obs)
[U,Sig,V]=svd(Obs); sigma_min=Sig(3,3), pause, disp(' ')

disp('Problem 2d (using only 1 measurement, of theta, makes sigma_min much smaller)')
C=[1 0 0]
Obs=[C; C*A; C*A*A]; rank_Obs=rank(Obs)
[U,Sig,V]=svd(Obs); sigma_min=Sig(3,3), pause, disp(' ')

disp('Problem 2e (using 1 measurement, of omega_w, somewhat improves sigma_min)')
C=[0 1 -1]
Obs=[C; C*A; C*A*A]; rank_Obs=rank(Obs)
[U,Sig,V]=svd(Obs); sigma_min=Sig(3,3), pause, disp(' ')

disp('Problem 2f')
disp('We prefer using all 3 measurements, which gives largest sigma_min,')
disp('so the observability matrix is the "farthest" from being singular.')
disp('If only one measurement is possible, we prefer using omega_w.')
pause, disp(' '), format long

disp('Problem 3a (transformation to reachability canonical form)')
Rre=Con; Are=inv(Rre)*A*Rre, Bre=inv(Rre)*B, Cre=C*Rre
disp('Note that Are is in right companion form and Bre=[1;0;0].'), pause, disp(' ')

disp('Problem 3b (transformation to controller canonical form)')
a0=-Are(1,3); a1=-Are(2,3); a2=-Are(3,3); R1=[1 0 0; a2 1 0; a1 a2 1];
Rc=R1'; Ac=inv(Rc)*Are*Rc, Bc=inv(Rc)*Bre, Cc=Cre*Rc
disp('Note that Ac is in top companion form and Bc=[1;0;0].'), pause, disp(' ')

disp('Problem 3c (pole placement for controller problem)')
lambda_bar(1,1)=lambda(1); lambda_bar(2,1)=-lambda(2); lambda_bar(3,1)=lambda(3);
% controller gains given directly in last line of section 21.4.1 in NR:
Kc(1,1)=a2+lambda_bar(1)+lambda_bar(2)+lambda_bar(3);
Kc(1,2)=a1-( lambda_bar(1)*lambda_bar(2)...
            +lambda_bar(1)*lambda_bar(3)...
            +lambda_bar(2)*lambda_bar(3));
Kc(1,3)=a0+lambda_bar(1)*lambda_bar(2)*lambda_bar(3);
lambda_bar, lambda_c=eig(Ac+Bc*Kc)            % check answer: correct if equal.
K=Kc*inv(Rc)*inv(Rre); lambda=eig(A+B*K), K   % check answer: correct if equal.
pause, disp(' ')

disp('Problem 4a (transformation to observability canonical form)')
Rob=inv(Obs); Aob=inv(Rob)*A*Rob, Bob=inv(Rob)*B, Cob=C*Rob
disp('Note that Aob is in bottom companion form and Cob=[1 0 0].'), pause, disp(' ')

disp('Problem 4b (transformation to observer canonical form)')
Ro=inv(R1); Ao=inv(Ro)*Aob*Ro, Bo=inv(Ro)*Bob, Co=Cob*Ro
disp('Note that Ao is in left companion form and Co=[1 0 0].'), pause, disp(' ')

disp('Problem 4c (pole placement for observer problem)')
lambda_bar=3*lambda_bar;
% observer gains given directly in last line of section 21.4.2 in NR:
Lo(1,1)=a2+lambda_bar(1)+lambda_bar(2)+lambda_bar(3);
Lo(2,1)=a1-( lambda_bar(1)*lambda_bar(2)...
            +lambda_bar(1)*lambda_bar(3)...
            +lambda_bar(2)*lambda_bar(3));
Lo(3,1)=a0+lambda_bar(1)*lambda_bar(2)*lambda_bar(3);
lambda_bar, lambda_o=eig(Ao+Lo*Co)    % check answer: correct if equal.
L=Rob*Ro*Lo; lambda=eig(A+L*C), L     % check answer: correct if equal.
pause, disp(' ')

disp('Problem 5a: Using a MIMO approach would facilitate the use of multiple measurements,')
disp('which would improve observability and thus lead to reduced estimation errors.'), disp(' ')
disp('Problem 5b: Pole placement accounts for eigenvalues but not eigenvectors, which can')
disp('lead to "hidden" mechanisms for substantial energy amplification (see Sec 21.2).')
disp('Energy-based methods coupled with statistical descriptions of disturbances (that is,')
disp('Optimal Control + Kalman Filtering) are thus much better tools for computing K and L.')