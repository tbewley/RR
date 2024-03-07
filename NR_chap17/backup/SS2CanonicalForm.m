function [A,B,C,r1,r2,r3,r4]=RC_SS2CanonicalForm(A,B,C,FORM)
% function [A,B,C,r1,r2,r3,r4]=RC_SS2CanonicalForm(A,B,C,FORM)
% Convert a general state-space model to one of a variety of canonical forms.
%
% If FORM = 'Controller', 'Reachability', 'DTControllability', 'Observer', 'Observability',
% or 'DTConstructibility', the input system must be SISO, and r1 through r4 are undefined.
%
% FORM='ControllabilityBlockStaircase' is given by ----->     A_c  A_1,2 | B_c
% In this form, {A_c;B_c;C_c} is controllable,                 0   A_nc  |  0
% {A_nc;0;C_nc} is null controllable, and                     ----------------
% r1=r_c, r2=r_nc are the ranks of the diagonal blocks.       C_c  C_nc  |  0
%
% FORM='ObservabilityBlockStaircase' is given by ------->    A_o    0   | B_o
% In this form, {A_o;B_o;C_o} is observable,                 A_2,1 A_no | B_no
% {A_nc;0;C_nc} is null observable, and                      -----------------
% r1=r_o, r2=r_no are the ranks of the diagonal blocks.      C_o    0   |  0
%
% FORM='BlockKalman' is given by ------------>     A_c,o    0     A_1,3     0     | B_c,o
% In this form, {A_c,o;B_c,o;C_c,o} is             A_2,1  A_c,no  A_2,3   A_2,4   | B_c,no
% both controllable and observable,                  0      0     A_nc,o    0     |   0
% the remaining modes are either                     0      0     A_4,3   A_nc,no |   0
% null observable, null controllable, or both,     ---------------------------------------
% and r1=r_c,o, r2=r_c,no, r3=r_nc,o, r4=r_nc,no   C_c,o    0     C_nc,o    0     |   0
% are the ranks of the diagonal blocks.
%
% FORM='Minimal' is given by {A_c,o;B_c,o;C_c,o} from the BlockKalman form, with r1=r_c,o.
%
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, NRchap20.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help RC_SS2CanonicalFormTest">RC_SS2CanonicalFormTest</a>.

disp(' '), r1=0; r2=0; r3=0; r4=0; [n,ni]=size(B); [no,n]=size(C);
forms={'Controller','Reachability', 'DTControllability', ...
       'Observer',  'Observability','DTConstructibility'};
if (ismember(FORM,forms) & ni*no>1), disp('Error: invalid case.'), return, end, FORM
switch FORM         % Compute the transformation matrix
 case 'Reachability'
   Q=RC_CtrbMatrix(A,B);
 case 'Controller'
   Q=RC_CtrbMatrix(A,B); [A,B,C]=RC_SSTransform(A,B,C,Q); a=-A(:,n)'; Q=R1(a,n)';
 case 'DTControllability'
   Q=RC_CtrbMatrix(A,B); [A,B,C]=RC_SSTransform(A,B,C,Q); a=-A(:,n)'; Q=-R1(a,n)'*Inv(R2(a,n));
 case 'Observability'
   Q=Inv(RC_ObsvMatrix(A,C));
 case 'Observer'
   Q=Inv(RC_ObsvMatrix(A,C)); [A,B,C]=RC_SSTransform(A,B,C,Q); a=-A(n,:); Q=Inv(R1(a,n));
 case 'DTConstructibility'
   Q=Inv(RC_ObsvMatrix(A,C)); [A,B,C]=RC_SSTransform(A,B,C,Q); a=-A(n,:); Q=-Inv(R1(a,n))*R2(a,n);
 case 'ControllabilityBlockStaircase'
   [Q,R,pi,r1]=QRmgs(RC_CtrbMatrix(A,B));  r2=n-r1;
 case 'ObservabilityBlockStaircase'     
   [Q,R,pi,r1]=QRmgs(RC_ObsvMatrix(A,C)'); r2=n-r1;
 case {'BlockKalman','Minimal'}
   % First, find orthogonal bases for the controllable/null-controllable subspaces,
   % and for the observable/null-observable subspaces.
   [Qcnc,R,pi,rc]=QRmgs(RC_CtrbMatrix(A,B));  rnc=n-rc; Qc=Qcnc(:,1:rc); Qnc=Qcnc(:,rc+1:n);
   [Qono,R,pi,ro]=QRmgs(RC_ObsvMatrix(A,C)'); rno=n-ro; Qo=Qono(:,1:ro); Qno=Qono(:,ro+1:n);
   % Find an orthogonal basis for the modes that are neither null-controllable nor
   % observable (that is, for the modes that are both controllable and null-observable).
   [Q,R,pi,r]=QRmgs([Qnc Qo]);             rcno =n-r;      Qcno =Q(:,r+1:n);
   % Find a basis for the remaining controllable modes, which are observable.
   [Q,R,pi,r]=QRmgs([Qcno Qc], rcno);      rco  =rc-rcno;  Qco  =Q(:,rcno+1:rc);
   % Find a basis for the remaining null-observable modes, which are null-controllable.
   [Q,R,pi,r]=QRmgs([Qcno Qno],rcno);      rncno=rno-rcno; Qncno=Q(:,rcno+1:rno);
   % Find a basis for the remaining modes, which are null-controllable and observable.
   [Q,R,pi,r]=QRmgs([Qco Qcno Qncno]);     rnco =n-r;      Qnco =Q(:,r+1:n);
   % Assemble these four bases into a transformation matrix Q.
   Q=[Qco Qcno Qnco Qncno]; r1=rco; r2=rcno; r3=rnco; r4=rncno;
 otherwise, disp('Error: invalid case.'), return
end
[A,B,C]=RC_SSTransform(A,B,C,Q);  % Perform final transform of the system
if strcmp(FORM,'Minimal'), A=A(1:r1,1:r1); B=B(1:r1,:); C=C(:,1:r1); end
end % function RC_SS2CanonicalForm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [R]=R1(a,n)
for row=1:n; R(row,:)=[a(n-row+2:n) 1 zeros(1,n-row)]; end
end % function R1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [R]=R2(a,n)
for row=1:n; R(row,:)=[a(n-row+1:-1:1) zeros(1,row-1)]; end
end % function R2
