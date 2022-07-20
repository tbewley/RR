function RR_SuDokuSolve(F)
% function RR_SuDokuSolve(F)
% An involved recursive code for solving the SuDoku problems, emulating how a human plays.
% TEST with <a href="matlab:RR_SuDokuSolveTest">RR_SuDokuSolveTest</a>
% Numerical Renaissance codebase, Appendix A, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

% First, split SuDoku 9x9 array into a 3x3x3x3 array, which is easier for analysis
for i=1:3;for j=1:3;for k=1:3;for l=1:3; A(i,j,k,l)=F(i+(k-1)*3,j+(l-1)*3); end;end;end;end
PrintSuDoku(A), [A,B,flag]=PlaySuDoku(A);
PrintSuDoku(A), if flag==0; [A]=RecursiveSuDoku(A,B,flag); PrintSuDoku(A); end
end % function RR_SuDokuSolve
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [A,B,flag]=PlaySuDoku(A)
% This routine attempts to solve the SuDoku puzzle directly (without guessing).  
% On exit, flag=1 indicates that a unique solution has been found,
% flag=0 indicates uncertainty (i.e., not enough information to solve without guessing),
% flag=-1 indicates failure (i.e., the data provided is inconsistent).
B=ones(3,3,3,3,9); flag=0;  % B keeps track of all possible values of the unknown entries.
M=1; while M==1; M=0;  
  % M=1 means something has been determined this iteration, and we need to iterate again.
  for i=1:3; for j=1:3; for k=1:3; for l=1:3;                          % Fill B with A
     if A(i,j,k,l)>0; B(i,j,k,l,:)=0; B(i,j,k,l,A(i,j,k,l))=1; end
  end; end; end; end
  for i=1:3; for j=1:3; for k=1:3; for l=1:3; for m=1:3; for n=1:3;    % Reduce B checking
     if ((m~=j) | (n~=l)) & A(i,m,k,n)>0; B(i,j,k,l,A(i,m,k,n))=0; end % ... row    (i,k)
     if ((m~=i) | (n~=k)) & A(m,j,n,l)>0; B(i,j,k,l,A(m,j,n,l))=0; end % ... column (j,l)
     if ((m~=i) | (n~=j)) & A(m,n,k,l)>0; B(i,j,k,l,A(m,n,k,l))=0; end % ... square (k,l)
  end; end; end; end; end; end
  ME=1; while ME==1; ME=0; for i=1:3; for j=1:3; for k=1:3; for l=1:3; % Check each element
      E=sum(B(i,j,k,l,:));
      if E==0; flag=-1; return; elseif (E==1) & (A(i,j,k,l)==0);
        ME=1; M=1; [y,A(i,j,k,l)]=max(B(i,j,k,l,:));
      end
  end; end; end; end; end
  MR=1; while MR==1; MR=0; for i=1:3; for k=1:3; for m=1:9;            % Check each row
      R=sum(sum(B(i,:,k,:,m)));
      if R==0; flag=-1; return; elseif R==1; 
        [y1,jv]=max(B(i,:,k,:,m),[],2); [y1,l]=max(y1,[],4);
        if A(i,jv(l),k,l)==0; A(i,jv(l),k,l)=m; MR=1; M=1; end;
      end
  end; end; end; end
  MC=1; while MC==1; MC=0; for j=1:3; for l=1:3; for m=1:9;            % Check each column
      C=sum(sum(B(:,j,:,l,m)));
      if C==0; flag=-1; return; elseif C==1;
        [y2,iv]=max(B(:,j,:,l,m),[],1); [y2,k]=max(y2,[],3);
        if A(iv(k),j,k,l)==0; A(iv(k),j,k,l)=m; MC=1; M=1; end;
      end
  end; end; end; end
  MS=1; while MS==1; MS=0; for k=1:3; for l=1:3; for m=1:9;            % Check each square
      S=sum(sum(B(:,:,k,l,m)));
      if S==0; flag=-1; return; elseif S==1; 
        [y3,iv]=max(B(:,:,k,l,m),[],1); [y3,j]=max(y3,[],2);
        if A(iv(j),j,k,l)==0; A(iv(j),j,k,l)=m; MS=1; M=1; end;
      end
  end; end; end; end
end
if (min(min(min(min(A))))==1) flag=1; end;
end % function PlaySuDoku
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PrintSuDoku(A)
A=[A(:,:,1,1) A(:,:,1,2) A(:,:,1,3); A(:,:,2,1) A(:,:,2,2) A(:,:,2,3); ...
   A(:,:,3,1) A(:,:,3,2) A(:,:,3,3)]
end % function PrintSuDoku
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [A]=RecursiveSuDoku(A,B,flag)
% If the previous call to PlaySuDoku is inconclusive, then this routine coordinates
% recursively one or more guesses until a solution (which might not be unique) is found.
for i=1:3; for j=1:3; for k=1:3; for l=1:3;
  Asave=A; Bsave=B;
  if A(i,j,k,l)==0; for m=1:9; if B(i,j,k,l,m)==1; 
    disp(sprintf('Guessing A(%d,%d)=%d',i+(k-1)*3,j+(l-1)*3,m))
    A(i,j,k,l)=m; [A,B,flag]=PlaySuDoku(A);
    if flag==-1;    disp('failure');   A=Asave; B=Bsave;
    elseif flag==0; disp('uncertain'); [A]=RecursiveSuDoku(A,B,flag); return;
    else;           disp('DONE!');     return
    end
  end; end; end
end; end; end; end
end % function RecursiveSuDoku
