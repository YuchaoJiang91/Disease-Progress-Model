%% The code_run.m is to Extract 17 ROI values from the VBM results.
% Written by Yuchao Jiang.
% Institute of Science and Technology for Brain-lnspired Intelligence (ISTBI)
% Fudan University, 220 Handan Road
% Shanghai 200433, CHINA
% yuchaojiang@fudan.edu.cn    jiangyc_uestc@163.com 

%% please first copy VBM results (i.e., mwp1*.nii) into the folder '...\enigma_VBM_17ROI\ROIextract\inputdata\'
clc;clear;
%folderpath = '...\enigma_VBM_17ROI\ROIextract'; 
folderpath = 'G:\Sustain_P1\sustain\SuStaInModel\Step1_ROIextract';

%% ---------------------------------------------------------------
% No need to modify the following codes
cd(folderpath);
%addpath([folderpath,filesep,'subfunction']);
[AllVolume,VoxelSize,theImgFileList, Header]  = y_ReadAll([folderpath,filesep,'inputdata']);

AllVolume(find(isnan(AllVolume))) = 0; %Set the NaN voxels to 0.
[nDim1 nDim2 nDim3 nDimSubjects]=size(AllVolume);
BrainSize = [nDim1 nDim2 nDim3];
BrainVoxelNumber = nDim1 * nDim2 * nDim3;
% Convert into 2D
AllVolume=reshape(AllVolume,[],nDimSubjects)';

% load the atlas.nii
if BrainVoxelNumber == 113*137*113
    aal2_file = [folderpath,filesep,'Atlas',filesep,'Atlas_AAL2_113x137x113.nii'];
    aal3_file = [folderpath,filesep,'Atlas',filesep,'Atlas_AAL3_113x137x113.nii'];
elseif BrainVoxelNumber == 121*145*121
    aal2_file = [folderpath,filesep,'Atlas',filesep,'Atlas_AAL2_121x145x121.nii'];
    aal3_file = [folderpath,filesep,'Atlas',filesep,'Atlas_AAL3_121x145x121.nii'];
elseif BrainVoxelNumber == 91*109*91
    aal2_file = [folderpath,filesep,'Atlas',filesep,'Atlas_AAL2_91x109x91.nii'];
    aal3_file = [folderpath,filesep,'Atlas',filesep,'Atlas_AAL3_91x109x91.nii'];    
else
    disp('the dimension between AAL atlas and mwp1*.nii is not matched');
end

% extract 16 ROI values from each roi of AAL2 
[Mask_AAL2 ~] = y_Read(aal2_file);
MaskDataOneDim=reshape(Mask_AAL2,1,[]);

for j = 1 : nDimSubjects
    disp(['processing subject n = ',num2str(j)]);
    for i = 1:120
        temp_data = double(AllVolume(j,:) .* (MaskDataOneDim == i));
        AALdata(j,i) = mean(nonzeros(temp_data));
    end    
end

% extract NAC value from AAL3
[Mask_AAL3 ~] = y_Read(aal3_file);
MaskDataOneDim=reshape(Mask_AAL3,1,[]);

for j = 1 : nDimSubjects
    disp(['processing subject n = ',num2str(j)]);
    temp_data = double(AllVolume(j,:) .* (MaskDataOneDim == 157)); % the label of NAC in AAL3 is 157 AND 158
    AALdata(j,121) = mean(nonzeros(temp_data));   
    temp_data = double(AllVolume(j,:) .* (MaskDataOneDim == 158));
    AALdata(j,122) = mean(nonzeros(temp_data));   
end

% 122 AAL rois were separated into 17 rois
load([folderpath,filesep,'Atlas',filesep,'ROI17_label.mat']);
for k = 1:17
    AALdata2(:,k) = mean(AALdata(:,find(AAL_num==k)),2);
end

output.ROI17value = AALdata2;
output.ImgFileList = theImgFileList;
output.ROI17label = ROI17_label;

% save output
xlswrite('output_roiGMV.xlsx',AALdata2);
save([folderpath,filesep,'output_roiGMV.mat'],'output');

