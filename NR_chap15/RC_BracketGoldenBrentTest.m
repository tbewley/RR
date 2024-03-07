% script BracketGoldenBrentTest                      % Numerical Renaissance Codebase 1.0
clear; figure(1); clf; hold on; 
AA=0; AB=0.1; JA=ComputeJ(AA,1);
disp('Bracket...'); [AA,AB,AC,JA,JB,JC] = Bracket(AA,AB,JA,0,1,1), pause;
disp('Golden... '); [A,J] = Golden(AA,AB,AC,JA,JB,JC,0.0001,0,1,2), pause;
disp('InvQuad...'); [A,J] = InvQuad(AA,AB,AC,JA,JB,JC,0.0001,0,1,3), pause;
disp('Brent...  '); [A,J] = Brent(AA,AB,AC,JA,JB,JC,0.0001,0,1,4)
