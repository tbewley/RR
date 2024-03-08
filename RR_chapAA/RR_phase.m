function phi=RR_phase(a)
% function phi=RR_phase(a)
% INPUT:  a   = vector of complex numbers
% OUTPUT: phi = vector of phase of the complex numbers in a, adjusted so that a plot
%               of the phase (as in a Bode plot) makes as few discontinuous jumps as possible
% TEST:   om = logspace(-2,2,100); s=i*om; G=(s.^2+s+100)./(100*(s+.1).*(s.^2+2*0.1*s+1));
%         phi=RR_phase(G); semilogx(om,phi*180/pi) 
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chapAA
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

phi=atan2(imag(a),real(a));
for i=2:length(a)
  while phi(i)>phi(i-1)+pi, phi(i)=phi(i)-2*pi; end
  while phi(i)<phi(i-1)-pi, phi(i)=phi(i)+2*pi; end
end
end % function RR_phase
