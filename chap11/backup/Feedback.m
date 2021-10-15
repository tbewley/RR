function [numc,denc]=Feedback(numo,deno)
n=length(deno); m=length(numo); numc=numo; denc=deno+[zeros(1,n-m) numo];
end % function Feedback
