% classdef RR_rotation_sequence
% This class defines an INTRINSIC rotation sequence class, and a standard set of operations using it.
% Any of the 6 Tait-Bryan or 6 Euler rotation sequences are allowed.
% DEFINITION:
%   The command r=RR_rotation_sequence([axes(1) axes(2) axes(3)],data) generates
%   an RR_rotation_sequence object with the following fields:
%      r.ax = a row vector with 3 integers defining the rotation sequence
%      r.an = a row vector with 3 angles, in degrees (!), referred to as [alpha beta gamma], and
%      r.at = a string naming the type of rotation sequence this is ('Tait-Bryan' or 'Euler')
%   Note that -180<alpha<=180 and -180<gamma<=180.
%   For Tait-Bryan rotation sequences, -90<=beta<=90.  For Euler rotation sequences, 0<=beta<=180.
%   When executing the RR_rotation_sequence command, "data" can be any of the following:
%       a row matrix with three angles [alpha, beta, gamma], or
%       a unit quaternion object q, of type RR_quaternion, or
%       a 3x3 matrix, of unit determinant, representing a rotation matrix.
% FUNCTIONS DEFINED:
%   a = rotate(a,r)        rotates a (column) vector a using a RR_rotation_sequence object r
%   R = rotation_matrix(r) generates a rotation matrix R equivalent to the R_rotation_sequence object r
% SOME SIMPLE TESTS:
%   a =rand(3,1)                                 % a random initial (column) vector to be rotated
%   an=floor(90*rand(1,3));                      % a row vector with three random angles
%   r1=RR_rotation_sequence([3 2 1],an)          % a 321 Tait-Bryan rotation with random angles
%   r2=RR_rotation_sequence([1 2 3],-an(3:-1:1)) % a 123 Tait-Bryan rotation with the opposite angles
%   b =rotate(a,r1), a1=rotate(b,r2)             % rotate a to b, then rotate back.
% Renaissance Robotics codebase, Chapter 7, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License.
% See also RR_quaternion.

classdef RR_rotation_sequence < matlab.mixin.CustomDisplay
    properties  % Each RR_rotation_sequence object consists of three fields:
        ax      % a row vector with 3 integers defining the rotation sequence
        an      % a row vector with 3 angles, in degrees (!), referred to as [alpha beta gamma]
        t       % a string naming the type of rotation sequence this is
     end
    methods
        function r = RR_rotation_sequence(ax,data)        % Define a rotation sequence
            r.ax=ax; ax_triple=ax(1)*100+ax(2)*10+ax(3);  % r.ax=[ax(1) ax(2) ax(3)]
            switch ax_triple
                case {123,132,213,231,312,321}, r.t='Tait-Bryan';
                case {121,131,212,232,313,323}, r.t='Euler';
                otherwise, error('Invalid rotation sequence axes')
            end
            if sum(size(data)==[1 3])==2, r.an=data; return, end % r.an=[data(1) data(2) data(3)]=[alpha beta gamma]
            if isa(data,'RR_quaternion')       % generate rotation sequence from unit quaternion
                R=rotation_matrix(data); q1=data.v(2); q2=data.v(3); q3=data.v(4);  
                switch ax_triple
                    case {121,131}, flag=(q2^2+q3^2<1e-17);
                    case {212,232}, flag=(q1^2+q3^2<1e-17);
                    case {313,323}, flag=(q1^2+q2^2<1e-17);
                end
            elseif sum(size(data)==[3 3])==2   % generate rotation sequence from rotation matrix
                R=data, if abs(det(R)-1)>1e-8, error('rotation matrix not of unit determinant; not valid for rotation!'), end  
                switch ax_triple
                    case {121,131}, flag=(R(1,1)>1-(1e-13));
                    case {212,232}, flag=(R(2,2)>1-(1e-13));
                    case {313,323}, flag=(R(3,3)>1-(1e-13));
                end
            else, error('Invalid input data to generate rotation sequence')
            end
            switch ax_triple                   % now process both quaternion and rotation matrix inputs
                % Formulae below from https://en.wikipedia.org/wiki/Euler_angles#Rotation_matrix,
                % corrected to incorporate atan2, and simpified to use asin and acos where appropriate
                % Euler rotation sequences incorporate logic to handle {c2~=1,s2~=0,gamma~=0} cases.
                case 123,
                    alpha=atan2(-R(2,3),R(3,3));  beta=asin( R(1,3)); gamma=atan2(-R(1,2),R(1,1));
                case 132,
                    alpha=atan2( R(3,2),R(2,2));  beta=asin(-R(1,2)); gamma=atan2( R(1,3),R(1,1));
                case 213,
                    alpha=atan2( R(1,3),R(3,3));  beta=asin(-R(2,3)); gamma=atan2( R(2,1),R(2,2));
                case 231,
                    alpha=atan2(-R(3,1),R(1,1));  beta=asin( R(2,1)); gamma=atan2(-R(2,3),R(2,2));
                case 312,
                    alpha=atan2(-R(1,2),R(2,2));  beta=asin( R(3,2)); gamma=atan2(-R(3,1),R(3,3));
                case 321,
                    alpha=atan2( R(2,1),R(1,1));  beta=asin(-R(3,1)); gamma=atan2( R(3,2),R(3,3));
                case 121, beta = acos(R(1,1));
                    if flag, alpha=atan2( R(3,2), R(2,2)); gamma=0;
                    else,    alpha=atan2( R(2,1),-R(3,1)); gamma=atan2( R(1,2), R(1,3)); end
                case 131, beta = acos(R(1,1));
                    if flag, alpha=atan2(-R(2,3), R(3,3)); gamma=0;
                    else,    alpha=atan2( R(3,1), R(2,1)); gamma=atan2( R(1,3),-R(1,2)); end                    
                 case 212, beta = acos(R(2,2));
                    if flag, alpha=atan2(-R(3,1), R(1,1)); gamma=0;
                    else,    alpha=atan2( R(1,2), R(3,2)); gamma=atan2( R(2,1),-R(2,3)); end
                case 232, beta = acos(R(2,2));
                    if flag, alpha=atan2( R(1,3), R(3,3)); gamma=0;
                    else,    alpha=atan2( R(3,2),-R(1,2)); gamma=atan2( R(2,3), R(2,1)); end
                case 313, beta = acos(R(3,3));
                    if flag, alpha=atan2( R(2,1), R(1,1)); gamma=0;
                    else,    alpha=atan2( R(1,3),-R(2,3)); gamma=atan2( R(3,1), R(3,2)); end
                case 323, beta = acos(R(3,3));
                    if flag, alpha=atan2(-R(1,2), R(2,2)); gamma=0;
                    else,    alpha=atan2( R(2,3), R(1,3)); gamma=atan2( R(3,2),-R(3,1)); end
            end,  r.an=rad2deg([alpha beta gamma]);
        end
        function a = rotate(a,r)    % Rotate any column vector a by a rotation sequence r
            a=rotation_matrix(r)*a;
        end
        function R = rotation_matrix(r) % generate a rotation matrix R equivalent to a rotation sequence r    
            q=RR_quaternion(r); R=rotation_matrix(q);
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
