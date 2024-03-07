function [A,B,C,rco,rcno,rnco,rncno] = RC_KalmanDecomposition(A,B,C)
% function [A,B,C,rco,rcno,rnco,rncno] = RC_KalmanDecomposition(A,B,C)
% Compute the Kalman Decomposition:    A_c,o    0     A_1,3     0     | B_c,o
% (rco,rcno,rnco,rncno are the         A_2,1  A_c,no  A_2,3   A_2,4   | B_c,no
%  ranks of each diagonal block)         0      0     A_nc,o    0     |   0
%                                        0      0     A_4,3   A_nc,no |   0
%                                     -----------------------------------------
%                                      C_co     0     C_nc,o    0     |   0
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.6.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help RC_CtrbGrammianTest">RC_KalmanDecompositionTest</a>.

% First, find orthogonal bases for the controllable/null-controllable subspaces,
% and for the observable/null-observable subspaces.
n=length(A)
[Qcnc,R,pi,rc]=QRmgs(RC_CtrbMatrix(A,B));  rnc=n-rc; Qc=Qcnc(:,1:rc); Qnc=Qcnc(:,rc+1:n);
[Qono,R,pi,ro]=QRmgs(RC_ObsvMatrix(A,C)'); rno=n-ro; Qo=Qono(:,1:ro); Qno=Qono(:,ro+1:n);
% Find an orthogonal basis for the modes that are neither null-controllable nor observable
% (that is, for the modes that are both controllable and null-observable).
[Q,R,pi,r]=QRmgs([Qnc Qo]);             rcno =n-r;      Qcno =Q(:,r+1:n);
% Find a basis for the remaining controllable modes, which are observable.
[Q,R,pi,r]=QRmgs([Qcno Qc], rcno);      rco  =rc-rcno;  Qco  =Q(:,rcno+1:rc);
% Find a basis for the remaining null-observable modes, which are null-controllable.
[Q,R,pi,r]=QRmgs([Qcno Qno],rcno);      rncno=rno-rcno; Qncno=Q(:,rcno+1:rno);
% Find a basis for the remaining modes, which are null-controllable and observable.
[Q,R,pi,r]=QRmgs([Qco Qcno Qncno]);     rnco =n-r;      Qnco =Q(:,r+1:n);
% Assemble these four bases into a transformation matrix Q, and transform the system.
Q=[Qco Qcno Qnco Qncno]; Qi=inv(Q); A=Qi*A*Q; B=Qi*B; C=C*Q;
end % function RC_KalmanDecomposition