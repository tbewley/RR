function TenSimDynamics(x,Ua,Ub,p)
% Dynamic simulation of a 3D unconstrained, undamped class 1 tensegrity structure
% with fixed nodes, external forces, and embedded solid bodies.
% By Thomas Bewley, UCSD and JPL (summer/fall 2019)
%
% For further explanation, see section 2.2 of B2019, which this code follows closely:
% Bewley (2019) Stabilization of low-altitude balloon systems, Part 2:
% riggings with multiple taut ground tethers, analyzed as tensegrity systems
%
% INPUTS
% x = TenSimStateClass defining the tensegrity state
% U=U_(dim x p)=applied external force vector at each free node
% p=constant parameters
% extra_constraints=optional argument, used if pulleys equilibrate 2 or more tether tensions
%
% Using state qhat (defined in TenSimStateClass.m), locations Q=[Qb Qa Qc] of the free nodes
% in the system are computed via TenSimComputeQ:
% Qa(1:a)=non-rectangular (cell) array, each entry Qa{i}(1:3,1:na(i)) of which is a matrix
%     containing the locations of the na(i) nodal points on solid body i in global coordinates
% Qb(1:3,1:b,1:2)=locations of the ends of each bar
% Qc(1:3,1:c)=locations of the isolated nodes
% Note that we also need the (static) locations P of the fixed nodes:
% P(1:3,1:p)=locations of the p fixed nodes
%
% The connectivity of the strings described via S=[Q P]*CS' given the connectivity matrix C=[CB; CS]  

f1=TenSimStateClass; f2=TenSimStateClass; f3=TenSimStateClass; f4=TenSimStateClass;
t=0; for n=1:p.T/p.h
  f1=RHS(x,p,Ua,Ub); f2=RHS(x+f1*(p.h/2),p,Ua,Ub); f3=RHS(x+f2*(p.h/2),p,Ua,Ub); f4=RHS(x+f3*p.h,p,Ua,Ub);
  x=x+f1*(p.h/6)+f2*(p.h/3)+f3*(p.h/3)+f4*(p.h/6); t=t+p.h;  % Simulate with RK4.
  for k=1:p.a, x.Da(:,k)=x.Da(:,k)/norm(x.Da(:,k)); end      % Renormalize Da and Db every timestep.
  for k=1:p.b, x.Db(:,k)=x.Db(:,k)/norm(x.Db(:,k)); end      
  Q=TenSimComputeQ(x.Ra,x.Da,x.Rb,x.Db,x.Rc,p);              % Draw some pretty plots.
  clf; TenSimPlot(Q,p); title("time = "+t); drawnow
end
end % function TenSimDynamics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rhs=RHS(x,p,Ua,Ub)
  rhs=TenSimStateClass;                           % define first derivative variables to convert
  rhs.Rb=x.Rbdot; rhs.Ra=x.Radot; rhs.Rc=x.Rcdot; % 2nd-order equations to 1st-order form
  Q=TenSimComputeQ(x.Ra,x.Da,x.Rb,x.Db,x.Rc,p);   % Find the current locations of the nodes
  
  S=[Q p.P]*p.CS';                       % Current string vectors
  for i=1:p.s                            % Compute tension in strings
     xs(i)=max(0,p.kappa*(norm(S(:,i))-p.ells0(i))/p.ells0(i)); 
     Ds(:,i)=S(:,i)/norm(S(:,i));        % Current normalized string vectors
  end, xs;
  F=-Ds*diag(xs)*p.CS;  % Total force from all strings at each node (free and fixed) [see (2b)] 
  for k=1:p.b, for j=1:2, Fb(:,k,j)=F(:,(k-1)*2+j); end, end       % Extract force on each bar
  m=p.b*2; for k=1:p.a, for j=1:p.na(k), Fa{k}(:,j)=F(:,m+j); end, m=m+p.na(k); end % and body
  for k=1:p.c; Fc(:,k)=F(:,m+k); end                                % and isolated nodal point
    
  for k=1:p.a           % Evolution equations for solid bodies
    rhs.Radot(1:3,k)=0;
    for j=1:p.na(k)                                                    %
        rhs.Radot(:,k)=rhs.Radot(:,k)+Fa{k}(:,j);                      % (23c)
    end, rhs.Radot(1:3,k)=(rhs.Radot(1:3,k)+Ua(:,k))/p.ma(k);          %
    rhs.Da(:,k)=quat_multiply(x.Da(:,k),[0;x.Oa(:,k)])/2;              % (23d)
    tau(1:3)=0; for j=1:p.na(k)                                        % (23e), for body k
      tau(:)=tau(:)+cross(p.QaB{k}(1:3,j),quat_rotate(quat_conj(x.Da(:,k)),Fa{k}(:,j)));
    end
    rhs.Oa(1,k)=(tau(1)-(p.Ja(3,k)-p.Ja(2,k))*x.Oa(2,k)*x.Oa(3,k))/p.Ja(1,k); % (23d), with eta=0
    rhs.Oa(2,k)=(tau(2)-(p.Ja(1,k)-p.Ja(3,k))*x.Oa(3,k)*x.Oa(1,k))/p.Ja(2,k);
    rhs.Oa(3,k)=(tau(3)-(p.Ja(2,k)-p.Ja(1,k))*x.Oa(1,k)*x.Oa(2,k))/p.Ja(3,k);
  end

  for k=1:p.b           % Evolution equations for bars
    rhs.Rbdot(:,k)=(Fb(:,k,1)+Fb(:,k,2)+Ub(:,k))/p.mb(k);                   % (23a)
    rhs.Db(:,k)   =-cross(x.Db(:,k),x.Hb(:,k)/(p.Jb(k)*norm(x.Db(:,k))^2)); % (23b)
    rhs.Hb(:,k)   = cross(x.Db(:,k),(p.ellb(k)/2)*(Fb(:,k,1)-Fb(:,k,2)));   % (23b), with eta_3=0
  end

  for k=1:p.c           % Evolution equation (F=ma) for isolated nodal points
    rhs.Rcdot(:,k)=(Fc(:,k))/p.mc(k);
  end
end % function RHS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
