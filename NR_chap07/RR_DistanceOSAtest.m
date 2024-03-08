% script <a href="matlab:RR_DistanceDLtest">RR_DistanceOSAtest</a>
% Test <a href="matlab:help RR_DistanceDL">RR_DistanceOSA</a> on a couple of string pairs.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 

a='CA', b='ABC', OSA1=RR_DistanceOSA(a,b,1), disp(' ')  % Test from Wikipedia's DL page.
a='HURQBOHP', b='QKHOZ', OSA2=RR_DistanceOSA(a,b), disp(' ')
a='abcdefghabcdefgh', b='bdafchebgdafcheg', OSA3=RR_DistanceOSA(a,b), disp(' ')

% end script RR_DistanceOSAtest
