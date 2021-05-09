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
    rot=1; mode=1; [in,sign]=RangeReduce1(in);
    v=[sign*cordic_tables.K(1,min(n,cordic_tables.N)); 0; in];
  case 'Givens'
    % in=[x,y,z] where z=angle (any real number)
    % out(1,2)->G*[x;y] with G=[cos(z) -sin(z); sin(z) cos(z)]
    % out(3)=angle error
    % EXAMPLE CALL: cordic('Givens',[1.0; 2.0; 1.0],30,cordic_tables)
    rot=1; mode=1; [in(3),sign]=RangeReduce1(in(3));
    v=[sign*cordic_tables.K(1,min(n,cordic_tables.N))*[in(1); in(2)]; in(3)];
  case 'mod_atan'
    % in=[x,y,z] 
    % out(1)->sqrt(x^2+y^2)
    % out(2)=error in y
    % out(3)->z+atan(y/x)
    % EXAMPLE CALL: cordic('mod_atan',[1.0; 2.0; 3.0],30,cordic_tables)
    rot=1; mode=2;
    v=[cordic_tables.K(1,min(n,cordic_tables.N))*[in(1); in(2)]; in(3)];    
  case 'cosh_sinh'
    % in=input angle (NOTE! Only works for -1.118173<in<1.118173)
    % out(1,2)->[cosh(in); sinh(in)]
    % out(3)=angle error
    % Example: cordic('cosh_sinh',1.0,30,cordic_tables)
    rot=2; mode=1;
    v=[cordic_tables.K(2,min(n,cordic_tables.N)); 0; in];
  case 'GivensH'
    % in=[x,y,z] (NOTE! Only works for -1.118173<z<1.118173)
    % out(1,2)->H*[x;y] with H=[cosh(z) sinh(z); sinh(z) cosh(z)]
    % out(3)=angle error
    % EXAMPLE CALL: cordic('GivensH',[1.0; 0.2; 1.0],30,cordic_tables)
    rot=2; mode=1;
    v=[cordic_tables.K(2,min(n,cordic_tables.N))*[in(1); in(2)]; in(3)];
  case 'modh_atanh'
    % in=[x,y,z] (NOTE! Only works for -1.118173<atanh(y/x)<1.118173)
    % out(1)->sqrt(x^2-y^2)
    % out(2)=error in y
    % out(3)->z+atanh(y/x)
    % EXAMPLE CALL: cordic('modh_atanh',[1; 0.2; 3.0],30,cordic_tables)
    rot=2; mode=2;
    v=[cordic_tables.K(2,min(n,cordic_tables.N))*[in(1); in(2)]; in(3)];    
  case 'MAC' % (Multiply / Accumulate)
    % in=[x,y,z] (NOTE! Only works for -2<z*x<2)
    % out(1)=x
    % out(2)->y+(z*x)*2
    % out(3)=angle error
    % EXAMPLE CALL: x=1.1; y=0.1; z=0.6; cordic('MAC',[x;y;z],30,cordic_tables), y+(z*x)*2
    rot=3; mode=1; v=in;
  case 'DAC'  % (Divide / Accumulate)
    % in=[x,y,z] (NOTE! Only works for -2<z*x<2)
    % out(1)=x
    % out(2)=error in y
    % out(3)->z+(y/x)/2
    % EXAMPLE CALL: x=1.1; y=0.1; z=0.6; cordic('DAC',[x;y;z],30,cordic_tables), z+(y/x)/2
    rot=3; mode=2; v=in;
  otherwise
    disp('Error: case not yet implemented.')
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
    