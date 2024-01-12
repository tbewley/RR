% script <a href="matlab:RouthSimplifiedTest">RouthSimplifiedTest</a>
%% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

p=[1 4 2 5 3 6],       RouthSimplified(p); check_roots_of_p=roots(p), disp(' ');

p=[1 2 8 12 20 16 16], RouthSimplified(p); check_roots_of_p=roots(p), disp(' ');

syms K; p=[1 10 100*K-200];  RouthSimplified(p);  disp(' ');

b=[1 .3]; a=[1 12 20 0 0]; % Example given in Figure 18.4 of NR.
p=PolyAdd(K*b,a),      RouthSimplified(p);  disp(' ');
p=PolyAdd(196.8*b,a),  RouthSimplified(p);  disp(' ');
p=PolyAdd(196.9*b,a),  RouthSimplified(p);  disp(' ');

% end script RouthSimplifiedTest
