% script RR_tf2ss_test
%% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License. 

clear, disp('Original transfer function:')
% b=randn(1,5), a=[1 randn(1,4)], disp(' ')
b=[0 0 1 0 -4], a=[1 0 -10 0 9], disp(' ')

disp('Controller form:')
[Ac,Bc,Cc,Dc]=RR_TF2SS(b,a,'Controller'); RR_ShowSys(Ac,Bc,Cc,Dc)
[bc,ac]=RR_SS2TF(Ac,Bc,Cc,Dc); ERRORc=norm(b-bc)+norm(a-ac), pause

disp(' '), disp('Reachability form:')
[Are,Bre,Cre,Dre]=RR_TF2SS(b,a,'Reachability'); RR_ShowSys(Are,Bre,Cre,Dre)
[bre,are]=RR_SS2TF(Are,Bre,Cre,Dre); ERRORre=norm(b-bre)+norm(a-are), pause

disp(' '), disp('DTControllability form:')
[Aco,Bco,Cco,Dco]=RR_TF2SS(b,a,'DTControllability'); RR_ShowSys(Aco,Bco,Cco,Dco)
[bco,aco]=RR_SS2TF(Aco,Bco,Cco,Dco); ERRORco=norm(b-bco)+norm(a-aco), pause

disp(' '), disp('Observer form:')
[Ao,Bo,Co,Do]=RR_TF2SS(b,a,'Observer'); RR_ShowSys(Ao,Bo,Co,Do)
[bo,ao]=RR_SS2TF(Ao,Bo,Co,Do); ERRORo=norm(b-bo)+norm(a-ao), pause

disp(' '), disp('Observability form:')
[Aob,Bob,Cob,Dob]=RR_TF2SS(b,a,'Observability'); RR_ShowSys(Aob,Bob,Cob,Dob)
[bob,aob]=RR_SS2TF(Aob,Bob,Cob,Dob); ERRORob=norm(b-bob)+norm(a-aob), pause

disp(' '), disp('DTConstructibility form:')
[Acs,Bcs,Ccs,Dcs]=RR_TF2SS(b,a,'DTConstructibility'); RR_ShowSys(Acs,Bcs,Ccs,Dcs)
[bcs,acs]=RR_SS2TF(Acs,Bcs,Ccs,Dcs); ERRORcs=norm(b-bcs)+norm(a-acs)

% end script RR_TF2SSTest
