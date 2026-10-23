function [count,basis]=RR_nearest_neighbors(d,lattice)
count=0; [basis,sq_dist_to_neighbor,checkpoints]=build_basis(d,lattice)
for i=1:checkpoints^d-1
   str = dec2base(i,checkpoints);
   while length(str)<d; str=['0',str]; end
   for j=1:d
      switch str(j)
         case '0', w(j,1)=0;
         case '1', w(j,1)=1;
         case '2', w(j,1)=-1;
         case '3', w(j,1)=2;
         case '4', w(j,1)=-2;
         case '5', w(j,1)=3;
         case '6', w(j,1)=-3;
         case '7', w(j,1)=4;
         case '8', w(j,1)=-4;
      end
   end
   latticepoint=basis*w;
   sq_dist(i)=abs(latticepoint'*latticepoint);
   if abs(sq_dist_to_neighbor-sq_dist(i))<1e-3, 
       count=count+1; latticepoint'
   end
end
sq_dist_to_neighbor
min(sq_dist)
end % function nearest_neighbors

function [basis,sq_dist_to_neighbor,checkpoints]=RR_build_lattice_basis(d,lattice)
% build basis for a lattice
switch lattice
    case('Z')
        checkpoints=3;
        basis=eye(d); sq_dist_to_neighbor=1;
    case('D')
        checkpoints=5;
        basis=-eye(d)+diag(ones(d-1,1),1); basis(2,1)=-1;
        sq_dist_to_neighbor=2;
    case('D*')
        checkpoints=5;
        basis=eye(d); basis(:,d)=0.5;
        switch d
           case 2, sq_dist_to_neighbor=0.5;
           case 3, sq_dist_to_neighbor=0.75;
           otherwise, sq_dist_to_neighbor=1;
        end
    case('D+')
        checkpoints=9;
        if mod(d,2)==1 | d<4, error('D_n^+ basis is defined here only for even d>=4.'), end
        basis=eye(d)-diag(ones(d-1,1),1); basis(1:d/2,d)=1/2; basis(d/2+1:d,d)=-1/2; basis(1,1)=-2;
        switch d
           case 2, sq_dist_to_neighbor=.5;
           case 4, sq_dist_to_neighbor=1;
           case 6, sq_dist_to_neighbor=1.5;
           otherwise, sq_dist_to_neighbor=2;
        end
    case('E')
        if d<6 | d>8, error('Only E6,E7,E8 implemented.'), end
        [basis,sq_dist_to_neighbor,checkpoints]=build_basis(8,'D+');
        if     d==7, basis=basis(:,2:8);
        elseif d==6, basis=basis(:,3:8); end
    case('A')
        checkpoints=3;
        basis=zeros(d+1,d); for i=1:d, basis([i i+1],i)=[-1;1]; end
        sq_dist_to_neighbor=2;
    case('A*')
        checkpoints=3;
        for j=1:d, basis(1:j,j)=d+1-j; basis(j+1:d+1,j)=-j; end
        basis=basis/(d+1);
        sq_dist_to_neighbor=d/(d+1);
    otherwise
        error('case not implemented');
end
end % function build_basis