function s=RR_chord_division_for_uniform_arc_length(a,b,N,omega)
% Compute the fractional points along along a chord for the resulting projection of the chord
% onto the unit sphere to be divided up into N equal arc lengths.
% INPUTS: a,b = 3D vectors, assumed to be on a sphere, between which lies the chord.
%         N   = number of segments that you want the projection of the chord onto the sphere
%               to be evenly divided into.
%         omega = extent of "overstretching" applied (omega=1 for normal stretching)
% OUTPUT: s   = vector of length N-1, indicating the fractional points along the chord where the
%               intermediate points should lie, at x(i)=s(i)*a+(1-s(i))*b for i=1,...,N-1
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Packings)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

% move first point to the equator, and locate second point a distance L away on the equator
% note omega=extent of "overstretching" applied (omega=1 for normal stretching)
% note: the formula below works only for L<1/2, so it doesn't work on a tetrahedron...
L=omega*norm(a-b)/norm(a);
theta=2*asin(L/2); first=[1;0]; second=[cos(theta); sin(theta)]; origin=[0;0];
for i=1:N-1
   phi=i*theta/N; new=[cos(phi); sin(phi)];
   intersection=RR_line_intersection(first,second,origin,new);
   s(i)=norm(intersection-first)/L;
end
end % function RR_chord_division_for_uniform_arc_length
