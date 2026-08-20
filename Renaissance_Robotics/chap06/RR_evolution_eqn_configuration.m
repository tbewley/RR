syms a(t) b(t) g(t)
disp('321')
A1=[1 0 -sin(b(t)); 0 cos(g(t)) sin(g(t))*cos(b(t)); 0 -sin(g(t)) cos(g(t))*cos(b(t))]
A2=simplify(inv(A1))
dA2dt=simplify(diff(A2,t))
disp(' '), pause

disp('313')
A1=[sin(g(t))*sin(b(t)) cos(g(t)) 0;cos(g(t))*sin(b(t)) -sin(g(t)) 0;cos(b(t)) 0 1]
A2=simplify(inv(A1))
dA2dt=simplify(diff(A2,t))
