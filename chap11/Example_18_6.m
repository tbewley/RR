function Example_18_6
close all;
A= [0 0 1 0 0; 0 0 .199 1 0; 0 -.002 -.194 -.167 .748;
    0 -.003 .636 -2.020 -5.374; 0 .136  -.970 .198 -.148];
B= [0 0; 0 0; .053 -.74; .865 .904; .002 .047]; C=eye(5); D=zeros(5,2);
ShowSys(A,B,C,D), g.T=15; g.styleu='b-';
g.styley='k--'; ResponseSS(A,B,C,D,-1,g,@AileronDoublet);
g.styley='r-';  ResponseSS(A,B,C,D,-1,g,@AileronDoubletWithRudderCorrection);
end % function Example_18_6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [u]=AileronDoublet(t)
if t<=1, u(1,1)=1; elseif (t>5 & t<=6), u(1,1)=-1; else, u(1,1)=0; end; u(2,1)=0;
end % function AileronDoublet
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [u]=AileronDoubletWithRudderCorrection(t)
if t<=1, u(1,1)=1; elseif (t>5 & t<=6), u(1,1)=-1; else, u(1,1)=0; end; u(2,1)=-.1*u(1,1);
end % function AileronDoubletWithRudderCorrection


