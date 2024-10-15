function d=quat_def_rotation(phi,u)
% Define a roation quaternion based on an angle phi and vector u about which to rotate.
d=[cos(phi/2) u(1)*sin(phi/2) u(2)*sin(phi/2) u(3)*sin(phi/2)];
end % function quat_def_rotation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
