% script RR_linkwitz_riley_filters.m
% generates and makes the Bode plots of the 2nd, 4th, and 8th order Linkwitz_Riley
% (LR) complementary filters.  Note that each pair add up to all-pass filters, with
% unit gain across all frequencies.  Their overall phase loss (of 180, 360, and 720
% degrees, respectively) is the price you pay for stability [it doesn't affect
% audio reproduction too noticably, but if using for control you gotta be aware of
% it, especially in the vicinity of crossover]
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chap08
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear; close all; omegac=1;

LR2_LP=RR_LPF_first_order(omegac)^2
LR2_HP=-1*RR_filter_reflect(LR2_LP), sum2=LR2_LP+LR2_HP
figure(1); RR_bode(LR2_LP); figure(2); RR_bode(LR2_HP); figure(3); RR_bode(sum2); 
pause

LR4_LP=RR_LPF_butterworth(2,omegac)^2
LR4_HP=RR_filter_reflect(LR4_LP), sum4=LR4_LP+LR4_HP,
figure(4); RR_bode(LR4_LP); figure(5); RR_bode(LR4_HP); figure(6); RR_bode(sum4); 
pause

LR8_LP=RR_LPF_butterworth(4,omegac)^2
LR8_HP=RR_filter_reflect(LR8_LP), sum8=LR8_LP+LR8_HP,
figure(7); RR_bode(LR8_LP); figure(8); RR_bode(LR8_HP); figure(9); RR_bode(sum8); 
