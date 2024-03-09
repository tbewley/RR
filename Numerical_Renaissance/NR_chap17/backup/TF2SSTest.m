% script <a href="matlab:RR_TF2SSTest">RR_TF2SSTest</a>
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Sections 20.3.1 and 20.3.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

clear, disp('Original transfer function:')
b=rand(1,5), a=[1 rand(1,4)], disp(' ')

disp('Controller form:')
[Ac,Bc,Cc,Dc]=RR_TF2SS(b,a,'Controller'); RR_ShowSys(Ac,Bc,Cc,Dc)
[bc,ac]=RR_SS2TF(Ac,Bc,Cc,Dc); ERRORc=norm(b-bc)+norm(a-ac), pause

disp(' '), disp('Reachability form:')
[Aco,Bco,Cco,Dco]=RR_TF2SS(b,a,'Reachability'); RR_ShowSys(Aco,Bco,Cco,Dco)
[bco,aco]=RR_SS2TF(Aco,Bco,Cco,Dco); ERRORco=norm(b-bco)+norm(a-aco), pause

disp(' '), disp('DTControllability form:')
[Act,Bct,Cct,Dct]=RR_TF2SS(b,a,'DTControllability'); RR_ShowSys(Act,Bct,Cct,Dct)
[bct,act]=RR_SS2TF(Act,Bct,Cct,Dct); ERRORct=norm(b-bct)+norm(a-act), pause

disp(' '), disp('Observer form:')
[Ao,Bo,Co,Do]=RR_TF2SS(b,a,'Observer'); RR_ShowSys(Ao,Bo,Co,Do)
[bo,ao]=RR_SS2TF(Ao,Bo,Co,Do); ERRORo=norm(b-bo)+norm(a-ao), pause

disp(' '), disp('Observability form:')
[Aob,Bob,Cob,Dob]=RR_TF2SS(b,a,'Observability'); RR_ShowSys(Aob,Bob,Cob,Dob)
[bob,aob]=RR_SS2TF(Aob,Bob,Cob,Dob); ERRORob=norm(b-bob)+norm(a-aob), pause

disp(' '), disp('DTConstructibility form:')
[Acs,Bcs,Ccs,Dcs]=RR_TF2SS(b,a,'DTConstructibility'); RR_ShowSys(Acs,Bcs,Ccs,Dcs)
[bcs,acs]=RR_SS2TF(Acs,Bcs,Ccs,Dcs); ERRORcs=norm(b-bcs)+norm(a-acs)

disp(' '); disp('Next <a href="matlab:help RCchap20">RCchap20</a> demo: <a href="matlab:RR_CtrbMatrixTest">RR_CtrbMatrixTest</a>'), disp(' ')
% end script RR_TF2SSTest
