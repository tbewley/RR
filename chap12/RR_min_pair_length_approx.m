function [seq,length]=RR_min_pair_length_approx(D,n)
% function [seq,length]=RR_min_pair_length_approx(D,n)
% Given an n x n matrix D (note: n must be even) quantifying the distance between
% any two nodes in a graph, estimate the minimizer of the sum,
% over i=1:2:n-1, of the distances between node seq(i) and seq(i+1).
% Note: this approximate search scales pretty well with n.  Tested up to n=100.
% TEST:  clear; n=16;
%        D=randn(n,n); D=D.*D; D=D+D'; for i=1:n; D(i,i)=0; end
%        seq=[1:n], if n<11, D, end
%        dumb_sol=0; for i=1:2:n-1, dumb_sol=dumb_sol+D(seq(i),seq(i+1)); end, dumb_sol
%        disp('Now, construct a "good" solution.')
%        tic, seq=RR_min_pair_length_approx(D,n), disp('Time to construct the good solution:'), toc
%        good_sol=0; for i=1:2:n-1, good_sol=good_sol+D(seq(i),seq(i+1)); end, good_sol
%        if n<21, disp('Now, construct the best solution.')
%        tic, seq=RR_min_pair_length(D,n), disp('Time to construct the best solution:'), toc
%        best_sol=0; for i=1:2:n-1, best_sol=best_sol+D(seq(i),seq(i+1)); end, best_sol, end
% Renaissance Robotics codebase, Chapter 12, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

remaining=[1:n]; length=0;
for i=1:2:n-3
    [new_pair,new_length]=max_min_pair_length(D(remaining,remaining),n+1-i);
    seq(i:i+1)=remaining(new_pair);
    remaining=remaining([1:new_pair(1)-1,new_pair(1)+1:new_pair(2)-1,new_pair(2)+1:n+1-i]);
    length=length+D(seq(i),seq(i+1));
end
seq(n-1:n)=remaining; length=length+D(seq(n-1),seq(n)); initial_length=length
while 1,
    mod=false;
    [seq,length,mod]=pairwise_swaps(seq,length,D,n);
    if mod, fprintf('Pairwise swaps reduced length to'), disp(length), continue, end
    [seq,length,mod]=triplet_swaps(seq,length,D,n);
    if mod, fprintf('Triplet swaps reduced length to'), disp(length), continue, end
    break
end
end % function RR_min_pair_length_approx
%%%%%%%%%%%%%%%%%%%
function [new_pair,length]=max_min_pair_length(D,n)
for i=1:n
  [row_min(i),row_which(i)]=min(D(i,[1:i-1,i+1:n]));
end
[length,i]=max(row_min); row=[1:i-1,i+1:n]; j=row(row_which(i)); new_pair=sort([i j]);
end % function max_min_pair_length
%%%%%%%%%%%%%%%%%%%
function [seq,length,mod]=pairwise_swaps(seq,length,D,n)
mod=false;
for i=1:2:n-3
  for j=i+2:2:n-1
     x=D(seq(i),seq(i+1))+D(seq(j  ),seq(j+1));
     a=D(seq(i),seq(j  ))+D(seq(i+1),seq(j+1));
     b=D(seq(i),seq(j+1))+D(seq(j  ),seq(i+1));
     [M,N] = min([a b x]); switch N
        case 1, [seq(i+1),seq(j  )]=RR_Swap(seq(i+1),seq(j  )); mod=true; length=length-x+a;
        case 2, [seq(i+1),seq(j+1)]=RR_Swap(seq(i+1),seq(j+1)); mod=true; length=length-x+b;
     end
  end
end
end % function pairwise_swaps
%%%%%%%%%%%%%%%%%%%
function [seq,length,mod]=triplet_swaps(seq,length,D,n)
mod=false;
for i=1:2:n-5
  for j=i+2:2:n-3
    for k=j+2:2:n-1
       x=D(seq(i),seq(i+1)) +D(seq(j  ),seq(j+1)) +D(seq(k  ),seq(k+1));
       a=D(seq(i),seq(j  )) +D(seq(k  ),seq(j+1)) +D(seq(i+1),seq(k+1));
       b=D(seq(i),seq(j  )) +D(seq(k+1),seq(j+1)) +D(seq(k  ),seq(i+1));
       c=D(seq(i),seq(j+1)) +D(seq(j  ),seq(k  )) +D(seq(i+1),seq(k+1));
       d=D(seq(i),seq(j+1)) +D(seq(j  ),seq(k+1)) +D(seq(k  ),seq(i+1));
       e=D(seq(i),seq(k  )) +D(seq(i+1),seq(j+1)) +D(seq(j  ),seq(k+1));
       f=D(seq(i),seq(k+1)) +D(seq(i+1),seq(j+1)) +D(seq(k  ),seq(j  ));
       g=D(seq(i),seq(k  )) +D(seq(j  ),seq(i+1)) +D(seq(j+1),seq(k+1));
       h=D(seq(i),seq(k+1)) +D(seq(j  ),seq(i+1)) +D(seq(k  ),seq(j+1));
       [M,N] = min([a b c d e f g h x]); switch N
          case 1, [seq(k  ),seq(i+1),seq(j  )]=RR_Permute(seq(i+1),seq(j  ),seq(k  )); mod=true; length=length-x+a;
          case 2, [seq(k+1),seq(i+1),seq(j  )]=RR_Permute(seq(i+1),seq(j  ),seq(k+1)); mod=true; length=length-x+b;
          case 3, [seq(k  ),seq(i+1),seq(j+1)]=RR_Permute(seq(i+1),seq(j+1),seq(k  )); mod=true; length=length-x+c;
          case 4, [seq(k+1),seq(i+1),seq(j+1)]=RR_Permute(seq(i+1),seq(j+1),seq(k+1)); mod=true; length=length-x+d;
          case 5, [seq(j  ),seq(k  ),seq(i+1)]=RR_Permute(seq(i+1),seq(j  ),seq(k  )); mod=true; length=length-x+e;
          case 6, [seq(j  ),seq(k+1),seq(i+1)]=RR_Permute(seq(i+1),seq(j  ),seq(k+1)); mod=true; length=length-x+f;
          case 7, [seq(j+1),seq(k  ),seq(i+1)]=RR_Permute(seq(i+1),seq(j+1),seq(k  )); mod=true; length=length-x+g;
          case 8, [seq(j+1),seq(k+1),seq(i+1)]=RR_Permute(seq(i+1),seq(j+1),seq(k+1)); mod=true; length=length-x+h;
       end
    end
  end
end
end % function triplet_swaps
%%%%%%%%%%%%%%%%%%%