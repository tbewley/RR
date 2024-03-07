function [m]=RC_TF2Markov(b,a)
% function [m]=RC_TF2Markov(b,a)
% Compute the first n Markov parameters of a DT or CT SISO system in TF form.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.3.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help RC_TF2MarkovTest">RC_TF2MarkovTest</a>.

n=length(a); m=length(b); b=[zeros(1,n-m) b]; u=[1; zeros(n-1,1)]; y=zeros(n,1);
for k=1:n, y(2:n)=y(1:n-1); y(1)=b*u-a(1,2:n)*y(2:n,1); u=[0; u(1:n-1)]; end; m=y(n:-1:1);
end % function RC_TF2Markov
