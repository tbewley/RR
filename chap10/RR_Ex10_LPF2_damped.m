% script RR_Ex10_LPF2_damped
% This code implements the equations of a damped 2nd-order LPF,
% as discussed in problems 1-4 of the 2023 HW1 in MAE40.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under Modified BSD License. 

% pkg load symbolic  % uncomment this line if running in octave

clear, clc, close all
disp('PROBLEM 1: LPF2 damped with Rd between Vo and GND.')
syms s L C Rd Cd Vi  % <- Laplace symbol s, parameters, and input Vi
% x=[Il; Ic; Id; Vo]   <- unknown vector   
A  =[ 1  -1  -1   0;     % Il -Ic -Id          = 0
     L*s  0   0   1;     % L*s*Il         + Vo = Vi
      0  -1   0  C*s;    %    -Ic     + C*s*Vo = 0
      0   0  -Rd  1];    %         -Rd*Id + Vo = 0
b  =[ 0; Vi;  0;  0];
x=A\b; Vo_LPF2_Rd=simplify(x(4)), pause
% DISCUSSION:
% => Vo(s)/Vi(s) = Rd / (C*L*Rd*s^2 + L*s + Rd)
%                = 1/(L*C) / ( s^2 + s/(C*Rd) + 1/(L*C) )
%                = omega^2 / ( s^2 + 2*zeta*omega*s + omega^2 )
% where omega=1/sqrt(L*C) and thus
% 1/(C*Rd)=2*zeta*omega  => zeta=sqrt(L/C)/(2*Rd)
    
disp('PROBLEM 2: Bode plot of filter in prob 1.')
figure(1), omega=10, for i=1:3
   switch i, case 1; zeta=0.1, g.linestyle='k-';  % note: different linestyles
             case 2; zeta=0.7, g.linestyle='k-.'; % for the different zetas
             case 3; zeta=1.0, g.linestyle='k--';  end
   F_LPF2_Rd=RR_tf([omega^2],[1 2*zeta*omega omega^2]);        
   RR_bode(F_LPF2_Rd,g), pause
end

disp('PROBLEM 3: LPF2 damped with Rd in series with Cd between Vo and GND.')
% x=[Il; Ic; Id; Vo, V1]   <- unknown vector   
A  =[ 1  -1  -1   0   0;     % Il -Ic -Id                = 0
     L*s  0   0   1   0;     % L*s*Il          +Vo       = Vi
      0  -1   0  C*s  0;     %    -Ic      +C*s*Vo       = 0
      0   0  -Rd  1  -1;     %         -Rd*Id  +Vo   -V1 = 0
      0   0  -1   0 Cd*s];   %            -Id  + Cd*s*V1 = 0
b  =[ 0; Vi;  0;  0;  0];
x=A\b; Vo_LPF2_Rd_Cd=simplify(x(4))
% DISCUSSION:
% => Vo(s)/Vi(s) = (Cd*Rd*s+1)/( L*C*Cd*Rd*s^3 +(C+Cd)*L*s^2 +  Cd*Rd*s + 1)
%                = (s+om)*omega^2/(s^3 + ((C+Cd)/C)*om*s^2 + omega^2*s + om*omega^2)
% where omega=1/sqrt(L*C) and om=1/(Cd*Rd)
% Note: damping goes to zero as om->0, or as Cd*Rd->inf
pause

disp('PROBLEM 4: Substitute Cd=4*C and Rd=sqrt(L/C) in prob 3, simplify, and make Bode plot')
% DISCUSSION: Taking Cd=4*C and Rd=sqrt(L/C) gives om=1/(4*C*sqrt(L/C))=omega/4, and thus
% => Vo(s)/Vi(s) = (s+omega/4)*omega^2/(s^3 + (5/4)*omega*s^2 + omega^2*s + omega^3/4)
omega=10;
F_LPF2_Rd_Cd=RR_tf(omega^2*[1 omega/4],[1 (5/4)*omega omega^2 omega^3/4])
g.linestyle='r-'; RR_bode(F_LPF2_Rd_Cd)   % note: new Bode plot in red
