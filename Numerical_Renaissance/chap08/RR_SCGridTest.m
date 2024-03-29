% script <a href="matlab:RR_SCGridTest">RR_SCGridTest</a>
% Test <a href="matlab:help RR_SCGrid">RR_SCGrid</a> by producing a C-grid, an O-grid, and an H-grid around a NACA0012 airfoil.
% Renaissance Codebase, Appendix B, https://github.com/tbewley/RC
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 
% See also RR_CMGridTest.  Depends on RR_OrthGrid.

clear; close all; cin=-1; cout=2; 
c=[0.000000+0.000000*i,0.000600+0.004318*i,0.001248+0.006198*i,0.001947+0.007713*i,...
   0.002702+0.009054*i,0.003518+0.010297*i,0.004398+0.011477*i,0.005348+0.012617*i,...
   0.006374+0.013732*i,0.007482+0.014831*i,0.008678+0.015923*i,0.009969+0.017012*i,...
   0.011363+0.018103*i,0.012868+0.019200*i,0.014493+0.020306*i,0.016247+0.021423*i,...
   0.018141+0.022554*i,0.020186+0.023699*i,0.022394+0.024861*i,0.024777+0.026041*i,...
   0.027351+0.027239*i,0.030129+0.028457*i,0.033129+0.029694*i,0.036368+0.030952*i,...
   0.039865+0.032229*i,0.043640+0.033527*i,0.047716+0.034843*i,0.052117+0.036178*i,...
   0.056868+0.037530*i,0.061997+0.038897*i,0.067535+0.040278*i,0.073514+0.041668*i,...
   0.079970+0.043066*i,0.086939+0.044467*i,0.094464+0.045866*i,0.102588+0.047259*i,...
   0.111359+0.048638*i,0.120829+0.049996*i,0.131053+0.051324*i,0.142092+0.052613*i,...
   0.154009+0.053851*i,0.166876+0.055026*i,0.180768+0.056122*i,0.195766+0.057124*i,...
   0.211959+0.058013*i,0.229441+0.058769*i,0.248316+0.059369*i,0.268695+0.059788*i,...
   0.290696+0.059998*i,0.314450+0.059970*i,0.340096+0.059671*i,0.367785+0.059065*i,...
   0.397679+0.058116*i,0.429954+0.056782*i,0.464800+0.055021*i,0.502422+0.052787*i,...
   0.543040+0.050030*i,0.586893+0.046696*i,0.634239+0.042726*i,0.685356+0.038049*i,...
   0.740545+0.032581*i,0.800129+0.026217*i,0.864459+0.018812*i,0.933914+0.010170*i,...
   0.970000+0.005400*i,0.990000+0.002200*i,1.000000+0.000000*i];
n=length(c); i1=1; i2=n; x=real(c);  

g.x0=-.1; g.x1=1.2; g.y1=.4; II=51; JJ=16; steps=25;
z=RR_OrthGrid(II,JJ,'Cartesian',g,0,0,0,0);
w=RR_SCGrid(c,n,cin,cout,i1,i2,x,steps,z,II,JJ);
RR_Plot2DMesh(z,1,II,JJ); RR_Plot2DMesh(w,2,II,JJ); hold on; RR_Plot2DMesh(conj(w),2,II,JJ);
print -depsc naca0012_hgrid.eps; pause(0.1);

g.x0=0; g.x1=1.2; g.y1=.3; II=55; JJ=16; steps=15;
z=RR_OrthGrid(II,JJ,'ConfocalParabola',g,0,0,0,0);
w=RR_SCGrid(c,n,cin,cout,i1,i2,x,steps,z,II,JJ);
RR_Plot2DMesh(z,3,II,JJ); RR_Plot2DMesh(w,4,II,JJ); hold on; RR_Plot2DMesh(conj(w),4,II,JJ);
print -depsc naca0012_cgrid.eps; pause(0.1);

g.y1=0.84; II=20; JJ=24; steps=10;
z=RR_OrthGrid(II,JJ,'EllipseHyperbola',g,1,1,0,0); z=(z+1)/2;
w=RR_SCGrid(c,n,cin,cout,i1,i2,x,steps,z,II,JJ);
RR_Plot2DMesh(z,5,II,JJ); RR_Plot2DMesh(w,6,II,JJ); hold on; RR_Plot2DMesh(conj(w),6,II,JJ);
print -depsc naca0012_ogrid.eps;

% end script RR_SCGridTest