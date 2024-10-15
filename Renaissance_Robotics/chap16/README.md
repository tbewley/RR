# TenSim
Tensegrity Simulator - code for computing both the statics (including the tensioning via an LP) and dynamics of tensegrity systems, following the detailed derivations in *Bewley (2019) Stabilization of low-altitude balloon systems, Part 2: riggings with multiple taut ground tethers, analyzed as tensegrity systems*.

The main code, TenSim.m, implements all of the tensegrity systems discussed in the above paper as examples, in addition to a few from Skelton and de Oliveira (2009).

The two main subroutines called are TenSimStatics.m and TenSimDynamics.m, which implementing the equations of sections 3.1 and 3.2 of the above paper, respectively.  The (2D and 3D) plotting code is TenSimPlot.m.

All codes are written in simple (easy to extend) Matlab syntax.
