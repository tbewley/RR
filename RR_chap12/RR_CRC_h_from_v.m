function h = RR_CRR_h_from_v(v,k,r,verbose)
% function h = RR_CRR_h_from_v(v,k,r,verbose)
% Computes the parity check polynmial h(z) based on v(z) and k.
% Note: all polynomials ordered from highest power to zero'th power of z in vectors.
% INPUTS: v=vector of binary (logical) coefficients of the basis polynomial v(z)
%         k=number of data bits (maximum size of a - pad with zeros if smaller)
%         r=number of parity bits (r+1 = size of v)
%         verbose=logical (if true, print a bunch of stuff to the screen)
% OUTPUT: h=vector of coefficients of the corresponding parity-check polynomial h(z)
% NOTE 1: This demo code is by no means efficient.  Use for demo purposes only.
% NOTE 2: This simple demo code requires n=k+r<=63.
% EXAMPLE CALL [computes h(z) for v(z) corresponding to CRC-5-USB, for k=26, d=3]:
%     k=26; r=5; v=0b100101u64; h=RR_CRR_h_from_v(v,k,r,true);
% EXAMPLE CALL [computes h(z) for v(z) corresponding to CRC-5-ITU, for k=10, d=4]:
%     k=10; r=5; v=0b101011u64; h=RR_CRR_h_from_v(v,k,r,true);
%% Renaissance Robotics codebase, Chapter 12, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

n=k+r;
if ~verbose
  t=bitshift(1,n)+0b1u64; h=0b0u64; % initialize t=100...001 corresponding to t(z)=z^n-1
  for i=n+1:-1:r+1                  % calculate  h=t/v on F2 
    if bitget(t,i)
      h=h+bitshift(1,i-r-1); t=bitxor(t,bitshift(v,i-r-1));        
    end
  end
else
  t=bitshift(1,n)+0b1u64; h=0b0u64;  ts=dec2bin(t)                            
  for  i=n+1:-1:r+1                  % (same as above, with more screen output)
    if bitget(t,i)
      w=bitshift(v,i-r-1);   vs=dec2bin(w,n+1)
      h=h+bitshift(1,i-r-1); hs=dec2bin(h)
      t=bitxor(t,w);         ts=dec2bin(t,n+1)
    end
  end
  disp('check: now perform h(z)*v(z) on F2, it should equal 100...001')
  c=0b0u64;
  for  i=1:k+1
    if bitget(h,i)
      w=bitshift(v,i-1); vs=dec2bin(w,n+1)
      c=bitxor(c,w);     check=dec2bin(c,n+1)
    end
  end
end