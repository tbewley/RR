% script <a href="matlab:RR_DAREtest">RR_DAREtest</a>
% Test <a href="matlab:help RR_RDE">RR_RDE</a>, <a href="matlab:help RR_DARE">RR_DARE</a>, & <a href="matlab:help RR_DAREdoubling">RR_DAREdoubling</a> with random F and random Q>0, S>0.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.5.4.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RR_CALEtest, RR_CAREtest, RR_DALEtest.  Depends on Inv, RR_RDEtest.

RR_RDEtest

disp('Now testing RR_DARE & RR_DAREdoubling with random F and random Q>0, S>0.')
G=Inv(F'); M=[F+S*G*Q, -S*G; -G*Q, G]; MInv=[G', G'*S; Q*G', F'+Q*G'*S];
check=norm(eye(2*n)-M*MInv)
Y=real(RR_DARE(F,S,Q,n)),      error_RR_DARE        =norm(F'*Y*Inv(eye(n)+S*Y)*F-Y+Q)
Z=RR_DAREdoubling(F,S,Q,n,10), error_RR_DAREdoubling=norm(F'*Z*Inv(eye(n)+S*Z)*F-Z+Q), disp(' ')

% end script RR_DAREtest
