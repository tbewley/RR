function testgolay
d=[0 0 0 1 0 0 0 1 0 0 1 0]'; verbose=false; % user input

P=[0 1 1 1 1 1 1 1 1 1 1 1;                 % Define golay code
   1 1 1 0 1 1 1 0 0 0 1 0; 
   1 1 0 1 1 1 0 0 0 1 0 1;
   1 0 1 1 1 0 0 0 1 0 1 1;
   1 1 1 1 0 0 0 1 0 1 1 0;
   1 1 1 0 0 0 1 0 1 1 0 1;
   1 1 0 0 0 1 0 1 1 0 1 1;
   1 0 0 0 1 0 1 1 0 1 1 1;
   1 0 0 1 0 1 1 0 1 1 1 0;
   1 0 1 0 1 1 0 1 1 1 0 0;
   1 1 0 1 1 0 1 1 1 0 0 0;
   1 0 1 1 0 1 1 1 0 0 0 1]; V=gf([eye(12);P]); H=gf([P,eye(12)]); w=V*d;

format compact; original_codeword=w.x'
disp('Testing all possible single errors')
for i=1:24                               
  hatw=w; hatw(i)=hatw(i)+1; test(verbose,P,V,H,w,hatw)
end
disp('Testing all possible double errors')
for i=1:24, for j=i+1:24
  hatw=w; hatw(i)=hatw(i)+1; hatw(j)=hatw(j)+1; test(verbose,P,V,H,w,hatw)
end, end
disp('Testing all possible triple errors')
for i=1:24, for j=i+1:24, for k=j+1:24
  hatw=w; hatw(i)=hatw(i)+1; hatw(j)=hatw(j)+1; hatw(k)=hatw(k)+1; test(verbose,P,V,H,w,hatw)
end, end, end
end % function testgolay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function test(verbose,P,V,H,w,hatw)
[flag,c]=decode_golay(hatw,V,P,verbose);
if flag==0
  hatw_corrected=hatw+c; error=w_H(w-hatw_corrected);
  if (error>0), disp(sprintf('error = %d',error)), end
  if verbose, received_message=hatw.x', corrected_message=hatw_corrected.x', pause; end
else
  disp('Four errors detected')
end
end % function test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [flag,c]=decode_golay(hatw,V,P,verbose)
s=V'*hatw; r=P*s; I=eye(12); flag=1;
if     (w_H(s) <= 3), c=[s; zeros(12,1)]; flag=0; if verbose, disp('A'), end, return
elseif (w_H(r) <= 3), c=[zeros(12,1); r]; flag=0; if verbose, disp('B'), end, return
end
for i=1:12
   if     (w_H(s+P(:,i)) <= 2), c=[s+P(:,i); I(:,i)]; flag=0; if verbose, disp('C'), end, return
   elseif (w_H(r+P(:,i)) <= 2), c=[I(:,i); r+P(:,i)]; flag=0; if verbose, disp('D'), end, return
   end
end
disp('E'); 
end % function decode_golay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function wH=w_H(s)
  wH=0; for i=1:length(s); wx=s.x; wH=wH+wx(i); end 
end % function w_H