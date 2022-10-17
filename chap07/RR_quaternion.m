% classdef RR_quaternion
% This class defines a quaternion class, and a standard set of operations over it.
% DEFINITION:
%   q=RR_quaternion([q1 q2 q3 q4])  defines an RR_poly object (a row vector) from a 4D vector q.
%   q=RR_quaternion([u1 u2 u3],phi) defines an RR_poly object from a 3D vector u and a rotation angle phi.
% OPERATIONS (overloading the +, -, *, /, ^, ' operators):
%   p+q, p-q, p*q: the sum, difference, product of two quaternions
%   p^n, p' gives the n'th power and conjugate of a quaternion
%   norm(p), inv(p) = norm and inverse of a quaternion
%   p/q = p*inv(q), q\p = inv(q)*p: right and left multiplication of the inverse
%   rotate(a,q):        perform a quaternion rotation of a 3D vector a using the formula q*a*q'
%   rotation_matrix(q): compute the rotation matrix equivalent to p
% SOME TESTS:
%   a=rand(3,1)                    % a = a random 3D initial vector to be rotated
%   u=rand(3,1); u=u/norm(u);      % u = a random unit vector
%   phi=pi*randn                   % phi = a random angle to rotate a about u
%   q=RR_quaternion(u,phi)         % q = a quaternion useful for accomplishing this rotation
%   b=rotate(a,q), a1=rotate(b,q') % b = rotated version of a;  a1 = rotated back!
%   R=rotation_matrix(q)           % R = rotation matrix equivalent to quaternion q
%   b1=R*a                         % b1 = an alternate calculation of b
% Renaissance Robotics codebase, Chapter 7, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License.

classdef RR_quaternion < matlab.mixin.CustomDisplay
    properties  % Each RR_quaternion object consists of a single field:
        v       % the quaternion itself, written as an ordinary row vector with 4 components.
     end
    methods
        function q = RR_quaternion(u,phi)  % a=RR_poly creates an RR_poly object obj.
            if nargin==1                   % one argument: create q from component(s) specified
                if sum(size(u)==[3 3])==2, % Convert rotation matrix to quaternion
                    u11=u(1,1); u12=u(1,2); u13=u(1,3);
                    u21=u(2,1); u22=u(2,2); u23=u(2,3);
                    u31=u(3,1); u32=u(3,2); u33=u(3,3); t=u11+u22+u33;
                    if (t>0);                        S=sqrt(t          +1)*2;             
                        w=S/4; x=(u32-u23)/S; y=(u13-u31)/S; z=(u21-u12)/S; 
                    elseif ((u11>u22) & (u11>u33)),  S=sqrt(u11-u22-u33+1)*2;    
                        x=S/4; w=(u32-u23)/S; y=(u12+u21)/S; z=(u13+u31)/S; 
                    elseif (u22>u33),                S=sqrt(u22-u11-u33+1)*2;   
                        y=S/4; w=(u13-u31)/S; x=(u12+u21)/S; z=(u23+u32)/S; 
                    else,                            S=sqrt(u33-u11-u22+1)*2;
                        z=S/4; w=(u21-u12)/S; x=(u13+u31)/S; y=(u23+u32)/S;
                    end;  q.v=[w x y z];
                elseif isa(u,'RR_rotation_sequence')  % Convert rotation sequence to quaternion
                    t=deg2rad(u.an); alpha=t(1); beta=t(2); gamma=t(3);
                    q1=RR_quaternion([cos(alpha/2)]); q2=RR_quaternion([cos(beta/2)]); q3=RR_quaternion([cos(gamma/2)]);
                    q1=q1+ e(u.ax(1))*sin(alpha/2),   q2=q2+ e(u.ax(2))*sin(beta/2),   q3=q3+ e(u.ax(3))*sin(gamma/2),
                    q=(q1*q2*q3)';
                else switch length(u)
                    case 1, q.v=[u 0 0 0];              % Scalar
                    case 3, q.v=[ 0   u(1) u(2) u(3)];  % 3D vector
                    case 4, q.v=[u(1) u(2) u(3) u(4)];  % 4 components of a quaternion
                    otherwise, error('input vector wrong size')
                    end
                end
            else                           % two arguments: compute q = e^(u*phi)
                 c=cos(phi); s=sin(phi); q.v=[c s*u(1) s*u(2) s*u(3)];
            end
            if q.v(1)<0, q.v=-q.v; end     % remove double cover
            function out=e(i), out=[0 0 0 0]; out(1+i)=1; end  % Defines a useful unit vector for this function
        end
        function p = plus(p,q),     [p,q]=check(p,q); p.v=p.v+q.v;  end  % p+q
        function p = minus(p,q),    [p,q]=check(p,q); p.v=p.v-q.v;  end  % p-q
        function p = mrdivide(p,q),                   p=p*inv(q); end  % p/q = p*inv(q)
        function p = mldivide(p,q),                   p=inv(p)*q; end  % p\q = inv(p)*q
        function out = mtimes(p,q),                                        % p*q
           if     ~isa(p,'RR_quaternion'),  out=RR_quaternion(p*q.v);
           elseif ~isa(q,'RR_quaternion'),  out=RR_quaternion(p.v*q);
           else,  t=p.v;             
               P=[ t(1) -t(2) -t(3) -t(4);
                   t(2)  t(1) -t(4)  t(3);  % Note: indexing from 1, not 0!
                   t(3)  t(4)  t(1) -t(2);
                   t(4) -t(3)  t(2)  t(1)]; out=RR_quaternion(P*q.v');
           end
        end
        function pow = mpower(p,n)                                     % p^n
            if n==0, pow=RR_quaternion(1); else, pow=p; for i=2:n, pow=pow*p; end, end
        end
        function p = ctranspose(p)                                     % p' = "conjugate"
            p=RR_quaternion([p.v(1) -p.v(2) -p.v(3) -p.v(4)]);
        end
        function [p,q]=check(p,q)
            if ~isa(p,'RR_quaternion'), p=RR_quaternion(p);   end
            if ~isa(q,'RR_quaternion'), q=RR_quaternion(q);   end
        end
        function n = norm(p),     n=norm(p.v);                end
        function p = inv(p),      p=p'/(norm(p.v)^2);           end
        function b = rotate(a,q)
            [t,q]=check(a,q); t=q*t*q'; b=[t.v(2); t.v(3); t.v(4)];
            % Note: above calculation is equivalent to t1=rotation_matrix(q)*a
        end
        function R = rotation_matrix(q)      % Convert quaternion to rotatin matrix
            q0=q.v(1); q1=q.v(2); q2=q.v(3); q3=q.v(4);  % Note: indexing from 1, not 0!
            R=[q0^2+q1^2-q2^2-q3^2  2*(q1*q2-q0*q3)  2*(q1*q3+q0*q2);
               2*(q1*q2+q0*q3)  q0^2-q1^2+q2^2-q3^2  2*(q2*q3-q0*q1);
               2*(q1*q3-q0*q2)  2*(q2*q3+q0*q1)  q0^2-q1^2-q2^2+q3^2];
        end
        function r = rotation_sequence(q,ax)
            % Convert quaternion to rotation sequence with axes ax
            % Formulae from https://en.wikipedia.org/wiki/Euler_angles#Rotation_matrix,
            % corrected to incorporate atan2.
            R=rotation_matrix(q),  r=RR_rotation_sequence(ax,[0 0 0]);
            q0=q.v(1); q1=q.v(2); q2=q.v(3); q3=q.v(4);
            switch ax(1)*100+ax(2)*10+ax(3)     
                case 123, r.t='Tait-Bryan';
                    alpha =  atan2(-R(2,3),R(3,3));
                    beta  =  atan2(R(1,3),sqrt(1-R(1,3)^2));
                    gamma =  atan2(-R(1,2),R(1,1));
                case 132, r.t='Tait-Bryan';
                    alpha =  atan2(R(3,2),R(2,2));
                    beta  =  atan2(-R(1,2),sqrt(1-R(1,2)^2));
                    gamma =  atan2(R(1,3),R(1,1));
                case 213, r.t='Tait-Bryan';
                    alpha =  atan2(R(1,3),R(3,3));
                    beta  =  atan2(-R(2,3),sqrt(1-R(2,3)^2));
                    gamma =  atan2(R(2,1),R(2,2));
                case 231, r.t='Tait-Bryan';
                    alpha =  atan2(-R(3,1),R(1,1));
                    beta  =  atan2(R(2,1),sqrt(1-R(2,1)^2));
                    gamma =  atan2(-R(2,3),R(2,2));
                case 312, r.t='Tait-Bryan';
                    alpha =  atan2(-R(1,2),R(2,2));
                    beta  =  atan2(R(3,2),sqrt(1-R(3,2)^2));
                    gamma =  atan2(-R(3,1),R(3,3));
                case 321, r.t='Tait-Bryan'; % 3-2-1 is the most common Tait-Bryan rotation sequence
                    alpha =  atan2(R(2,1),R(1,1));
                    beta  =  atan2(-R(3,1),sqrt(1-R(3,1)^2));
                    gamma =  atan2(R(3,2),R(3,3));
                case 121, r.t='Euler';
                    alpha =  atan2(R(2,1),-R(3,1));
                    beta  =  atan2(sqrt(1-R(1,1)^2),R(1,1));
                    gamma =  atan2(R(1,2),R(1,3));
                case 131, r.t='Euler';
                    alpha =  atan2(R(3,1),R(2,1));
                    beta  =  atan2(sqrt(1-R(1,1)^2),R(1,1));
                    gamma =  atan2(R(1,3),-R(1,2));                    
                case 212, r.t='Euler';
                    alpha =  atan2(R(1,2),R(3,2));
                    beta  =  atan2(sqrt(1-R(2,2)^2),R(2,2));
                    gamma =  atan2(R(2,1),-R(2,3));
                case 232, r.t='Euler';
                    alpha =  atan2(R(3,2),-R(1,2));
                    beta  =  atan2(sqrt(1-R(2,2)^2),R(2,2));
                    gamma =  atan2(R(2,3),R(2,1));
                case 313, r.t='Euler';   % 3-1-3 is the most common Euler rotation sequence
                     alpha =  atan2(R(1,3),-R(2,3));
                     beta  =  acos(q0^2-q1^2-q2^2+q3^2);
                     gamma =  atan2(R(3,1),R(3,2));
                case 323, r.t='Euler';
                    alpha =  atan2(R(2,3),R(1,3));
                    beta  =  acos(q0^2-q1^2-q2^2+q3^2);
                    gamma =  atan2(R(3,2),-R(3,1));
                otherwise, error('Invalid rotation sequence axes'),
            end,    r.an=rad2deg([alpha beta gamma]);
        end
        function test_rotation_sequences(q)
        % This routine tests all 12 rotation sequences, converting from q to r and back to q.
        % Note that -180<alpha<=180 and -180<gamma<=180.
        % For Tait-Bryan rotations, -90<=beta<=90.  For Euler rotations, 0<=beta<=180.
        % To run this test on random q, for example, initialize as follows:
        % u=rand(3,1); u=u/norm(u); phi=pi*randn; q=RR_quaternion(u,phi), test_rotation_sequences(q)

            seq=[1 2 3; 1 3 2; 2 1 3; 2 3 1; 3 1 2; 3 2 1; ...  % Tait-Bryan rotations
                 1 2 1; 1 3 1; 2 1 2; 2 3 2; 3 1 3; 3 2 3];     % Euler rotations
            for i=1:12
                r=rotation_sequence(q,seq(i,:))   % Determine corresponding rotation sequence
                q1=quaternion(r)                  % Convert back to the corresponding quaternion
                error=norm(q-q1)                  % quantify the error
                pause
            end
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods(Access = protected)
        function displayScalarObject(obj)
            fprintf(getHeader(obj))
            disp(obj.v)
        end
    end
end
