function ResponseTFripple(bs,as,yz,xz,h,type,g)
% function ResponseTFripple(bs,as,yz,xz,h,type,g)
% Plot the intersample ripple resulting when a CT plant G(s)=bs(s)/as(s) is controlled by
% DT controller D(z)=yz(z)/xz(z).

% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 18.?
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 18</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help ResponseTFrippleTest">ResponseTFrippleTest</a>.

[bz,az]=C2Dzoh(bs,as,h); [gz,fz]=Feedback(PolyConv(bz,yz),PolyConv(az,xz)), g.h=h;
g.styler='r+--'; g.styley='bo'; subplot(2,1,1); ResponseTFdt(gz,fz,1,g); hold on

[numSu,denSu]=RationalSimplify(PolyConv(az,yz),PolyAdd(PolyConv(az,xz),PolyConv(bz,yz))),
subplot(2,1,2); g.styley='bo'; g.styler='w--'; [rz,uz,tz]=ResponseTFdt(numSu,denSu,1,g);
hold on, plot([0 g.T],[0 0],'k--')

c=50; g.N=c*g.T/g.h; subplot(2,1,1), title(g.t), [u,y,t]=ResponseTF(bs,as,type,g);
f=uz(1); us=u*f; ys=y*f; imax=length(uz);
for i=2:imax; f=uz(i)-uz(i-1); s=1+(i-1)*c;
    us(s:end)=us(s:end)+f*u(1:end-s+1); ys(s:end)=ys(s:end)+f*y(1:end-s+1);
end, subplot(2,1,1), plot(t,ys,'b-'), subplot(2,1,2), plot(t,us,'b-')

end % function ResponseTFripple
