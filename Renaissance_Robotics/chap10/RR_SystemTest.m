function TestSystem(numG,denG,numD,denD,g)
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/RR_chap10
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

num=PolyConv(numG,numD); den=PolyConv(denG,denD); num=[zeros(1,length(den)-length(num)) num];
figure(1); RLocus(numG,denG,numD,denD,g); figure(2); Bode(num,den,g)
numH=num; denH=num+den; if g.fix, outer_gain=denH(end)/numH(end); else, outer_gain=1; end
if g.verbose, outer_gain, numH, denH, CL_zeros=Roots(numH)', CL_poles=Roots(denH)'; end
figure(3); [A,B,C,D]=TF2SS(outer_gain*numH,denH); Response(A,B,C,D,1,g); % Step
axis(g.steprange); hold on; plot([0 g.T],[1 1],'k:'); hold off;           
figure(4); Bode(outer_gain*numH,denH,g);
end % function TestSystem
