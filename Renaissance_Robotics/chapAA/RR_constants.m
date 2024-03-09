% script RR_constants
% Define some useful constants, including
%   e (Euler's number), phi (golden ratio), gamma (Euler–Mascheroni constant),
%   zeta3 (Apéry's constant), delta & alpha (1st & 2nd Feigenbaum constants),
%   root2, root3, ...
% and many other constants from physics (all listed in SI units) which are
% stored in a derived type named RR_PHYSICAL (including units and names).
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/RR_chapAA
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

clear
global RR_e RR_phi RR_gamma RR_zeta3 RR_delta RR_alpha RR_zeta3 RR_root2 RR_root3
global RR_PHYSICAL

% Why aren't at least some of the following in Matlab already?
% See:  https://www.mathworks.com/matlabcentral/answers/549723
RR_e    =exp(1);            % Euler's number
RR_phi  =(1+sqrt(5))/2;     % Golden ratio
RR_gamma=0.577215664901533; % Euler–Mascheroni constant
RR_zeta3=1.202056903159594; % Apéry's constant
RR_delta=4.669201609102991; % First Feigenbaum constant
RR_alpha=2.502907875095893; % Second Feigenbaum constant
RR_root2=sqrt(2);           % Pythagoras' constant
RR_root3=sqrt(3);           % Theodorus' constant

RR_PHYSICAL.c.value=2.99792458*10^8;
RR_PHYSICAL.c.units='m/s';
RR_PHYSICAL.c.name ='speed of light';

RR_PHYSICAL.c_air.value=343.2;
RR_PHYSICAL.c.units='m/s';
RR_PHYSICAL.c.name ='speed of sound in dry air at 20 deg C';

RR_PHYSICAL.AU.value=1.495978707*10^11;
RR_PHYSICAL.AU.units='m';
RR_PHYSICAL.AU.name ='astronomical unit (mean earth/sun distance)';

RR_PHYSICAL.G.value=6.67408*10^-11;
RR_PHYSICAL.G.units='N*m^2/kg^2';
RR_PHYSICAL.G.name ='universal gravitational constant';

RR_PHYSICAL.amu.value=1.67377*10^-27;
RR_PHYSICAL.amu.units='kg';
RR_PHYSICAL.amu.name ='atomic mass unit (1/12 the mass of a carbon-12 atom)';

RR_PHYSICAL.mp.value=1.67262*10^-27;
RR_PHYSICAL.mp.units='kg';
RR_PHYSICAL.mp.name ='proton mass';

RR_PHYSICAL.mn.value=1.67493*10^-27;
RR_PHYSICAL.mn.units='kg';
RR_PHYSICAL.mn.name ='neutron mass';

RR_PHYSICAL.me.value=9.10939*10^-31;
RR_PHYSICAL.me.units='kg';
RR_PHYSICAL.me.name ='electron mass';

RR_PHYSICAL.a0.value=5.29177210903*10^-11;
RR_PHYSICAL.a0.units='m';
RR_PHYSICAL.a0.name ='Bohr radius';

RR_PHYSICAL.e.value=1.602176634*10^-19;
RR_PHYSICAL.e.units='C';
RR_PHYSICAL.e.name ='charge of electron';

RR_PHYSICAL.NA.value=6.02214076*10^23;
RR_PHYSICAL.NA.units='mol^-1';
RR_PHYSICAL.NA.name ='Avogadros number';

RR_PHYSICAL.kB.value=1.380649*10^-23;
RR_PHYSICAL.kB.units='J/K';
RR_PHYSICAL.kB.name ='Boltzmann constant';

RR_PHYSICAL.h.value=6.62607015*10^-34;
RR_PHYSICAL.h.units='J*s';
RR_PHYSICAL.h.name ='Plancks constant';

RR_PHYSICAL.F.value=96485.3321;
RR_PHYSICAL.F.units='C/mol';
RR_PHYSICAL.F.name ='Faraday constant';

RR_PHYSICAL.R.value=8.31446261815324;
RR_PHYSICAL.R.units='J/K/mol';
RR_PHYSICAL.R.name ='Universal gas constant';

% Now, just a few constants relevant to Earth, Moon, Mars, Sun

RR_PHYSICAL.g_earth.value=9.81;
RR_PHYSICAL.g_earth.units='m/s^2';
RR_PHYSICAL.g_earth.name ='Earth gravitational constant';

RR_PHYSICAL.g_moon.value=1.62;
RR_PHYSICAL.g_moon.units='m/s^2';
RR_PHYSICAL.g_moon.name ='Moon gravitational constant';

RR_PHYSICAL.g_mars.value=3.71;
RR_PHYSICAL.g_mars.units='m/s^2';
RR_PHYSICAL.g_mars.name ='Mars gravitational constant';

RR_PHYSICAL.m_earth.value=5.9722*10^24;
RR_PHYSICAL.m_earth.units='kg';
RR_PHYSICAL.m_earth.name ='Earth mass';

RR_PHYSICAL.m_moon.value=7.342*10^22;
RR_PHYSICAL.m_moon.units='kg';
RR_PHYSICAL.m_moon.name ='Moon mass';

RR_PHYSICAL.m_mars.value=6.4169*10^23;
RR_PHYSICAL.m_mars.units='kg';
RR_PHYSICAL.m_mars.name ='Mars mass';

RR_PHYSICAL.m_sun.value=1.9885*10^30;
RR_PHYSICAL.m_sun.units='kg';
RR_PHYSICAL.m_sun.name ='Sun mass';

RR_PHYSICAL.r_earth.value=6.3781*10^6;
RR_PHYSICAL.r_earth.units='m';
RR_PHYSICAL.r_earth.name ='Earth equatorial radius';

RR_PHYSICAL.r_moon.value=1.7381*10^6;
RR_PHYSICAL.r_moon.units='m';
RR_PHYSICAL.r_moon.name ='Moon equatorial radius';

RR_PHYSICAL.r_mars.value=3.3962*10^6;
RR_PHYSICAL.r_mars.units='m';
RR_PHYSICAL.r_mars.name ='Mars equatorial radius';
