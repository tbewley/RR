% script RR_frame_Four_Bar_Seesaw_HARD_WAY
% This code sets up and solves the forces in the four-bar seesaw.  The SLOW, BUGGY WAY...
% Getting the A and b above coded correctly this way is painful indeed.
% See RR_frame_Four_Bar_Seesaw for a much better way to solve this problem!
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 3)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, clc                        % (... start from scratch ...)
lA=0.1; lB=0.2;                   % Locations of the masses, in meters
fyA=-1; fyB=-1;                   % Values of the externally-applied forces, in Newtons
phi=10; c=cosd(phi); s=sind(phi); % Deflection of the frame, in degrees, and its sin and cos
h=1; w=2;                         % Parameters defining {height,width} of the physical frame

% x={fCAx fCAy fCGx fCGy fCBx fCBy fDAx fDAy fDGx fDGy fDBx fDBy}
 A=[  1    0    0    0    0    0     1    0    0    0    0    0;
      0    1    0    0    0    0     0    1    0    0    0    0;
     -h    0    0    0    0    0     h    0    0    0    0    0;
      0    0    0    0    1    0     0    0    0    0    1    0;
      0    0    0    0    0    1     0    0    0    0    0    1;
      0    0    0    0   -h    0     0    0    0    0    h    0;
     -1    0   -1    0   -1    0     0    0    0    0    0    0;
      0   -1    0   -1    0   -1     0    0    0    0    0    0;
      s    c    0    0   -s   -c     0    0    0    0    0    0;
      0    0    0    0    0    0    -1    0   -1    0   -1    0;
      0    0    0    0    0    0     0   -1    0   -1    0   -1;
      0    0    0    0    0    0     s    c    0    0   -s   -c]
  b=[ 0  -fyA lA*fyA 0  -fyB -lB*fyB 0    0    0    0    0    0]', pause

x=A\b,      disp('The A\b approach fails, because A is singular.  Dude.'), pause

x=inv(A)*b, disp('The inv(A)*b approach also fails, because A is singular.  Dude...'), pause

x=pinv(A)*b, error=norm(A*x-b), b_dot_null_AT=b'*null(A')
disp('Taking x=pinv(A)*b gives a valid answer, of many, IF AND ONLY IF fyA=fyB, because')
disp('A is potentially inconsistent.  To get a valid answer, b*null(A'') must be zero.  Dude!'), pause

c=randn, x1=x+c*null(A), error=norm(A*x1-b)
disp('If x is valid, taking x1=x+c*null(A) gives another valid answer, for any c.  Dude!!!');
