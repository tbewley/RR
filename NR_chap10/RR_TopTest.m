% script <a href="matlab:TopTest">TopTest</a>
% Simulate the motion of a top.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.4.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

clear
% This (upright) test case is Example 10.9 of Numerical Renaissance.
% Define the physical constants of the top.
p.I =0.25; % Moment of inertia about axis of symmetry of top (about which top spins)
p.Ip=0.5;  % Moment of inertia perpendicular to the axis of symmetry
p.m=2; p.L=0.2; p.g=9.80665;    % Mass and length of top, and acceleration due to gravity
theta0=30*pi/180; phidot0=200*2*pi/60; % Initial angle=30 deg, initial spin=200 rev/min
% Initialize deflection for 4 cases: steady, unidirectional, cuspidial, and looping motion
deflection=[0 .5 1 3];  % Enter as a fraction of the deflection causing cuspidial motion
s.h=.002; s.Nplot=1000; % Simulation parameters
% We now do one simulation for each set of initial conditions, as defined by deflection.
for sim=1:length(deflection)
  Top(theta0,phidot0,deflection(sim),p,s) % Perform the simulation.
  figure(1), switch sim
    case 1, title('Steady precession (Fig 10.10a)')
    case 2, title('Unidirectional precession (psidot constant sign, Fig 10.10b)')
    case 3, title('Cuspidial oscillation (psidot touches zero, Fig 10.10c)')
    case 4, title('Looping oscillation (psidot goes negative, Fig 10.10c)')
  end, pause, disp(' ')
end

% This (hanging) test case is Example 8.3 of Ginsberg (1998) Advanced Engineering Dynamics
p.I =0.2592; p.Ip=0.4608; p.m=2; p.L=0.2; p.g=9.80665;
theta0=120*pi/180; phidot0=500*2*pi/60; deflection=[0 .5 1 3]; s.h=.001; s.Nplot=1000;
for sim=1:length(deflection)
  Top(theta0,phidot0,deflection(sim),p,s) % Perform the simulation.
  figure(1), switch sim
    case 1, title('Steady precession')
    case 2, title('Unidirectional precession (psidot constant sign)')
    case 3, title('Cuspidial oscillation (psidot touches zero)')
    case 4, title('Looping oscillation (psidot goes negative)')
  end, if sim<length(deflection), pause, end, disp(' ')
end

% end script TopTest
