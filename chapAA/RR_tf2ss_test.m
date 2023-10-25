% script RR_tf2ss_test
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Sections 20.3.1 and 20.3.2.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap20">Chapter 20</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.

clear, disp('Original transfer function:')
% b=randn(1,5), a=[1 randn(1,4)], disp(' ')
b=[0 0 1 0 -4], a=[1 0 -10 0 9], disp(' ')

disp('Controller form:')
[Ac,Bc,Cc,Dc]=NR_TF2SS(b,a,'Controller'); NR_ShowSys(Ac,Bc,Cc,Dc)
[bc,ac]=NR_SS2TF(Ac,Bc,Cc,Dc); ERRORc=norm(b-bc)+norm(a-ac), pause

disp(' '), disp('Reachability form:')
[Are,Bre,Cre,Dre]=NR_TF2SS(b,a,'Reachability'); NR_ShowSys(Are,Bre,Cre,Dre)
[bre,are]=NR_SS2TF(Are,Bre,Cre,Dre); ERRORre=norm(b-bre)+norm(a-are), pause

disp(' '), disp('DTControllability form:')
[Aco,Bco,Cco,Dco]=NR_TF2SS(b,a,'DTControllability'); NR_ShowSys(Aco,Bco,Cco,Dco)
[bco,aco]=NR_SS2TF(Aco,Bco,Cco,Dco); ERRORco=norm(b-bco)+norm(a-aco), pause

disp(' '), disp('Observer form:')
[Ao,Bo,Co,Do]=NR_TF2SS(b,a,'Observer'); NR_ShowSys(Ao,Bo,Co,Do)
[bo,ao]=NR_SS2TF(Ao,Bo,Co,Do); ERRORo=norm(b-bo)+norm(a-ao), pause

disp(' '), disp('Observability form:')
[Aob,Bob,Cob,Dob]=NR_TF2SS(b,a,'Observability'); NR_ShowSys(Aob,Bob,Cob,Dob)
[bob,aob]=NR_SS2TF(Aob,Bob,Cob,Dob); ERRORob=norm(b-bob)+norm(a-aob), pause

disp(' '), disp('DTConstructibility form:')
[Acs,Bcs,Ccs,Dcs]=NR_TF2SS(b,a,'DTConstructibility'); NR_ShowSys(Acs,Bcs,Ccs,Dcs)
[bcs,acs]=NR_SS2TF(Acs,Bcs,Ccs,Dcs); ERRORcs=norm(b-bcs)+norm(a-acs)

% end script NR_TF2SSTest
