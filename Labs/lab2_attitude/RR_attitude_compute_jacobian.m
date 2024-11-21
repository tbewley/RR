% Script to calculate the analytical Jacobian for the RR_attitude problem.
%
%% Renaissance Repository, https://github.com/tbewley/RR (Labs)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.


clc, syms q0 q1 q2 q3
disp('here is the Jacobian of f(q0,q1,q2,q3)=q0^2+q1^2+q2^2+q3^2')
jacobian([q0^2+q1^2+q2^2+q3^2],[q0 q1 q2 q3]), pause

disp('here is R_q and the Jacobian of f(q0,q1,q2,q3)=R_q*v where v=(vx,vy,vz)')
R = [q0^2+q1^2-q2^2-q3^2, 2*q1*q2 - 2*q0*q3,   2*q1*q3 + 2*q0*q2; ...
     2*q1*q2 + 2*q0*q3,   q0^2-q1^2+q2^2-q3^2, 2*q2*q3 - 2*q0*q1; ...
     2*q1*q3 - 2*q0*q2,   2*q2*q3 + 2*q0*q1,   q0^2-q1^2-q2^2+q3^2 ]
syms vx vy vz
jacobian(R*[vx; vy; vz],[q0 q1 q2 q3]), pause

disp('here is f(q0,q1,q2,q3)=R_q*g, and its Jacobian, where g=(0,0,1)')
R*[0; 0; 1]
jacobian(R*[0; 0; 1],[q0 q1 q2 q3]), pause

disp('here is f(q0,q1,q2,q3)=R_q*m, and its Jacobian, where m=(1,0,0)')
R*[1; 0; 0]
jacobian(R*[1; 0; 0],[q0 q1 q2 q3])
