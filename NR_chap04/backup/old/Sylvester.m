function X=RC_Sylvester(A,B,C,g,m,n)                    % Numerical Renaissance Codebase 1.0
% This function finds the X=X_(mxn) that satisfies A X - X B = g C, where A=A_(mxm),
% B=B_(nxn), and C=C_(mxn) are full and g is a scaler with 0 < g <= 1.
[U,A0]=RC_Schur(A); [V,B0]=RC_Schur(B); C0=U'*C*V; X0=RC_SylvesterTri(A0,B0,C0,g,m,n); X=U*X0*V';
end % function RC_Sylvester.m