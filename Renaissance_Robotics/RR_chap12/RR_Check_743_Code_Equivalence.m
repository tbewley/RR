% script RR_Check_743_Code_Equivalence
% This code checks the equivalence between the cyclic and systematic
% forms of the [7,4,3] LBC Renaissance Robotics.
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chap12
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

disp('Cyclic form of the [7,4,3]_2 code:')
Hc=[1 0 1 1 1 0 0;
    0 1 0 1 1 1 0;
    0 0 1 0 1 1 1]
Vc=[1 0 0 0;
    1 1 0 0;
    0 1 1 0;
    1 0 1 1;
    0 1 0 1;
    0 0 1 0;
    0 0 0 1]

pause; disp('Define transformation matrices:')
R=[1 1 0;
   0 1 1;
   0 0 1]
Q=[0 0 1 0 0 0 0;
   1 0 0 0 0 0 0;
   0 0 0 1 0 0 0;
   0 1 0 0 0 0 0;
   0 0 0 0 1 0 0;
   0 0 0 0 0 1 0;
   0 0 0 0 0 0 1]
S=[0 0 1 0;
   1 0 1 0;
   1 0 1 1;
   1 1 0 1]

pause; disp('Calculate systematic form of the [7,4,3]_2 code:')
H = mod(R' * Hc * Q,2)
V = mod(Q' * Vc * S,2)

pause; disp('Construct inverses (on F_2) of R and S:')
Rinv=mod(inv(R),2)
checkR=mod(R*Rinv,2)
Sinv=mod(inv(S),2)
checkS=mod(S*Sinv,2)

pause; disp('Check: reconstruct the original Hc and Vc:')
H1 = mod(Rinv' * H * Q',2)
V1 = mod(Q * V * Sinv,2)


