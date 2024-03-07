function [X]=RC_Sylvester(T11,T22,T12,gamma)

[junk M]=size(T11);  [junk N]=size(T22);
T12orig=T12;
X=zeros(M,N);

for i=1:min(M,N) 
    F1=T12(1:M-i,i+1:end);      fc=T12(1:M-i,i);        f11=T12(M-i+1,i);       fr=T12(M-i+1,i+1:end);                          
    T1=T11(1:M-i,1:M-i);        tc=T11(1:M-i,M-i+1);    t11=T11(M-i+1,M-i+1);   
    P1=T22(i+1:end,i+1:end);    p11=T22(i,i);           pr=T22(i,i+1:end);
   
    x11=((t11-p11)^-1)*f11;
    X(M-i+1,i)=x11;

    xc=inv(T1-p11*eye(size(T1)))*(fc-tc*x11);
    X(1:M-i,i)=xc;
    
    xr=(x11*pr+fr)*inv(t11*eye(size(P1))-P1);
    X(M-i+1,i+1:end)=xr;
    
    F1=(tc*xr-xc*pr-F1);
    T12(1:M-i,i+1:end)=-F1;
    
end
    
%shouldbezero=T11*X-X*T22-T12orig
   
    
    
    
    
    
    
    
   
    
    
    