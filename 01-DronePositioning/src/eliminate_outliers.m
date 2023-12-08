function [Bsec,BallX,BUp,newBOUND] = eliminate_outliers(BOUND,alpha,DOF,dimension)

% semi_alpha=0.025; % confidence_level:95% Left_critical_value<xx<Right_critical_value
% confidence_level = 1-semi_alpha;
% dof = 2; % degrees of freedom: 2
% % Using chi2inv to calculate the Critical Value of Chi-Square Distribution
% critical_value_R = chi2inv(confidence_level, dof);
% critical_value_L = chi2inv(semi_alpha, dof);

%alpha=0.05; % confidence_level:95% 0<xx<Right_critical_value
confidence_level = 1-alpha;
dof = DOF; % degrees of freedom: 2
% Using chi2inv to calculate the Critical Value of Chi-Square Distribution
critical_value = chi2inv(confidence_level, dof);

for i=1:height(BOUND)
    if(BOUND(i,2)>=critical_value)||(abs(BOUND(i,5))>=10)
        BOUND(i,:)=0;
    end
end
nonZeroRows = all(BOUND ~= 0, 2);
newBOUND = BOUND(nonZeroRows, :);

Bsec=newBOUND(:,1);
BallX=newBOUND(:,3:(3+dimension-1));
BUp=newBOUND(:,width(BOUND));
end