% FCC cube
pts=[0 0 0; 0 1 0; 1 0 0; 1 1 0; 0.5 0.5 0; 0.5 0 0.5; 0.5 1 0.5; 0 0.5 0.5; 1 0.5 0.5; 0 0 1; 0 1 1; 1 0 1; 1 1 1; 0.5 0.5 1];
pts=pts*sqrt(2)
figure(1); clf; for i=1:size(pts,1); drawsphere(pts(i,:),0); hold on; end
axis equal; axis off; hold off; view(-160,13); colormap(brightsummer)
print -dpdf 'fcc.pdf'
pt=[0 1 0.5]*sqrt(2); hold on; drawsphere1(pt,0,0.208); 
% print -dpdf 'fcc_plus_carbon.pdf'

% BCC cube
pts=[0 0 0; 0 1 0; 1 0 0; 1 1 0; 0.5 0.5 0.5; 0 0 1; 0 1 1; 1 0 1; 1 1 1];
pts=pts*2/sqrt(3)
figure(2); clf; for i=1:size(pts,1); drawsphere(pts(i,:),0); hold on; end
axis equal; axis off; hold off; view(-160,13); colormap(brightsummer)
% print -dpdf 'bcc.pdf'

% BCT cube
pts=[0 0 0; 0 1 0; 1 0 0; 1 1 0; 0.5 0.5 0.5; 0 0 1; 0 1 1; 1 0 1; 1 1 1];
pts=pts*2/sqrt(3)
figure(3); clf; for i=1:size(pts,1); drawsphere(pts(i,:),0); hold on; end
axis equal; axis off; hold off; view(-160,13); colormap(brightsummer)
% print -dpdf 'bcc.pdf'
