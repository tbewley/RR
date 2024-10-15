function [v]=quat_rotate(q,u)
% Note: q needs to be a unit quaternion for this function to work correctly!
q0=q(1); q1=q(2); q2=q(3); q3=q(4); % This line helpful because Matlab enumerates from 1
v=[(q0^2+q1^2-q2^2-q3^2)   2*(q1*q2-q0*q3)     2*(q1*q3+q0*q2);
    2*(q1*q2+q0*q3)    (q0^2-q1^2+q2^2-q3^2)   2*(q2*q3-q0*q1);
    2*(q1*q3-q0*q2)        2*(q2*q3+q0*q1)  (q0^2-q1^2-q2^2+q3^2)]*u;
end % function quat_rotate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
