% script <a href="matlab:RR_DistanceDLtest">RR_DistanceDLtest</a>
% Test <a href="matlab:help RR_DistanceDL">RR_DistanceDL</a> on a couple of string pairs.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

W.S=1; W.I=1; W.D=1; W.C=1; W.E=1;
a='CA', b='ABC', DL1=RR_DistanceDL(a,b,W,1), disp(' ')  % Test from Wikipedia's DL page.
a='HURQBOHP', b='QKHOZ', DL2=RR_DistanceOSA(a,b), disp(' ')
a='abcdefghabcdefgh', b='bdafchebgdafcheg', W.S=1; W.I=1; W.D=2; W.C=4; W.E=4;
DL3w=RR_DistanceDL(a,b,W)               % Test (4) from Lowrance & Wagner (1975).
DL3e=RR_DistanceDL(a,b), disp(' ')      % Modified test with equal weights.

% end script RR_DistanceDLtest
