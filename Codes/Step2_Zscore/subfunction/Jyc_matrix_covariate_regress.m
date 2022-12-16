function [result_data] = Jyc_matrix_covariate_regress(data_Y, data_cov)

%% �˺����Ƕ�һ��MxN�ľ������ȥЭ��������MΪ���Ը�����NΪ��������

% Input: data_Y: M x N�ľ���MΪ���Ը�����NΪ��������
%        data_cov�� M x K �ľ���KΪЭ��������
% Output��result_data: һ���µ�M x N�ľ�������������data_Yȥ��б����data_cov��Ĳв�


M = size(data_Y,1);
N = size(data_Y,2);


X = data_cov;

for i = 1:N
    
    y = data_Y(:,i);
    
    [b,bint,r] = regress(y,X);
    
    result_data(:,i) = r;
end;



