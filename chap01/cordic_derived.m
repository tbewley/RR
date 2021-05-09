function out = cordic_derived(func,in,n,cordic_tables)
% function out = cordic(func,in,n,cordic_tables)
% Calls cordic (which in turn calls cordic_core) to calculate various derived functions.
% NOTE:   initialize cordic_tables by calling cordic_init script (just once)
% INPUT:  func={'tan'}
%         in=input data (as defined for each case in comments below)
%         n=number of iterations (with increased precision for larger n; try n<40)
%         cordic_tables=tables of values initialized using cordic_init
% OUTPUT: out=input data (as defined for each case in comments below)
% EXAMPLE CALL: (see examples for each special case in the code below)
% Renaissance Robotics codebase, Chapter 1, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under Modified BSD License.

switch func
  case 'tan'
    % in=angle (any real number)
    % out=tan(in)
    % EXAMPLE CALL: x=1.0; cordic_derived('tan',x,40,cordic_tables), tan(x)
    v=cordic('cos_sin',in,n,cordic_tables);
    out=v(2)/v(1);
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
    % out(2)->y+z*x
    % out(3)=angle error
    % EXAMPLE CALL: x=1.1; y=0.1; z=0.6; cordic('MAC',[x;y;z],30,cordic_tables), y+z*x
    rot=3; mode=1; v=in;
  case 'DAC'  % (Divide / Accumulate)
    % in=[x,y,z] (NOTE! Only works for -2<y/x<2)
    % out(1)=x
    % out(2)=error in y
    % out(3)->z+y/x
    % EXAMPLE CALL: x=1.1; y=0.1; z=0.6; cordic('DAC',[x;y;z],30,cordic_tables), z+y/x
    rot=3; mode=2; v=in;
  otherwise
    disp('Error: case not yet implemented.')
end
end