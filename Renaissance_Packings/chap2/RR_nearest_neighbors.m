function [count,basis]=RR_nearest_neighbors(d,lattice)
count=0; [basis,sq_dist_to_neighbor,checkpoints]=RR_build_lattice_basis(d,lattice)
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
end % function RR_nearest_neighbors