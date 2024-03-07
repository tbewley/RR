function f=RHS_PredatorPrey(y,p)                     % Numerical Renaissance Codebase 1.0
f=[(p.b-p.p*y(2))*y(1); (p.r*y(1)-p.d)*y(2)];
end % function RHS_PredatorPrey.m