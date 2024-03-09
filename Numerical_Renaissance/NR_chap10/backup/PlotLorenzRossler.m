function PlotLorenzRossler(xo,xn,to,tn,ho,hn,v)                         % PLOTTING ROUTINE 
figure(1), plot3([xo(1) xn(1)],[xo(2) xn(2)],[xo(3) xn(3)]), title(sprintf('t=%d',tn))
axis equal, if v==2, figure(2), plot([to, tn],[ho hn]), hold on, end, pause(0.00001)
end % function PlotLorenzRossler
