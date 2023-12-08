% semi_alpha=0.05 % 置信度为95%,有边分布
% confidence_level = 1-semi_alpha; 
% dof = 2; % 自由度为2
% 
% % 使用chi2inv计算卡方分布的临界值
% critical_value_R = chi2inv(confidence_level, dof);
% critical_value_L = chi2inv(semi_alpha, dof);
% 
% fprintf('卡方分布在90%%置信度和自由度为2的情况下的临界值是: %.4f %.4f\n', critical_value_R,critical_value_L);
% 
% alpha=0.05; % confidence_level:95% 0<xx<Right_critical_value
% confidence_level = 1-alpha; 
% dof = 2; % degrees of freedom: 2
% % Using chi2inv to calculate the Critical Value of Chi-Square Distribution
% critical_value = chi2inv(confidence_level, dof);
% fprintf('卡方分布在95%%置信度和自由度为2的情况下的临界值是: %.4f\n', critical_value);
a=[1.000000 2.000000 4.000000;4.000000 5.000000 6.000000;7.000000 8.000000 9.000000];
b=inv(a)