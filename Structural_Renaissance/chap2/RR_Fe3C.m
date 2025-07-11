% Data from https://legacy.materialsproject.org/materials/mp-510623/#

clear; figure(1); clf;
S=[4.491 5.030 6.739]; % Size of cell in angstroms
X=[0 1;0 1;0 1;0 1;0 0;0 0;1 1;1 1;0 0;0 0;1 1;1 1]'*S(1);
Y=[0 0;0 0;1 1;1 1;0 1;0 1;0 1;0 1;0 0;1 1;0 0;1 1]'*S(2);
Z=[0 0;1 1;0 0;1 1;0 0;1 1;0 0;1 1;0 1;0 1;0 1;0 1]'*S(3);
plot3(X,Y,Z,'k'); hold on

plot3([0 S(1)],[0    0   ],[0    0   ]); hold on
plot3([0 S(1)],[0    0   ],[S(3) S(3)]);
plot3([0 S(1)],[S(2) S(2)],[0    0   ]);
plot3([0 S(1)],[S(2) S(2)],[S(3) S(3)]);
plot3([0    0   ],[0 S(2)],[0    0   ]);
plot3([0    0   ],[0 S(2)],[S(3) S(3)]);
plot3([S(1) S(1)],[0 S(2)],[0    0   ]);
plot3([S(1) S(1)],[0 S(2)],[S(3) S(3)]);
plot3([0    0   ],[0    0   ],[0 S(3)]);
plot3([0    0   ],[S(2) S(2)],[0 S(3)]);
plot3([S(1) S(1)],[0    0   ],[0 S(3)]);
plot3([S(1) S(1)],[S(2) S(2)],[0 S(3)]);
axis equal; hold on

Fe=[...
0.1679	0.6774	0.0684; ...
0.3321	0.1774	0.0684; ...
0.6629	0.5367	0.25  ; ...
0.8371	0.0367	0.25;
0.1679	0.6774	0.4316; ...
0.3321	0.1774	0.4316; ...
0.6679	0.8226	0.5684; ...
0.8321	0.3226	0.5684; ...
0.1629	0.9633	0.75  ; ...
0.3371	0.4633	0.75  ; ...
0.6679	0.8226	0.9316; ...
0.8321	0.3226	0.9316; ...
0.8371	0.0367+1 0.25  ; ...
0.8371-1 0.0367	0.25   ; ...
0.6629-1 0.5367	0.25   ; ...
0.3321	0.1774+1 0.0684; ...
0.3321	0.1774+1 0.4316; ...
0.1629	0.9633-1 0.75  ; ...
0.1629+1 0.9633  0.75 ; ...
0.3371+1 0.4633	0.75   ; ...
0.6679	0.8226-1 0.9316; ...
0.6679	0.8226-1 0.5684];
C=[...
0.0609	0.377	0.25; ...
0.4391	0.877	0.25; ...
0.5609	0.123	0.75; ...
0.9391	0.623	0.75; ...
0.0609+1 0.377	0.25; ...
0.4391	0.877-1	0.25; ...
0.5609	0.123+1	0.75; ...
0.9391-1 0.623	0.75];
for i=1:3; Fe(:,i)=Fe(:,i)*S(i); 
	       C(:,i) =C(:,i) *S(i); end

NFe=size(Fe,1); NC=size(C,1);
for i=1:NFe, RR_drawsphere(Fe(i,:),0,0.5); end
for j=1:NC,  RR_drawsphere(C(j,:),0,0.208,50);  end

for j=1:NC
  for i=1:NFe
     d=norm(C(j,:)-Fe(i,:));
     if d<2.3, d, plot3([C(j,1) Fe(i,1)],[C(j,2) Fe(i,2)],[C(j,3) Fe(i,3)],"linewidth",3), hold on, end
  end
end
colormap(summer)
