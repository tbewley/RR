% script <a href="matlab:RC_DistanceDLtest">RC_DistanceOSAtest</a>
% Test <a href="matlab:help RC_DistanceDL">RC_DistanceOSA</a> on a couple of string pairs.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

a='CA', b='ABC', OSA1=RC_DistanceOSA(a,b,1), disp(' ')  % Test from Wikipedia's DL page.
a='HURQBOHP', b='QKHOZ', OSA2=RC_DistanceOSA(a,b), disp(' ')
a='abcdefghabcdefgh', b='bdafchebgdafcheg', OSA3=RC_DistanceOSA(a,b), disp(' ')

% end script RC_DistanceOSAtest
