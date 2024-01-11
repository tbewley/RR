% script <a href="matlab:ResponseTFdtTest">ResponseTFdtTest</a>
% Test <a href="matlab:help ResponseTFdt">ResponseTFdt</a> by plotting various responses of an oscillatory system T(z)=gz(z)/fz(z).
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 17.1.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.

clear; close all; r=.9; theta=pi/10; a0=r^2; a1=-2*r*cos(theta);
gz=1+a1+a0; fz=[1 a1 a0]; g.T=60; g.h=1; g.styler='r--'; g.styley='b*-';
figure,         ResponseTFdt(gz,fz,0,g); title('Impulse response')
figure, [r,y,k]=ResponseTFdt(gz,fz,1,g), title('Step response')
figure,         ResponseTFdt(gz,fz,2,g); title('Ramp response')
figure,         ResponseTFdt(gz,fz,3,g); title('Response to quadratic')

% end script ResponseTFdtTest
