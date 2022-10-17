% classdef RR_rotation_sequence
% This class defines an INTRINSIC rotation sequence class, and a standard set of operations over it.
% Any of the 6 Tait-Bryan or 6 Euler rotation sequences are allowed.
% DEFINITION:
%   q=RR_rotation_sequence([axes(1) axes(2) axes(3)],[alpha beta gamma])  defines an RR_rotation_sequence object
% OPERATIONS (overloading the ? operators):
%   rotation_matrix(q): compute the rotation matrix equivalent to p
% SOME TESTS:
%   a=rand(3,1)                                            % a = a random 3D initial vector to be rotated
%   r = RR_rotation_sequence([3 2 1],floor(90*rand(1,3)))  % a 321 Tait-Bryan rotation with random angles
% Renaissance Robotics codebase, Chapter 7, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License.

classdef RR_rotation_sequence < matlab.mixin.CustomDisplay
    properties  % Each RR_rotation_sequence object consists of three fields:
        ax      % a row vector with 3 integers defining the rotation sequence
        an      % a row vector with 3 angles, in degrees (!), referred to as [alpha beta gamma]
        t       % a string naming the type of rotation sequence this is
     end
    methods
        function r = RR_rotation_sequence(ax,an)  % Define a rotation sequence
            r.ax=ax;  % r.ax=[ax(1) ax(2) ax(3)]
            r.an=an;  % r.an=[an(1) an(2) an(3)]=[alpha beta gamma]
            switch ax(1)*100+ax(2)*10+ax(3)
                case {123,132,213,231,312,321}, r.t='Tait-Bryan';
                case {121,131,212,232,313,323}, r.t='Euler';
                otherwise, error('Invalid rotation sequence axes')
            end
        end
        function a = rotate(a,r)    % Rotate any vector a by a rotation sequence r
            a=rotation_matrix(r)*a;
        end
        function q = quaternion(r)  % Convert rotation sequence r to corresponding quaternion q
            t=deg2rad(r.an); alpha=t(1); beta=t(2); gamma=t(3);
            q1=RR_quaternion([cos(alpha/2)]); q2=RR_quaternion([cos(beta/2)]); q3=RR_quaternion([cos(gamma/2)]);
            q1=q1+ e(r.ax(1))*sin(alpha/2);   q2=q2+ e(r.ax(2))*sin(beta/2);   q3=q3+ e(r.ax(3))*sin(gamma/2);
            q=q1*q2*q3;
            function out=e(i), out=[0 0 0 0]; out(1+i)=1; end  % Defines a useful unit vector for this function
        end
        function R = rotation_matrix(r)  % Convert rotation sequence r to corresponding rotation_matrix R    
            q=quaternion(r); R=rotation_matrix(q);
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods(Access = protected)
        function displayScalarObject(r)
            fprintf(getHeader(r))
            fprintf('%g %s rotation with [alpha,beta,gamma]= ', ...
                 r.ax(1)*100+r.ax(2)*10+r.ax(3),r.t), disp(r.an)
        end
    end
end
