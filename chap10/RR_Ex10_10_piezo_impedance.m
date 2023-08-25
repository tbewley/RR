% script RR_Ex10_10_piezo_impedance
% Camputes the impedence of a Butterworth/van Dyke circuit model of a piezo.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Capyright 2023 by Thomas Bewley, distributed under Modified BSD License.

% pkg load symbolic  % uncomment this line if running in octave

% Set up Ax=b yourself...
clear; syms s Ca Cb R L Iin;      % <- list constants
% Iupper Ilower Vin Va  Vb          <- list unknowns
A=[ 1      0  -s*Ca  0   0;  % Iupper    -s*Ca*Vi         = 0  <- list eqns in Ax=b form
    0      1  -s*Cb s*Cb 0;  %   Ilower -s*Cb*Vi +s*Cb*Va = 0
    0     s*L    0  -1   1;  %   s*L*Ilower       -Va +Vb = 0     
    0      R     0   0  -1;  %   R*Ilower             -Vb = 0
    1      1     0   0   0]; % Iupper +Ilower             = Iin 
b=[0; 0; 0; 0; Iin]; x=A\b; % solve
Fpiezo1=simplify(x(3)/Iin)  % Impedence of piezo = Vin/Iin

% ... or have "solve" do the reorganization work for you - easier!
clear; syms s Ca Cb R L Iin;  % <- Laplace variable s, parameters, input Iin
syms Iupper Ilower Vin Va Vb  % <- unknown variables (output is Vin)
eqn1= Iupper == Ca*s*Vin;        % capacitor a eqn
eqn2= Ilower == Cb*s*(Vin-Va);   % capacitor b eqn
eqn3=  Va-Vb == L*s*Ilower;      % inductor eqn
eqn4=     Vb == R*Ilower;        % resistor eqn
eqn5=    Iin == Iupper + Ilower; % KCL
sol=solve(eqn1,eqn2,eqn3,eqn4,eqn5,Iupper,Ilower,Vin,Va,Vb); % solve!
Fpiezo2=simplify(sol.Vin/Iin)    % Impedence of piezo = Vin/Iin

for crystal=1:2
   switch crystal
      case 1
         Ca=  2e-9;
         Cb=0.5e-9;
         L=  5e-6;
         R=   1;
         g.log_omega_min=log10(4.99e5);
         g.log_omega_max=7;
         g.omega_N=3000;
         g.Hz=true;
      case 2         % 5.6 MHz Quartz oscillator
         Ca=   1e-12;
         Cb=   4e-15;
         L= 200e-3;
         R=   50;
         g.log_omega_min=log10(5.5499e6);
         g.log_omega_max=log10(5.7e6);
         g.omega_N=3000;
         g.Hz=true;
   end

   omega_r =1/sqrt(L*Cb);  omega_r_Hz=omega_r/(2*pi),  zeta_r=R/(2*omega_r*L);
   Ca      =Ca*Cb/(Ca+Cb);
   omega_a =1/sqrt(L*Ca);  omega_a_Hz=omega_a/(2*pi),  zeta_a=R/(2*omega_a*L);
   K=1/Ca;

   figure(crystal), clf
   G=RR_tf(K*[1 2*zeta_r*omega_r omega_r^2],[1 2*zeta_a*omega_a omega_a^2 0]);
   RR_bode(G,g)
end
