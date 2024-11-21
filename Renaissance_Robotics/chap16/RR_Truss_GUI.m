clear, figure(6)
global truss top_chord s l h

% Initial values
truss="Warren"; top_chord=0; s=6; l=0.5; h=0.2;

fig=uifigure; g=uigridlayout(fig); % Set up a grid for all of the elements
g.RowHeight = {'1x',40};           % Tall upper row, fixed hight lower row
g.ColumnWidth = {'1x','1x','1x','1x','1x'};  % Five equal-width columns

ax = uiaxes(g);            % Frame into which we will put our plot
ax.Layout.Column = [1 5];  % This frame spans all 5 columns in row 1 of g
ax.Layout.Row = 1;

updateplot

% truss choice
dd = uidropdown(g,"ValueChangedFcn",@(src,event)update1(src,event),"Items",["Warren","Howe","Pratt"]);
dd.Layout.Row = 2;         % This is in row 2 column 1 of g
dd.Layout.Column = 1;
dd.Value = truss; 

% top_chord slider (controls curvature of top chord)
s1 = uislider(g,"ValueChangedFcn",@(src,event)update2(src,event));  
s1.Layout.Row = 2;         % This is in row 2 column 2 of g
s1.Layout.Column = 2;
s1.Limits = [0 1];  
s1.Value = top_chord;

% s slider (number of horizontal elements)
s2 = uislider(g,"ValueChangedFcn",@(src,event)update3(src,event));
s2.Layout.Row = 2;         % This is in row 2 column 3 of g
s2.Layout.Column = 3;
s2.Limits = [0 20];
s2.Value = s;

% l slider (position in cm)
s3 = uislider(g,"ValueChangedFcn",@(src,event)update4(src,event));
s3.Layout.Row = 2;         % This is in row 2 column 4 of g
s3.Layout.Column = 4;
s3.Limits = [0 20];
s3.Value = l;

% h slider (relative height)
s4 = uislider(g,"ValueChangedFcn",@(src,event)update5(src,event));
s4.Layout.Row = 2;         % This is in row 2 column 5 of g
s4.Layout.Column = 5;
s4.Limits = [0 20];
s4.Value = h;

function update1(src,event), global truss;     truss    =event.Value; updateplot, end
function update2(src,event), global top_chord; top_chord=event.Value; updateplot, end
function update3(src,event), global s;         s        =event.Value; updateplot, end
function update4(src,event), global l;         l        =event.Value; updateplot, end
function update5(src,event), global h;         h        =event.Value; updateplot, end

function updateplot
   global truss top_chord s l h
   disp(truss)
   disp(top_chord)
   disp(s)
   disp(l)
   disp(h)
end

