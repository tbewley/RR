% classdef RR_quaternion
% This class defines a quaternion class, and a standard set of operations over it.
% DEFINITION:
%   The command q=RR_quaternion(d,phi) generates an RR_quaternion object with just one field:
%      q.v = a row vector with the 4 components of the quaternion, {q0 q1 q2 q3}
%   Executing the RR_quaternion command with two arguments returns q = e^(d*phi),
%   where d is a 3-component vector [d1 d2 d3], and phi is a scalar angle (in radians).
%   When executing the RR_quaternion command with a singe argument, "d" can be any of the following:
%       a 3x3 matrix R, of unit determinant, representing a rotation matrix, or
%       a rotation sequence object r, of type RR_rotation_sequence, or
%       a scalar d0 (that is, with zero vec part [d1 d2 d3]=0), or
%       a 3-component vector [d1 d2 d3] (that is, with zero scalar part [d0]=0), or
%       a 4-component vector [d0 d1 d2 d3] representing the quaternion itself.
% OPERATIONS (overloading the +, -, *, /, ^, ' operators):
%   p+q, p-q, p*q: the sum, difference, product of two quaternions
%   p^n, p' gives the n'th power and conjugate of a quaternion
% ADDITIONAL FUNCTIONS DEFINED:
%   norm(p), inv(p) = norm and inverse of a quaternion
%   p/q = p*inv(q), q\p = inv(q)*p: right and left multiplication by the inverse
%   b = rotate(a,q)        rotates a (column) vector a using a RR_quaternion object q such that b=q*a*q'
%   R = rotation_matrix(q) generates a rotation matrix R equivalent to the RR_quaternion object q
% SOME SIMPLE TESTS:
%   a=rand(3,1)                    % a random 3D initial vector to be rotated
%   u=rand(3,1); u=u/norm(u);      % a random unit vector
%   phi=pi*randn                   % a random angle to rotate a about u
%   q=RR_quaternion(u,phi)         % a quaternion useful for accomplishing this rotation
%   b=rotate(a,q), a1=rotate(b,q') % b = rotated version of a;  a1 = rotated back!
%   R=rotation_matrix(q)           % rotation matrix equivalent to quaternion q
%   b1=R*a                         % an alternate calculation of b
% Renaissance Robotics codebase, Chapter 7, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License.
% See also RR_rotation_sequence.

classdef RR_quaternion < matlab.mixin.CustomDisplay
    properties  % Each RR_quaternion object consists of a single field:
        v       % the quaternion itself, written as an ordinary row vector with 4 components.
     end
    methods
        function q = RR_quaternion(d,phi)  % a=RR_poly creates an RR_poly object obj.
            if nargin==1                   % one argument: create q from component(s) specified
                if sum(size(d)==[3 3])==2, % Convert rotation matrix R to quaternion
                    R11=d(1,1); R12=d(1,2); R13=d(1,3);
                    R21=d(2,1); R22=d(2,2); R23=d(2,3);
                    R31=d(3,1); R32=d(3,2); R33=d(3,3); t=R11+R22+R33;
                    if (t>0);                        S=sqrt(t          +1)*2;             
                        w=S/4; x=(R32-R23)/S; y=(R13-R31)/S; z=(R21-R12)/S; 
                    elseif ((R11>R22) & (R11>R33)),  S=sqrt(R11-R22-R33+1)*2;    
                        x=S/4; w=(R32-R23)/S; y=(R12+R21)/S; z=(R13+R31)/S; 
                    elseif (R22>R33),                S=sqrt(R22-R11-R33+1)*2;   
                        y=S/4; w=(R13-R31)/S; x=(R12+R21)/S; z=(R23+R32)/S; 
                    else,                            S=sqrt(R33-R11-R22+1)*2;
                        z=S/4; w=(R21-R12)/S; x=(R13+R31)/S; y=(R23+R32)/S;
                    end;  q.v=[w x y z]; q=remove_double_cover(q);
                elseif isa(d,'RR_rotation_sequence')    % Convert rotation sequence to quaternion
                    t=deg2rad(d.an); alpha=t(1); beta=t(2); gamma=t(3);
                    q1=RR_quaternion([cos(alpha/2)]); q2=RR_quaternion([cos(beta/2)]); q3=RR_quaternion([cos(gamma/2)]);
                    q1=q1+ e(d.ax(1))*sin(alpha/2);   q2=q2+ e(d.ax(2))*sin(beta/2);   q3=q3+ e(d.ax(3))*sin(gamma/2);
                    q=q1*q2*q3; q=remove_double_cover(q);
                else switch length(d)
                    case 1, q.v=[d 0 0 0];              % Scalar
                    case 3, q.v=[ 0   d(1) d(2) d(3)];  % 3D vector
                    case 4, q.v=[d(1) d(2) d(3) d(4)];  % 4 components of a quaternion
                    otherwise, error('input vector wrong size')
                    end
                end
            else                                        % two arguments: compute q = e^(d*phi)
                if abs(norm(d)-1)>1e-15, disp('input vector not of unit length; not valid for rotation!'), end  
                c=cos(phi); s=sin(phi); q.v=[c s*d(1) s*d(2) s*d(3)]; q=remove_double_cover(q);
            end
            function out=e(i), out=[0 0 0 0]; out(1+i)=1; end  % Defines a useful unit vector for this function
            function q=remove_double_cover(q), if isnumeric(q.v) & q.v(1)<-1e-15, q.v=-q.v; end, end
        end
        function p = plus(p,q),     [p,q]=check(p,q); p.v=p.v+q.v;  end  % p+q
        function p = minus(p,q),    [p,q]=check(p,q); p.v=p.v-q.v;  end  % p-q
        function p = mrdivide(p,q),                   p=p*inv(q); end    % p/q = p*inv(q)
        function p = mldivide(p,q),                   p=inv(p)*q; end    % p\q = inv(p)*q
        function out = mtimes(p,q),                                      % p*q
           if     ~isa(p,'RR_quaternion'),  out=RR_quaternion(p*q.v);
           elseif ~isa(q,'RR_quaternion'),  out=RR_quaternion(p.v*q);
           else,  t=p.v;             
               P=[t(1) -t(2) -t(3) -t(4);
                  t(2)  t(1) -t(4)  t(3);  % Note: indexing from 1, not 0!
                  t(3)  t(4)  t(1) -t(2);
                  t(4) -t(3)  t(2)  t(1)]; out=RR_quaternion(P*q.v');
           end
        end
        function pow = mpower(p,n)                                       % p^n
            if n==0, pow=RR_quaternion(1); else, pow=p; for i=2:n, pow=pow*p; end, end
        end
        function p = ctranspose(p)                                       % p' = "conjugate"
            p=RR_quaternion([p.v(1) -p.v(2) -p.v(3) -p.v(4)]);
        end
        function [p,q]=check(p,q)
            if ~isa(p,'RR_quaternion'), p=RR_quaternion(p);  end
            if ~isa(q,'RR_quaternion'), q=RR_quaternion(q);  end
        end
        function n = norm(p),     n=norm(p.v);               end
        function p = inv(p),      p=p'/(norm(p.v)^2);        end
        function a = rotate(a,q)
        % Rotate a (column) vector a using a quaternion q, of type RR_quaternion, via q*a*q' 
        % Note: above calculation is equivalent to t1=rotation_matrix(q)*a
            [t,q]=check(a,q); t=q*t*q'; a=[t.v(2); t.v(3); t.v(4)];
        end
        function R = rotation_matrix(q)
        % Convert a unit quaternion q, of type RR_quaternion, to a rotation matrix R with det(R)=1
            if abs(norm(q)-1)>1e-8, error('quaternion not of unit length; not valid for rotation!'), end  
            q0=q.v(1); q1=q.v(2); q2=q.v(3); q3=q.v(4);  % Note: indexing from 1, not 0!
            R=[q0^2+q1^2-q2^2-q3^2  2*(q1*q2-q0*q3)  2*(q1*q3+q0*q2);
               2*(q1*q2+q0*q3)  q0^2-q1^2+q2^2-q3^2  2*(q2*q3-q0*q1);
               2*(q1*q3-q0*q2)  2*(q2*q3+q0*q1)  q0^2-q1^2-q2^2+q3^2];
        end
        function test_rot_seq_from_q(q)
        % This routine tests all 12 rotation sequences, converting from q to r and back to q.
        % To run this test on random q, for example, call as follows:
        % u=rand(3,1); u=u/norm(u); phi=pi*randn; q=RR_quaternion(u,phi), test_rot_seq_from_q(q)
        % Try also, e.g., u=[1e-9 1e-9 1] in the above test (this breaks conversions not done carefully!)
            seq=[1 2 3; 1 3 2; 2 1 3; 2 3 1; 3 1 2; 3 2 1; ...  % Tait-Bryan rotations
                 1 2 1; 1 3 1; 2 1 2; 2 3 2; 3 1 3; 3 2 3];     % Euler rotations
            for i=1:12
                r =RR_rotation_sequence(seq(i,:),q);  % Determine corresponding rotation sequence
                q1=RR_quaternion(r);                  % Convert back to the corresponding quaternion
                error=norm(q-q1)                      % quantify the error
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
