clear, close all force
global truss top_chord s l h

% Initial values
truss="warren"; top_chord="flat"; s=6; l=0.5; h=0.2;

fig=uifigure; g=uigridlayout(fig); % Set up a grid for all of the elements
g.RowHeight = {'1x',40};           % Tall upper row, fixed hight lower row
g.ColumnWidth = {'1x','1x','1x','1x','1x'};  % Five equal-width columns

ax = uiaxes(g);            % Frame into which we will put our plot
ax.Layout.Column = [1 5];  % This frame spans all 5 columns in row 1 of g
ax.Layout.Row = 1;

updateplot

% truss choice
s1 = uislider(g,"ValueChangedFcn",@(src,event)update1(src,event));
s1.Layout.Row = 2;         % This is in row 2 column 1 of g
s1.Layout.Column = 1;
s1.Limits = [0 20];
s1.Value = lA; 

% phi slider (angle in degrees)
s2 = uislider(g,"ValueChangedFcn",@(src,event)update2(src,event));  
s2.Layout.Row = 2;         % This is in row 2 column 2 of g
s2.Layout.Column = 2;
s2.Limits = [-50 50];  
s2.Value = phi;

% l2 slider (position in cm)
s3 = uislider(g,"ValueChangedFcn",@(src,event)update3(src,event));
s3.Layout.Row = 2;         % This is in row 2 column 3 of g
s3.Layout.Column = 3;
s3.Limits = [0 20];
s3.Value = lB;

% l2 slider (position in cm)
s3 = uislider(g,"ValueChangedFcn",@(src,event)update3(src,event));
s3.Layout.Row = 2;         % This is in row 2 column 3 of g
s3.Layout.Column = 3;
s3.Limits = [0 20];
s3.Value = lB;

function update1(src,event), global lA;  lA =event.Value; updateplot, end
function update2(src,event), global phi; phi=event.Value; updateplot, end
function update3(src,event), global lB;  lB =event.Value; updateplot, end
function update4(src,event), global lB;  lB =event.Value; updateplot, end
function update5(src,event), global lB;  lB =event.Value; updateplot, end

function updateplot
   global lA lB phi ax
   RR_Four_Bar_Seesaw(lA,lB,phi,1,1,.1,.2,false,ax)
end

