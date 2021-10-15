% script <a href="matlab:ResponseTFtest">ResponseTFtest</a>
% Test <a href="matlab:help ResponseTF">ResponseTF</a> by plotting the impulse, step, and ramp response of an oscillatory system.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 17.1.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.

numG=[1 .3]; denG=[1 12 20 0 0]; g.T=200; g.styleu='r--'; g.styley='b-'; 
[numH,denH]=Feedback(numG,denG) 
figure(4); clf; ResponseTF(numH,denH,0,g); title('Impulse response')
figure(5); clf; ResponseTF(numH,denH,1,g); title('Step response')
figure(6); clf; ResponseTF(numH,denH,2,g); title('Ramp response')
figure(7); clf; ResponseTF(numH,denH,3,g); title('Response to quadratic')

% end script ResponseTFtest
