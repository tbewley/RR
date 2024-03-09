function out = RR_cordic(func,in,n,cordic_tables)
% function out = RR_cordic(func,in,n,cordic_tables)
% Performs range reduction and calls cordic_core to calculate various functions.
% NOTE:   initialize cordic_tables by calling RR_cordic_init script (just once)
% INPUT:  func={'cos_sin','Givens','mod_atan','cosh_sinh','GivensH','modh_atanh','MAC','DAC'}
%         in=input data (as defined for each case in comments of main code below)
%         n=number of iterations (with increased precision for larger n; try n<40)
%         cordic_tables=tables of values initialized using RR_cordic_init
% OUTPUT: v, modified by n shift/add iterations of the generalized CORDIC algorithm,
% TESTS:  x=1, RR_cordic('cos_sin',x,30,cordic_tables), c=cos(x), s=sin(x), RR_pause
%         x=2, y=3, z=1, RR_cordic('Givens',[x;y;z],30,cordic_tables)
%              G=[cos(z) -sin(z); sin(z) cos(z)], rot=G*[x;y], RR_pause
%         x=1, y=2, z=3, RR_cordic('mod_atan',[x;y;z],30,cordic_tables)
%              mo=sqrt(x^2+y^2), at=z+atan(y/x), RR_pause
%         x=1, RR_cordic('cosh_sinh',x,30,cordic_tables), ch=cosh(x), sh=sinh(x), RR_pause
%         x=2, y=3, z=1, RR_cordic('GivensH',[x;y;z],30,cordic_tables)
%              H=[cosh(z) sinh(z); sinh(z) cosh(z)], H*[x;y], RR_pause
%         x=3, y=1, z=2, RR_cordic('modh_atanh',[x;y;z],30,cordic_tables)
%              moh=sqrt(x^2-y^2), ath=z+atanh(y/x), RR_pause
%         x=1.1, y=0.1, z=0.6, RR_cordic('MAC',[x;y;z],30,cordic_tables), mac=y+z*x, RR_pause
%         x=1.1, y=0.1, z=0.6, RR_cordic('DAC',[x;y;z],30,cordic_tables), dac=z+y/x
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/RR_chap01
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

switch func
  case 'cos_sin'
    % in=angle (any real number)
    % out(1,2)->[cos(in); sin(in)]
    % out(3)=angle error
    rot=1; mode=1; [in,sign]=RR_range_reduce(in);
    v=[sign*cordic_tables.K(1,min(n,cordic_tables.N)); 0; in];
  case 'Givens'
    % in=[x,y,z] where z=angle (any real number)
    % out(1,2)->G*[x;y] with G=[cos(z) -sin(z); sin(z) cos(z)]
    % out(3)=angle error
    rot=1; mode=1; [in(3),sign]=RR_range_reduce(in(3));
    v=[sign*cordic_tables.K(1,min(n,cordic_tables.N))*[in(1); in(2)]; in(3)];
  case 'mod_atan'
    % in=[x,y,z] 
    % out(1)->sqrt(x^2+y^2)
    % out(2)=error in y
    % out(3)->z+atan(y/x)
    rot=1; mode=2;
    v=[cordic_tables.K(1,min(n,cordic_tables.N))*[in(1); in(2)]; in(3)];    
  case 'cosh_sinh'
    % in=input angle (NOTE! Only works for -1.118173<in<1.118173)
    % out(1,2)->[cosh(in); sinh(in)]
    % out(3)=angle error
    rot=2; mode=1;
    v=[cordic_tables.K(2,min(n,cordic_tables.N)); 0; in];
  case 'GivensH'
    % in=[x,y,z] (NOTE! Only works for -1.118173<z<1.118173)
    % out(1,2)->H*[x;y] with H=[cosh(z) sinh(z); sinh(z) cosh(z)]
    % out(3)=angle error
    rot=2; mode=1;
    v=[cordic_tables.K(2,min(n,cordic_tables.N))*[in(1); in(2)]; in(3)];
  case 'modh_atanh'
    % in=[x,y,z] (NOTE! Only works for -1.118173<atanh(y/x)<1.118173)
    % out(1)->sqrt(x^2-y^2)
    % out(2)=error in y
    % out(3)->z+atanh(y/x)
    rot=2; mode=2;
    v=[cordic_tables.K(2,min(n,cordic_tables.N))*[in(1); in(2)]; in(3)];    
  case 'MAC' % (Multiply / Accumulate)
    % in=[x,y,z] (NOTE! Only works for -2<z*x<2)
    % out(1)=x
    % out(2)->y+z*x
    % out(3)=angle error
    rot=3; mode=1; v=in;
  case 'DAC'  % (Divide / Accumulate)
    % in=[x,y,z] (NOTE! Only works for -2<y/x<2)
    % out(1)=x
    % out(2)=error in y
    % out(3)->z+y/x
    rot=3; mode=2; v=in;
  otherwise
    disp('Error: case not implemented in RR_cordic.m, check RR_cordic_derived.m')
end
out=RR_cordic_core(v,n,rot,mode,cordic_tables);
end 