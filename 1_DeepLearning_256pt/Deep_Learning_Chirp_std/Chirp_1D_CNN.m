% 
clear all, clc;

load ('Chirp_25dB_Train.mat'); % 5000x256

load ('Chirp_25dB_Test.mat');  % 5000x256
load ('Chirp_20dB_Test.mat');  % 5000x256
load ('Chirp_15dB_Test.mat');  % 5000x256
load ('Chirp_10dB_Test.mat');  % 5000x256
load ('Target_LabelNumbered.mat');

% Numerical Data label and Categorical label with type of Signal
% deformation No deformation, Gaussian and LPB filter.
% Label {1 = NoDef, 2 = Gauss1, 3 = Gauss2, 4 = Pb1, 5 = Pb2}

% ------- Prepare ordered Balanced DataSet to randomly shuffle for training 
%               Generate a random permutation of indices
[numObservations,numLabels] = size(TrainMat_Chirp_25dB);
randomIndices = randperm(numObservations);

% Shuffle the Train data array using the random indices and convert to CELL
% datatype
TrainMat_Chirp_25dB_shuffle = TrainMat_Chirp_25dB(randomIndices,:); 
TrainMat_Chirp_25dB_shuffle = num2cell(TrainMat_Chirp_25dB_shuffle,2);

TestMat_Chirp_25dB = num2cell(TestMat_Chirp_25dB,2);
TestMat_Chirp_20dB = num2cell(TestMat_Chirp_20dB,2);
TestMat_Chirp_15dB = num2cell(TestMat_Chirp_15dB,2);
TestMat_Chirp_10dB = num2cell(TestMat_Chirp_10dB,2);

% Transpose Label array and shuffle using the random indices and convert to
% CATEGORICAL datatype
Target_LabelNumbered_shuffle = Target_LabelNumbered(randomIndices)'; %transpose
Target_LabelNumbered_shuffle = categorical(Target_LabelNumbered_shuffle);

% Partitioning the Shuffled DataSet
idxTrain        = floor(0.8 * numObservations);
idxValidation   = floor(0.1 * numObservations);
idxTest         = floor(0.1 * numObservations);

% [idxTrain,idxValidation,idxTest] = trainingPartitions(numObservations, [0.8 0.1 0.1]);

XTrain = TrainMat_Chirp_25dB_shuffle(1:idxTrain,:);
TTrain = Target_LabelNumbered_shuffle(1:idxTrain,:);

XValidation = TrainMat_Chirp_25dB_shuffle   (idxTrain+1 :idxTrain + idxValidation , :);
TValidation = Target_LabelNumbered_shuffle (idxTrain+1 :idxTrain + idxValidation, :);

XTest = TrainMat_Chirp_25dB_shuffle  (idxTrain + idxValidation + 1 : end, :);
TTest = Target_LabelNumbered_shuffle(idxTrain + idxValidation + 1 : end, :);
%--------------------------------------------------------------------------
filterSize = 5;
numFilters = 32;

numFeatures = 1; %size(XTrain{1},1); Cell Dimention
numClasses = 5;

layers = [ ...
    sequenceInputLayer(numFeatures)
    convolution1dLayer(filterSize,numFilters,Padding="causal")
    reluLayer
    layerNormalizationLayer
    convolution1dLayer(filterSize,2*numFilters,Padding="causal")
    reluLayer
    layerNormalizationLayer
    globalAveragePooling1dLayer
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

miniBatchSize = 27;

options = trainingOptions("adam", ...
    MaxEpochs=60, ...
    InitialLearnRate=0.01, ...
    SequencePaddingDirection="left", ...
    ValidationData={XValidation,TValidation}, ...
    Plots="training-progress", ...
    Verbose=0);

net = trainNetwork(XTrain',TTrain',layers,options);

% -------------------------------------------------------------------------
%---------- Load New DataSet for testing
% The TrueLabelData is ordered by class
TrueLabelData = categorical(Target_LabelNumbered'); % transpose the original label mat. Not Shuffled

YTest_25dB = classify(net,TestMat_Chirp_25dB, SequencePaddingDirection="left");
acc_25dB = mean(YTest_25dB == TrueLabelData) % comparing the predicted labels with the true.

YTest_20dB = classify(net,TestMat_Chirp_20dB, SequencePaddingDirection="left");
acc_20dB = mean(YTest_20dB == TrueLabelData)

YTest_15dB = classify(net,TestMat_Chirp_15dB, SequencePaddingDirection="left");
acc_15dB = mean(YTest_15dB == TrueLabelData)

YTest_10dB = classify(net,TestMat_Chirp_10dB, SequencePaddingDirection="left");
acc_10dB = mean(YTest_10dB == TrueLabelData)

figure
confusionchart(TrueLabelData,YTest_25dB) % confusionmat(trueLabels,predictedLabels)
figure
confusionchart(TrueLabelData,YTest_20dB)
figure
confusionchart(TrueLabelData,YTest_15dB)
figure
confusionchart(TrueLabelData,YTest_10dB)

% Save WorkOut
save('ChirpWorkspace'); % inputName