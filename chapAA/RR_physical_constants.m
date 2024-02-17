% script RR_physical_constants
% Define some useful physical constants in SI
% Results are stored in a derived type named RR_PHYSICAL.
%% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License. 

clear; global RR_PHYSICAL

RR_PHYSICAL.c.value=2.99792458*10^8;
RR_PHYSICAL.c.units='m/s';
RR_PHYSICAL.c.name ='speed of light';

RR_PHYSICAL.AU.value=1.495978707*10^11;
RR_PHYSICAL.AU.units='m';
RR_PHYSICAL.AU.name ='astronomical unit';

RR_PHYSICAL.G.value=6.67408*10^-11;
RR_PHYSICAL.G.units='N*m^2/kg^2';
RR_PHYSICAL.G.name ='universal gravitational constant';

RR_PHYSICAL.g.value=9.81;
RR_PHYSICAL.g.units='m/s^2';
RR_PHYSICAL.g.name ='Earth gravitational constant ';

RR_PHYSICAL.amu.value=1.67377*10^-27;
RR_PHYSICAL.amu.units='kg';
RR_PHYSICAL.amu.name ='atomic mass unit ';

RR_PHYSICAL.me.value=9.10939*10^-31;
RR_PHYSICAL.me.units='kg';
RR_PHYSICAL.me.name ='electron mass';

RR_PHYSICAL.mp.value=1.67262*10^-27;
RR_PHYSICAL.mp.units='kg';
RR_PHYSICAL.mp.name ='proton mass';

RR_PHYSICAL.mn.value=1.67493*10^-27;
RR_PHYSICAL.mn.units='kg';
RR_PHYSICAL.mn.name ='neutron mass';

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
