function out = RR_cordic_derived(func,in,n,cordic_tables)
% function out = RR_cordic_derived(func,in,n,cordic_tables)
% Calls RR_cordic (which in turn calls RR_cordic_core) to calculate various derived functions,
% using common identities for log, exponential, trigonometric, and hyperbolic functions.
% NOTE:   initialize cordic_tables by calling RR_cordic_init script (just once)
% INPUT:  func={'tan','tanh','exp','log','log_b','sqrt', ...
%               'acos','asin','acosh','asinh','power'}
%         in=input data (as defined for each case in comments below)
%         n=number of iterations (with increased precision for larger n; try n<40)
%         cordic_tables=tables of values initialized using RR_cordic_init
% OUTPUT: out=input data (as defined for each case in comments below)
% TESTS:  x=1.0, RR_cordic_derived('tan', x,40,cordic_tables), t =tan(x),  RR_pause
%         x=1.0, RR_cordic_derived('tanh',x,40,cordic_tables), th=tanh(x), RR_pause
%         x=1.0, RR_cordic_derived('exp', x,40,cordic_tables), e =exp(x),  RR_pause
%         x=1.2, RR_cordic_derived('log', x,40,cordic_tables), l =log(x),  RR_pause
%         x=1.2, b=10, RR_cordic_derived('log_b',[x,b],40,cordic_tables), log10(x),      RR_pause
%         x=1.2, b=2,  RR_cordic_derived('log_b',[x,b],40,cordic_tables), log2(x),       RR_pause
%         x=1.2, b=5,  RR_cordic_derived('log_b',[x,b],40,cordic_tables), log(x)/log(b), RR_pause
%         x=0.5, RR_cordic_derived('sqrt', x,40,cordic_tables), s  =sqrt(x),  RR_pause
%         x=0.5, RR_cordic_derived('acos', x,40,cordic_tables), ac =acos(x),  RR_pause
%         x=0.5, RR_cordic_derived('asin', x,40,cordic_tables), as =asin(x),  RR_pause
%         x=2,   RR_cordic_derived('acosh',x,40,cordic_tables), ach=acosh(x), RR_pause
%         x=0.5, RR_cordic_derived('asinh',x,40,cordic_tables), ash=asinh(x), RR_pause
%         x=2, y=0.25, RR_cordic_derived('power',[x,y],40,cordic_tables), apy=x^y
%% Renaissance Robotics codebase, Chapter 1, https://github.com/tbewley/RR
%% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License.

switch func
  case 'tan'
    % out=tan(in) where in is any real number
    % uses identity tan(x)=sin(x)/cos(x)
    v=RR_cordic('cos_sin',in,n,cordic_tables);
    out=v(2)/v(1);
  case 'tanh'
    % out=tanh(in)
    % uses identity tanh(x)=sinh(x)/cosh(x)
    v=RR_cordic('cosh_sinh',in,n,cordic_tables);
    out=v(2)/v(1);
  case 'exp'
    % out=exp(in)
    % uses identity exp(x)=sinh(x)+cosh(x)
    v=RR_cordic('cosh_sinh',in,n,cordic_tables);
    out=v(1)+v(2);
  case 'log' 
    % out=log(in)  where log denotes the natural log, aka ln
    % uses identity log(x)=2*atanh((w-1)/(w+1))
    v=RR_cordic('modh_atanh',[in+1; in-1; 0],n,cordic_tables);
    out=2*v(3);
  case 'log_b'
    % in=[x,b]
    % out=log_b(x)
    % uses identity log_b(x)=log(x)/log(b))
    x=in(1); b=in(2); log_x=RR_cordic_derived('log',x,n,cordic_tables);
    switch b
       case 2,    log_b=0.693147180559945;
       case 10,   log_b=2.302585092994046;
       otherwise, log_b=RR_cordic_derived('log',b,n,cordic_tables);
    end
    out=log_x/log_b;
  case 'sqrt'
    % out=sqrt(in)
    % uses identity sqrt(x)=sqrt((x+1/4)^2-(x-1/4)^2)
    v=RR_cordic('modh_atanh',[in+0.25; in-0.25; 0],n,cordic_tables);
    out=v(1);
  case 'acos'
    % out=acos(in)
    % uses identity acos(x)=atan(sqrt(1-x^2)/x)
    v=RR_cordic('mod_atan',[in; sqrt(1-in^2); 0],n,cordic_tables);
    out=v(3);
  case 'asin'
    % out=asin(in)
    % uses identity asin(x)=atan(x/sqrt(1-x^2))  
    v=RR_cordic('mod_atan',[sqrt(1-in^2); in; 0],n,cordic_tables);
    out=v(3);
  case 'acosh'
    % out=acos(in)
    % uses identity acosh(x)=ln(x+sqrt(x^2-1))
    out=RR_cordic_derived('log',in+sqrt(in^2-1),n,cordic_tables);
  case 'asinh'
    % out=asin(in)
    % uses identity asinh(x)=ln(x+sqrt(x^2+1))
    out=RR_cordic_derived('log',in+sqrt(in^2+1),n,cordic_tables);
  case 'power'
    % in=[x,y]
    % out=x^y
    % uses identity x^y=exp(y*ln(x))
    x=in(1); y=in(2);
    ln_x=RR_cordic_derived('log',x,n,cordic_tables);
    out=RR_cordic_derived('exp',y*ln_x,n,cordic_tables);
  otherwise
    disp('Error: case not yet implemented.')
end
end
