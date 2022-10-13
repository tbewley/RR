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
                switch length(u), case 1, q.v=[u 0 0 0];
                                  case 3, q.v=[ 0   u(1) u(2) u(3)];
                                  case 4, q.v=[u(1) u(2) u(3) u(4)];
                                  otherwise, error('input vector wrong size')
                end
            else                           % two arguments: create q = e^(u*phi)
                 c=cos(phi); s=sin(phi); q.v=[c s*u(1) s*u(2) s*u(3)];
            end
        end
        function p = plus(p,q),     [p,q]=check(p,q); p.v=p.v+q.v;  end  % p+q
        function p = minus(p,q),    [p,q]=check(p,q); p.v=p.v-q.v;  end  % p-q
        function p = mrdivide(p,q), [p,q]=check(p,q); p.v=p*inv(q); end  % p/q = p*inv(q)
        function p = mldivide(p,q), [p,q]=check(p,q); p.v=inv(p)*q; end  % p\q = inv(p)*q
        function p = mtimes(p,q),   [p,q]=check(p,q); t=p.v;           % p*q
               P=[ t(1) -t(2) -t(3) -t(4);
                   t(2)  t(1) -t(4)  t(3);  % Note: indexing from 1, not 0!
                   t(3)  t(4)  t(1) -t(2);
                   t(4) -t(3)  t(2)  t(1)]; p=RR_quaternion(P*q.v.');
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
        function p = inv(p),      p=p'/(norm(p))^2;           end
        function b = rotate(a,q), [t,q]=check(a,q); t=q*t*q'; b=[t.v(2); t.v(3); t.v(4)]; end
        function R = rotation_matrix(q)      
            t=q.v;                              % Note: indexing from 1, not 0!
            R=[t(1)^2+t(2)^2-t(3)^2-t(4)^2  2*(t(2)*t(3)-t(1)*t(4))  2*(t(2)*t(4)+t(1)*t(3));
               2*(t(2)*t(3)+t(1)*t(4))  t(1)^2-t(2)^2+t(3)^2-t(4)^2  2*(t(3)*t(4)-t(1)*t(2));
               2*(t(2)*t(4)-t(1)*t(3))  2*(t(3)*t(4)+t(1)*t(2))  t(1)^2-t(2)^2-t(3)^2+t(4)^2];
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
