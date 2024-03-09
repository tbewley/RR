function p=Conv(g,d)                                 % Numerical Renaissance Codebase 1.0
n=length(d); m=length(g); p=zeros(1,n+m-1);
for i=0:n-1; p=p+[zeros(1,n-1-i) d(n-i)*g zeros(1,i)]; end
end % function Conv.m