function [lam,S] = RC_EigSort(lam,S)                    % Numerical Renaissance Codebase 1.0
% This function sorts both the vector of eigenvalues, lam, and (if present) the matrix of
% eigenvectors, S, by the real parts of the eigenavlues.
% Note that the sorting algorithm used is developed in chapter 7.
[scratch,index]=RC_MergeSort(real(lam)); lam=lam(index); if (nargout>1), S=S(:,index); end
end % function RC_EigSort.m
