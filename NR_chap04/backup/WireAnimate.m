function WireAnimate(Ds,Vs,X,n,DeltaX)
omega=sqrt(-Ds); maxframes=400; tmax=8; m1=2;  a1=0.95/max(abs(Vs(:,m1)));           
for t=0:tmax/maxframes:tmax             % First, animate a single mode.
   plot(X,a1*[0 Vs(:,m1)' 0]*sin(omega(m1)*t) ); axis([0 1 -1 1]); pause(0.01);
end; pause;
m1=2;  a1=0.5/max(abs(Vs(:,m1)));   m2=3;  a2=0.5/max(abs(Vs(:,m2)));
for t=0:tmax/maxframes:tmax             % Then, animate a linear combination of two modes.
   plot(X,a1*[0 Vs(:,m1)' 0]*sin(omega(m1)*t) + a2*[0 Vs(:,m2)' 0]*sin(omega(m2)*t));
   axis([0 1 -1 1]); pause(0.01);
end; pause;
imax=round(n/3); fmax=0.95;                          % Finally, animate a combination of
for i=0:imax;   c(i+1)=fmax*i/imax;         end      % modes which add up to an initially
for i=imax+1:n; c(i+1)=fmax*(n-i)/(n-imax); end      % plucked wire with zero velocity
for k=1:n-1                                          % and a triangular initial shape.
  fac = [0 Vs(:,k)' 0] * [0 Vs(:,k)' 0]' * DeltaX;
  chat(k) = (1/fac) * ( [0 Vs(:,k)' 0] * c' ) * DeltaX;
end
for t=0:tmax/maxframes:tmax
   shape=0.; for k=1:n-1; shape=shape+chat(k)*[0 Vs(:,k)' 0]*cos(omega(k)*t); end 
   plot(X,shape); axis([0 1 -1 1]); pause(0.01);
end;
% end function WireAnimate.m
