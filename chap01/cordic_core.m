function v = cordic_core(v,n,rot,mode,cordic_tables)
% function v = cordic_core(v,n,rot,mode,cordic_tables)
% Apply n shift/add iterations of the generalized CORDIC algorithm.
% (This Matlab code uses floating point numbers, so it's just for demo purposes.)
% INPUTS: v=[x;y;z]
%         n=number of iterations (with increased precision for larger n; try n<40)
%         rot={1,2,3} (for circular, hyperbolic, or linear rotations, respectively)
%         mode={1,2}  (for rotation or vectoring mode, respectively)
%         cordic_tables=tables of useful values generated using cordic_init
% OUTPUT: v, modified by n shift/add iterations of the generalized CORDIC algorithm,
% with convergence in each of its 2x3=6 forms as follows:
% {rot,mode}={1,1}:  [x;y] -> K1*G*[x;y] with G=[cos(z) -sin(z); sin(z) cos(z)]
%           ={1,2}:  [x;z] -> [K1*sqrt(x^2+y^2); z+atan(y/x)]
%           ={2,1}:  [x;y] -> K2*F*[x;y] with F=[cosh(z) -sinh(z); sinh(z) cosh(z)]
%           ={2,2}:  [x;z] -> [K2*sqrt(x^2-y^2); z+atanh(y/x)]
%           ={3,1}:  [x;y] -> [x; y+x*z] 
%           ={3,2}:  [x;z] -> [x; z+y/x]
% Note that z=v(3)->0 for mode=1, and y=v(2)->0 for mode=2.
% See cordic.m for how to set up the input v, and how to process the output v,
% to approximate various specific functions.  NOTE: the scaling of v by K1 or K2,
% where necessary, is done over in cordic.m, not in this code.
% Renaissance Robotics codebase, Chapter 1, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under Modified BSD License.

switch rot  % Initialize {mu,fac,ang} for different types of rotations 
  case 1, mu= 1; fac=1;   ang=cordic_tables.ang(1,1);  % Circular rotations
  case 2, mu=-1; fac=1/2; ang=cordic_tables.ang(2,1);  % Hyperbolic rotations
  case 3, mu= 0; fac=1;   ang=1/2;                     % Linear rotations
end        
for j=1:n                                       % perform n iterations
  switch mode                                   % compute sign of next rotation:
    case 1, if v(3)<0, sig=-1; else, sig=1; end % Rotation  mode (drive z->0)
    case 2, if v(2)<0, sig=-1; else, sig=1; end % Vectoring mode (drive y->0)
  end
  
  %%%% BELOW IS THE HEART OF THE CORDIC ALGORITHM %%%%
  v(1:2)=[1 -mu*sig*fac; sig*fac 1]*v(1:2); % generalized rotation of v(1:2) by fac
  v(3)  =v(3)-sig*ang;                      % update v(3)
  
  % update fac (divide by 2) [iterations {4,13,40} repeated in hyperbolic case]
  if mu>-1 || ((j~=4) && (j~=14) && (j~=42)), fac=fac/2; end
  % update ang from tables, or divide by 2
  if j+1<=cordic_tables.N && rot<3, ang=cordic_tables.ang(rot,j+1); else, ang=ang/2; end
end
end