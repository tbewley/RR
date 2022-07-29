function [numT,denT]=Feedback(numL,denL)
numT=numL; denT=PolyAdd(numL,denL); [numT,denT]=RationalSimplify(numT,denT);
end % function Feedback
