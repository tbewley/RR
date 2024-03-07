% script <a href="matlab:RC_DAREtest">RC_DAREtest</a>
% Test <a href="matlab:help RC_RDE">RC_RDE</a>, <a href="matlab:help RC_DARE">RC_DARE</a>, & <a href="matlab:help RC_DAREdoubling">RC_DAREdoubling</a> with random F and random Q>0, S>0.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.5.4.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_CALEtest, RC_CAREtest, RC_DALEtest.  Depends on Inv, RC_RDEtest.

RC_RDEtest

disp('Now testing RC_DARE & RC_DAREdoubling with random F and random Q>0, S>0.')
G=Inv(F'); M=[F+S*G*Q, -S*G; -G*Q, G]; MInv=[G', G'*S; Q*G', F'+Q*G'*S];
check=norm(eye(2*n)-M*MInv)
Y=real(RC_DARE(F,S,Q,n)),      error_RC_DARE        =norm(F'*Y*Inv(eye(n)+S*Y)*F-Y+Q)
Z=RC_DAREdoubling(F,S,Q,n,10), error_RC_DAREdoubling=norm(F'*Z*Inv(eye(n)+S*Z)*F-Z+Q), disp(' ')

% end script RC_DAREtest
