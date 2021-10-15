syms c1 s1 c2 s2 c3 s3 adot bdot gdot
G23gamma=[1 0 0; 0 c3 s3; 0 -s3 c3];
G31beta =[c2 0 -s2; 0 1 0; s2 0 c2];
G12alpha=[c1 s1 0; -s1 c1 0; 0 0 1];
G23gamma*G31beta*[0;0;adot]+G23gamma*[0;bdot;0]+[gdot;0;0]

T321=[1 0 -s2; 0 c3 s3*c2; 0 -s3 c3*c2]
inv(T321)

G12gamma=[c3 s3 0; -s3 c3 0; 0 0 1];
G23beta =[1 0 0; 0 c2 s2; 0 -s2 c2];
G12alpha=[c1 s1 0; -s1 c1 0; 0 0 1];
G12gamma*G23beta*[0;0;adot]+G12gamma*[bdot;0;0]+[0;0;gdot]

T313=[c3 s3*s2 0; -s3 c3*s2 0; 0 c2 1]
inv(T313)