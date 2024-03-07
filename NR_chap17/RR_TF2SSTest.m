% script <a href="matlab:RC_TF2SSTest">RC_TF2SSTest</a>
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Sections 20.3.1 and 20.3.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

clear, disp('Original transfer function:')
% b=randn(1,5), a=[1 randn(1,4)], disp(' ')
b=[0 0 1 0 -4], a=[1 0 -10 0 9], disp(' ')

disp('Controller form:')
[Ac,Bc,Cc,Dc]=RC_TF2SS(b,a,'Controller'); RC_ShowSys(Ac,Bc,Cc,Dc)
[bc,ac]=RC_SS2TF(Ac,Bc,Cc,Dc); ERRORc=norm(b-bc)+norm(a-ac), pause

disp(' '), disp('Reachability form:')
[Are,Bre,Cre,Dre]=RC_TF2SS(b,a,'Reachability'); RC_ShowSys(Are,Bre,Cre,Dre)
[bre,are]=RC_SS2TF(Are,Bre,Cre,Dre); ERRORre=norm(b-bre)+norm(a-are), pause

disp(' '), disp('DTControllability form:')
[Aco,Bco,Cco,Dco]=RC_TF2SS(b,a,'DTControllability'); RC_ShowSys(Aco,Bco,Cco,Dco)
[bco,aco]=RC_SS2TF(Aco,Bco,Cco,Dco); ERRORco=norm(b-bco)+norm(a-aco), pause

disp(' '), disp('Observer form:')
[Ao,Bo,Co,Do]=RC_TF2SS(b,a,'Observer'); RC_ShowSys(Ao,Bo,Co,Do)
[bo,ao]=RC_SS2TF(Ao,Bo,Co,Do); ERRORo=norm(b-bo)+norm(a-ao), pause

disp(' '), disp('Observability form:')
[Aob,Bob,Cob,Dob]=RC_TF2SS(b,a,'Observability'); RC_ShowSys(Aob,Bob,Cob,Dob)
[bob,aob]=RC_SS2TF(Aob,Bob,Cob,Dob); ERRORob=norm(b-bob)+norm(a-aob), pause

disp(' '), disp('DTConstructibility form:')
[Acs,Bcs,Ccs,Dcs]=RC_TF2SS(b,a,'DTConstructibility'); RC_ShowSys(Acs,Bcs,Ccs,Dcs)
[bcs,acs]=RC_SS2TF(Acs,Bcs,Ccs,Dcs); ERRORcs=norm(b-bcs)+norm(a-acs)

% end script RC_TF2SSTest
