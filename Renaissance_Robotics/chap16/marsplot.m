clear, clf  % Bright Gully Deposits in Western Hale Crater (of Mars)
% article here:
% https://www.sciencedirect.com/science/article/abs/pii/S0019103509003923#!
% data from: High Resolution Imaging Science Experiment
% https://hirise.lpl.arizona.edu/ESP_013019_1450
% https://www.uahirise.org/dtm/dtm.php?ID=ESP_013019_1450
% data tweaked by:
% https://sketchfab.com/3d-models/013019-1450-overview-mars-hirise-91fe2efb79564c669fc4d96bf0fb3c5a

tr=stlread('marsplot.stl');
c=tr.ConnectivityList; x=tr.Points(:,1); z=tr.Points(:,2); y=tr.Points(:,3);
tr1=triangulation(c,[x -y z]);
trisurf(tr1)
axis equal
axis([700 3100 -1300 681 1140 2300])
colormap copper
hold on
set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]); set(gca,'ZTickLabel',[]);
view([-111.6,8]);
% set(gcf,'Renderer','painters');
set(gcf,'color','w');
