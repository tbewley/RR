function [r,y,t]=RR_Response_TF(gs,fs,type,g)
% function [r,y,t]=RR_Response_TF(gs,fs,type,g)
% Using its partial fraction expansion, compute the response Y(s)=T(s)*R(s) of a
% CT SISO linear system T(s)=gs(s)/fs(s) to an impulse (type=0), step (type=1),
% or quadratic (type=2) input.  The derived type g groups together convenient
% plotting parameters: g.T is the interval over which response is plotted,
% g.N is the number of timesteps, and {g.styleu,g.styley} are the linestyles used.
% Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.
% Depends on <a href="matlab:help PartialFractionExpansion">PartialFractionExpansion</a>, <a href="matlab:help Fac">Fac</a>.  Verify with: <a href="matlab:help ResponseTFtest">ResponseTFtest</a>.

numR=Fac(type-1); denR=1; for i=1:type, denR=[denR 0]; end,  gs=gs/fs(1);
[rp,rd,rk]=PartialFractionExpansion(numR,denR);              fs=fs/fs(1);
[yp,yd,yk]=PartialFractionExpansion(PolyConv(numR,gs),PolyConv(denR,fs));
h=g.T/g.N; t=[0:g.N]*h;
for k=1:g.N+1
  if type>0, r(k)=real(sum(rd.*(t(k).^(rk-1).*exp(rp*t(k))))); else, r(k)=0; end
             y(k)=real(sum(yd.*(t(k).^(yk-1).*exp(yp*t(k)))));
end
if nargout==0,
   plot(t,y,g.styley), axis tight, if type>0, hold on; plot(t,r,g.styler), hold off; end
end