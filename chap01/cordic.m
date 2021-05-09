function out = cordic(func,in,n,cordic_tables)
% function out = cordic(func,in,n,cordic_tables)
% Performs range reduction and calls cordic_core to calculate various functions.
% NOTE:   initialize cordic_tables by calling cordic_init script (just once)
% INPUT:  func={'cos_sin','cosh_sinh','Givens',...}
%         in=input data (as defined for each case in comments of main code below)
%         n=number of iterations (with increased precision for larger n; try n<40)
%         cordic_tables=tables of values initialized using cordic_init
% OUTPUT: v, modified by n shift/add iterations of the generalized CORDIC algorithm,
% EXAMPLE CALL: (see examples for each special case in the code below)
% Renaissance Robotics codebase, Chapter 1, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under Modified BSD License.

switch func
  case 'cos_sin'
    % in=angle (any real number)
    % out(1,2)->[cos(in); sin(in)]
    % out(3)=angle error
    % EXAMPLE CALL: cordic('cos_sin',1.0,30,cordic_tables)
    rot=1; mode=1; [in,sign]=RangeReduce1(in)
    v=[sign*cordic_tables.K(1,min(n,cordic_tables.N)); 0; in];
  case 'Givens'
    % in=[x,y,z] where z=angle (any real number)
    % out(1,2)->G*[x;y] with G=[cos(z) -sin(z); sin(z) cos(z)]
    % out(3)=angle error
    % Example: cordic('Givens',[1.0 2.0 3.0],30,cordic_tables)
    rot=1; mode=1; in(3)=RangeReduce1(in(3))
    v=[sign*cordic_tables.K(1,min(n,cordic_tables.N)); 0; in];
   case 'cosh_sinh'
    % in=input angle (?<in<?)
    % out(1,2)->[cosh(x); sinh(x); angle error]
    % Example: cordic('cosh_sinh',1.0,30,cordic_tables)
    rot=2; mode=1;
    v=[cordic_tables.K(2,min(n,cordic_tables.N)); 0; in];
  otherwise
    disp('Error: case not implemented.')
end
out=cordic_core(v,n,rot,mode,cordic_tables);
end
%%%%%%%%%%%%%
function [t,sign]=RangeReduce1(t)
twopi=2*pi;                % Range reduction to 0<=t<2*pi
c=floor(t/twopi); if c~=0, t=t-twopi*c; end
q=1+floor(t/(pi/2));       % Further range reduction to -pi/2<=t<pi/2
switch q, case 1, sign= 1;          
          case 2, sign=-1; t=t-pi;    
          case 3, sign=-1; t=t+pi;
          case 4, sign= 1; t=t-twopi;
end
end
    