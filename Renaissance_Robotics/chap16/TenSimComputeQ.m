function Q=TenSimComputeQ(Ra,Da,Rb,Db,Rc,p)
% Compute the nodes for a class 1 tensegrity structure
% By Thomas Bewley, UCSD and JPL (summer/fall 2019)

for k=1:p.a, for j=1:p.na(k)
    Qa{k}(:,j)=Ra(:,k)+quat_rotate(Da(:,k),p.QaB{k}(:,j));
end, end
for k=1:p.b
    Qb(:,k,1)=Rb(:,k)+(p.ellb(k)/2)*Db(:,k);
    Qb(:,k,2)=Rb(:,k)-(p.ellb(k)/2)*Db(:,k);
end
Q=[];
for k=1:p.a, for j=1:p.na(k), Q=[Q Qa{k}(:,j)]; end, end
for k=1:p.b, Q=[Q Qb(:,k,1) Qb(:,k,2)];              end
for k=1:p.c,                  Q=[Q Rc(:,k)];         end

end % function TenSimComputeQ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
