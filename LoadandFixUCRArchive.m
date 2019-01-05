% This script modifies the new UCR Time-Series Archive to make it backwards
% compatible with previous versions and enable older code and scripts to
% run without modifications.

% dir_old contains the current archive directory
% dir_new contains new, corrected, archive directory
dir_old = 'DATASETSOLD';
dir_new = 'DATASETSNEW';

% first 2 values are '.' and '..' - UCR Archive 2018 version has 128 datasets
dir_struct = dir('DATASETSOLD');
dataset_names = {dir_struct(3:130).name};

for i = 1:length(dataset_names)

    disp(['Dataset being processed: ', char(dataset_names(i))]);

    % directory structure
    dir_path_old = [dir_old,'/',char(dataset_names(i)),'/',char(dataset_names(i))];

    % load training and test sets
    TRAIN = load([dir_path_old,'_TRAIN']);
    TEST = load([dir_path_old,'_TEST']);

    % remove classes from time series
    TRAIN_labels = TRAIN(:,1);
    TRAIN(:,1) = [];
    TEST_labels = TEST(:,1);
    TEST(:,1) = [];


    % fill missing values for DodgerLoopDay, DodgerLoopGame, and
    % DodgerLoopWeekend datasets. Only three datasets have missing values.
    if ( strcmp('DodgerLoopDay',char(dataset_names(i))) || strcmp('DodgerLoopGame',char(dataset_names(i))) || strcmp('DodgerLoopWeekend',char(dataset_names(i))) )
        TRAIN = fillmissing(TRAIN, 'linear', 2, 'EndValues', 'nearest');
        TEST = fillmissing(TEST, 'linear', 2, 'EndValues', 'nearest');
    end

    % for datasets with varying time-series length we resample the shorter time
    % series to reach the length of the longest time series
    TRAIN = ResampleToMaxLength(TRAIN);
    TEST = ResampleToMaxLength(TEST);

    % z-normalize time series
    TEST = zscore(TEST,[],2);  
    TRAIN = zscore(TRAIN,[],2);

    % fixing issues with class names
    % Case 1: classes starting from 0 instead of 1
    if (min(TEST_labels) == 0 || min(TRAIN_labels == 0))
        TRAIN_labels = TRAIN_labels + 1;
        TEST_labels = TEST_labels + 1;
    end

    % Case 2: binary classes are -1 or 1 instead of 1 and 2
    if (min(TEST_labels) == -1 || min(TRAIN_labels == -1))
        TRAIN_labels = round(TRAIN_labels/2 + 1.5);
        TEST_labels = round(TEST_labels/2 + 1.5);
    end

    % Case 3: classes start from 3 instead of 1
    if (min(TEST_labels) == 3 || min(TRAIN_labels == 3))
        TRAIN_labels = TRAIN_labels - 2;
        TEST_labels = TEST_labels - 2;
    end                    

    % create new train and test datasets (i.e., merge labels with data)
    TRAIN = [TRAIN_labels,TRAIN];
    TEST = [TEST_labels,TEST];

    % save new datasets to new directory
    dir_path_new = [dir_new,'/',char(dataset_names(i)),'/',char(dataset_names(i))];

    dlmwrite([dir_path_new,'_TRAIN'],TRAIN, 'delimiter', ',','precision', 9);
    dlmwrite([dir_path_new,'_TEST'],TEST, 'delimiter', ',','precision', 9);
                    
end


function ResampledData = ResampleToMaxLength(Data)

    [rows, cols] = size(Data);
    ResampledData = zeros(rows, cols);

    for i = 1:rows
        singleTS = Data(i, :);
        singleTS = singleTS(~isnan(singleTS));

        ResampledData(i, :) = resample(singleTS, cols, length(singleTS));

    end

end