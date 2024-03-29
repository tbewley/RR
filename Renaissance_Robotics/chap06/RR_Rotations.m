
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 6)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

syms c1 s1 c2 s2 c3 s3

R1=[c1 s1 0; -s1 c1 0; 0 0 1];
R2=[1 0 0; 0 c2 s2; 0 -s2 c2];
R3=[c3 s3 0; -s3 c3 0; 0 0 1];

R313=R3*R2*R1

R1=[c1 s1 0; -s1 c1 0; 0 0 1];
R2=[c2 0 -s2; 0 1 0; s2 0 c2];
R3=[1 0 0; 0 c3 s3; 0 -s3 c3];

R321=R3*R2*R1