% classdef RR_uint512
% This class developes a RR_uint512 type (built with eight uint64 types) with wrap on overflow.
%
% DEFINITION:
%   A=RR_uint512(hi,m6,m5,m4,m3,m2,m1,lo) defines an RR_uint512 object from 8 uint64 variables
%   (I really don't think this one will ever be practically needed, but what the heck...  :)
%
% STANDARD OPERATIONS defined on RR_uint512 objects
% (overloading the +, -, *, /, ^, <, >, <=, >=, ~=, == operators):
%   plus:     [sum,carry]=a+b  gives the sum of two RR_uint512 integers
%   uminus:   -a gives the two's complement representation of negative a
%   minus:    b-a  gives the difference of two RR_uint512 integers (in two's complement form if negative)
%   mtimes:   [sum,carry]=a*b  gives the product of two RR_uint512 integers
%   mrdivide: [quo,rem]=b/a divides two RR_uint512 integers, giving the quotient quo and remainder rem
%   The relations <, >, <=, >=, ~=, == are also clearly defined.
%   {+,-,*} are built on uint64 primatives; the nonrestoring division algorithm is used to compute a/b
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

classdef RR_uint512 < matlab.mixin.CustomDisplay
    properties % RR_uint512 object OBJ consists of eight fields, with +,-,*,/ defined to wrap on overflow
        hi      % bits 449 to 512
        m6      % bits 385 to 448 
        m5      % bits 321 to 384
        m4      % bits 257 to 320
        m3      % bits 193 to 256
        m2      % bits 129 to 192 
        m1      % bits  65 to 128
        lo      % bits   1 to  64 
    end
    methods
        function OBJ = RR_uint512(a,b,c,d,e,f,g,h)  % create an RR_uint512 object obj.
            if nargin==1 % 1 argument:  create {hi,m6,m5,m4,m3,m2,m1,lo} parts from {0,0,0,0,0,0,0,a}            
                OBJ.hi=uint64(0); OBJ.m6=uint64(0); OBJ.m5=uint64(0); OBJ.m4=uint64(0); 
                OBJ.m3=uint64(0); OBJ.m2=uint64(0); OBJ.m1=uint64(0); OBJ.lo=uint64(a); 
            else         % 8 arguments: create {hi,m6,m5,m4,m3,m2,m1,lo} parts from {a,b,c,d,e,f,g,h}
                OBJ.hi=uint64(a); OBJ.m6=uint64(b); OBJ.m5=uint64(c); OBJ.m4=uint64(d); 
                OBJ.m3=uint64(e); OBJ.m2=uint64(f); OBJ.m1=uint64(g); OBJ.lo=uint64(h); 
            end
        end
        function SUM512 = plus(A512,B512)         % Defines A512+B512
            SUM512=RR_sum512(A512,B512);
        end
        function DIFF512 = minus(A512,B512)       % Defines A512-B512
            BB512=-B512; DIFF512=RR_sum512(AH256,AL256,BBH256,BBL256); % =RR_uint512(H256,L256);
        end
        function OUT512 = uminus(B512)            % Defines (-B512)
            % [BH256,BL256]=extractHL(B);
            % OUT512=RR_sum512(BH256,RR_sum512(uint64(1)); 
        end
        function OBJ512 = RR_uint512HL(A256,B256)  % create an RR_uint512 object from two RR_uint256 objects.
            OBJ512.hi=A256.hi; OBJ512.m6=A256.m2; OBJ512.m5=A256.m1; OBJ512.m4=A256.lo; 
            OBJ512.m3=B256.hi; OBJ512.m2=B256.m2; OBJ512.m1=B256.m1; OBJ512.lo=B256.lo; 
        end   
        function PROD512 = mtimes(A512,B512)      % Defines A512*B512
            PROD512=RR_prod512(A512,B512);
        end
        function [QUO512,RE512] = mrdivide(B512,A512) % Defines [QUO,RE]=B/A
            [QUO512,RE512]=RR_div512(B512,A512);
        end
        % Now define a<b, a>b, a<=b, a>=b, a~=b, a==b based on the values of a and b.

        function tf=lt(A,B), [AH256,AL256]=extractHL(A); [BH256,BL256]=extractHL(B); if (AH256< BH256) | (AH256==BH256 & AL256< BL256), tf=true; else, tf=false; end, end            
        function tf=gt(A,B), [AH256,AL256]=extractHL(A); [BH256,BL256]=extractHL(B); if (AH256> BH256) | (AH256==BH256 & AL256> BL256), tf=true; else, tf=false; end, end
        function tf=le(A,B), [AH256,AL256]=extractHL(A); [BH256,BL256]=extractHL(B); if (AH256<=BH256) | (AH256==BH256 & AL256<=BL256), tf=true; else, tf=false; end, end
        function tf=ge(A,B), [AH256,AL256]=extractHL(A); [BH256,BL256]=extractHL(B); if (AH256>=BH256) | (AH256==BH256 & AL256>=BL256), tf=true; else, tf=false; end, end
        function tf=ne(A,B), [AH256,AL256]=extractHL(A); [BH256,BL256]=extractHL(B); if (AH256~=BH256) | (AL256~=BL256),                tf=true; else, tf=false; end, end
        function tf=eq(A,B), [AH256,AL256]=extractHL(A); [BH256,BL256]=extractHL(B); if (AH256==BH256) | (AL256==BL256),                tf=true; else, tf=false; end, end

        function [AH256,AL256]=extractHL(A), AH256=RR_uint256(A.hi,A.m6,A.m5,A.m4); AL256=RR_uint256(A.m3,A.m2,A.m1,A.lo); end

        function A = RR_bitsll(A,k)            
            A.hi=bitsll(A.hi,k); for i=1:k; A.hi=bitset(A.hi,i,bitget(A.m6,64-k+i)); end
            A.m6=bitsll(A.m6,k); for i=1:k; A.m6=bitset(A.m6,i,bitget(A.m5,64-k+i)); end
            A.m5=bitsll(A.m5,k); for i=1:k; A.m5=bitset(A.m5,i,bitget(A.m4,64-k+i)); end
            A.m4=bitsll(A.m4,k); for i=1:k; A.m4=bitset(A.m4,i,bitget(A.m3,64-k+i)); end
            A.m3=bitsll(A.m3,k); for i=1:k; A.m3=bitset(A.m3,i,bitget(A.m2,64-k+i)); end
            A.m2=bitsll(A.m2,k); for i=1:k; A.m2=bitset(A.m2,i,bitget(A.m1,64-k+i)); end
            A.m1=bitsll(A.m1,k); for i=1:k; A.m1=bitset(A.m1,i,bitget(A.lo,64-k+i)); end
            A.lo=bitsll(A.lo,k); 
        end
        function A = RR_bitsrl(A,k)            
            A.lo=bitsrl(A.lo,k); for i=1:k; A.lo=bitset(A.lo,64-k+i,bitget(A.m1,i)); end
            A.m1=bitsrl(A.m1,k); for i=1:k; A.m1=bitset(A.m1,64-k+i,bitget(A.m2,i)); end
            A.m2=bitsrl(A.m2,k); for i=1:k; A.m2=bitset(A.m2,64-k+i,bitget(A.m3,i)); end
            A.m3=bitsrl(A.m3,k); for i=1:k; A.m3=bitset(A.m3,64-k+i,bitget(A.m4,i)); end
            A.m4=bitsrl(A.m4,k); for i=1:k; A.m4=bitset(A.m4,64-k+i,bitget(A.m5,i)); end
            A.m5=bitsrl(A.m5,k); for i=1:k; A.m5=bitset(A.m5,64-k+i,bitget(A.m6,i)); end
            A.m6=bitsrl(A.m6,k); for i=1:k; A.m6=bitset(A.m6,64-k+i,bitget(A.hi,i)); end
            A.hi=bitsrl(A.hi,k); 
        end
    end
    methods(Access = protected)
        function displayScalarObject(OBJ)
            fprintf('RR_uint512 with {hi,m6,m5,m4} = {0x%s,0x%s,0x%s,0x%s}\n',dec2hex(OBJ.hi,16),dec2hex(OBJ.m6,16),dec2hex(OBJ.m5,16),dec2hex(OBJ.m4,16))
            fprintf('            and {m3,m2,m1,lo} = {0x%s,0x%s,0x%s,0x%s}\n',dec2hex(OBJ.m3,16),dec2hex(OBJ.m2,16),dec2hex(OBJ.m1,16),dec2hex(OBJ.lo,16))
        end
    end
end 
