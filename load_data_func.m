
%% load data

function [data_M, img_PCA, label_M] = load_data_func(data_type, num_classes)

if strcmp(data_type, 'IP')
    load IP_200_M;
end
if strcmp(data_type, 'PU')
    load PU_103_M;
end
if strcmp(data_type, 'PC')
    load PC_102_M;
end
if strcmp(data_type, 'SA')
    load SA_204_M;
end

load(['Label_M_',data_type,'_',num2str(num_classes),'.mat']);

img_PCA = imread([data_type, '_PCA.tif']);

