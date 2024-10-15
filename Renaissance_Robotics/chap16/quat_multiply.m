function [s]=quat_multiply(q,r)
% Quaternion multiplication s=q*r  (use [0;r] on input if r has no real part)
q0=q(1); q1=q(2); q2=q(3); q3=q(4); % This line helpful because Matlab enumerates from 1
r0=r(1); r1=r(2); r2=r(3); r3=r(4);
s=[r0*q0-r1*q1-r2*q2-r3*q3;
   r0*q1+r1*q0-r2*q3+r3*q2;
   r0*q2+r1*q3+r2*q0-r3*q1;
   r0*q3-r1*q2+r2*q1+r3*q0]; 
end % function quat_multiply
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
