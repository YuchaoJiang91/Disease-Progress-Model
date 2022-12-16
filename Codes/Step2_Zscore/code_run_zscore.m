%% The code_run_zscore.m is to calculated the zscore of each ROI.
% Written by Yuchao Jiang.
% Institute of Science and Technology for Brain-lnspired Intelligence (ISTBI)
% Fudan University, 220 Handan Road
% Shanghai 200433, CHINA
% yuchaojiang@fudan.edu.cn    jiangyc_uestc@163.com 

%% please first copy VBM results (i.e., mwp1*.nii) into the folder '...\enigma_VBM_17ROI\ROIextract\inputdata\'
clc;clear;
%folderpath = '...\enigma_VBM_17ROI\ROIextract'; 
folderpath = 'G:\Sustain_P1\sustain\SuStaInModel\Step2_Zscore';

%% ---------------------------------------------------------------
% No need to modify the following codes
cd(folderpath);
%addpath([folderpath,filesep,'subfunction']);
data=xlsread(['inputdata',filesep,'inputdata.xlsx']);

data_subjectID = data(:,1);
data_site = data(:,2);
data_group = data(:,3);
data_cov = data(:,4:7);
data_GMV = data(:,8:end);

% transform site_label into dummy covariates
site_label = unique(data_site);
cov_site = zeros(length(data_site),length(site_label));
for i = 1:length(site_label)
    temp_k = site_label(i);
    cov_site([data_site == temp_k], i) = 1;
end

% regressing out covariates including gender, age, age2, TIV, sites 
data_covariates = [data(:,4:7),cov_site];
data_GMV_decov = Jyc_matrix_covariate_regress(data_GMV,data_covariates);

% transform GMV into z score
temp_SZ = data_GMV_decov(data_group==1,:);
temp_HC = data_GMV_decov(data_group==2,:);

temp_HC_mean = mean(temp_HC,1);
temp_HC_std = std(temp_HC,1,1);

for i = 1:size(data_GMV_decov,1)
    data_GMV_zscore(i,:) = (temp_HC_mean - data_GMV_decov(i,:)) ./ temp_HC_std;
end

output = [data_subjectID,data_site,data_group,data_cov,data_GMV_zscore];

% save output
xlswrite('output_zscore.xlsx',output);
save([folderpath,filesep,'output_zscore.mat'],'output');

