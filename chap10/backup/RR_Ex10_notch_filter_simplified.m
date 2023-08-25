% script RR_Ex10_notch_filter_simplified
% Here is a more human-readable way of inputing the equations of a system
% (problem 1 of the 2020 midterm) that does not require you to swing specific
% terms to the LHS and RHS of each eqn, and then set up A and b yourself.
% You can instead have the "solve" command do this work for you.

% pkg load symbolic           % uncomment this line if running octave
clear
syms s R L C c1 Vin           % Laplace variable s, parameters, input Vin
syms Vout Va Ir Il Ic Iload   % variables to be solved for (output is Vout)
eqn1= Vin-Vout == R*Ir        % Component eqns
eqn2=  Vout-Va == L*s*Il
eqn3=       Ic == C*s*Va
eqn4=     Vout == Iload*(R/c1)
eqn5=       Ir == Il + Iload  % KCLs
eqn6=       Il == Ic
sol=solve(eqn1,eqn2,eqn3,eqn4,eqn5,eqn6,Vout,Va,Ir,Il,Ic,Iload); % solve
F=simplify(sol.Vout/Vin)      % transfer fn of filter = Vout / Vin