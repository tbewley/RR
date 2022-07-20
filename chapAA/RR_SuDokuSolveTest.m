% script <a href="matlab:RR_SuDokuSolveTest">RR_SuDokuSolveTest</a>
% Test <a href="matlab:help RR_SuDokuSolve">RR_SuDokuSolve</a> on a couple of SuDoku problems.
% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

format compact
A=[0 2 0 1 4 0 0 0 0; 5 0 0 2 3 0 0 9 0; 8 0 0 0 0 0 1 7 0; ...
   0 0 3 6 0 1 0 8 0; 0 4 0 0 8 0 0 6 0; 0 0 0 4 0 3 5 0 0; ...
   0 9 5 0 0 0 0 0 8; 0 1 0 0 5 2 0 0 7; 0 0 0 0 1 6 0 3 5];
RR_SuDokuSolve(A)  
fprintf('Press any key to continue\n\n'); pause;

B=[0 0 1 0 0 3 6 0 0; 0 7 0 0 0 5 0 0 2; 6 0 0 0 0 0 0 0 0; ...
   0 0 5 1 0 0 0 8 0; 3 0 0 8 0 0 0 0 1; 0 4 0 0 0 0 9 0 0; ...
   0 0 0 0 0 0 0 0 3; 2 0 0 4 0 0 0 1 0; 0 0 7 6 0 0 5 0 0];
RR_SuDokuSolve(B)

% end script RR_SuDokuSolveTest
