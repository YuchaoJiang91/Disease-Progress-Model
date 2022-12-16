function [result_data] = Jyc_matrix_covariate_regress(data_Y, data_cov)

%% 此函数是对一个MxN的矩阵进行去协变量处理，M为被试个数，N为脑区个数

% Input: data_Y: M x N的矩阵，M为被试个数，N为脑区个数
%        data_cov： M x K 的矩阵，K为协变量个数
% Output：result_data: 一个新的M x N的矩阵，这个矩阵就是data_Y去除斜变量data_cov后的残差


M = size(data_Y,1);
N = size(data_Y,2);


X = data_cov;

for i = 1:N
    
    y = data_Y(:,i);
    
    [b,bint,r] = regress(y,X);
    
    result_data(:,i) = r;
end;



