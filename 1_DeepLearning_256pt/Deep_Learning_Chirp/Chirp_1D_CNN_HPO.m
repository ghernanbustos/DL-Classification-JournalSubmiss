% 
clear all, clc;

load ('Chirp_25dB_Train.mat'); % 5000x1024

load ('Chirp_25dB_Test.mat');  % 5000x1024
load ('Chirp_20dB_Test.mat');  % 5000x1024
load ('Chirp_15dB_Test.mat');  % 5000x1024
load ('Chirp_10dB_Test.mat');  % 5000x1024
load ('Target_LabelNumbered.mat');

% Numerical Data label and Categorical label with type of Signal
% deformation No deformation, Chirpian and LPB filter.
% Label {1 = NoDef, 2 = Chirp1, 3 = Chirp2, 4 = Pb1, 5 = Pb2}

% ------- Prepare DataSet from Ordered Balanced to randomly shuffle  
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
%------------------- HPO 1D-CNN -------------------------------------------

optimVars = [
    optimizableVariable('SectionDepth',[1 3],'Type','integer')
    optimizableVariable('InitialLearnRate',[1e-2 1],'Transform','log')
    optimizableVariable('Momentum',[0.8 0.98])
    optimizableVariable('L2Regularization',[1e-10 1e-2],'Transform','log')];

ObjFcn = makeObjFcn(XTrain,TTrain,XValidation,TValidation);

% Calls bayesopt function
BayesObject = bayesopt(ObjFcn,optimVars, ...
    'MaxTime',14*60*60, ...
    'IsObjectiveDeterministic',false, ...
    'UseParallel',false);

% ---------------------- 1D-CNN architecture ------------------------------
bestIdx = BayesObject.IndexOfMinimumTrace(end);
fileName = BayesObject.UserDataTrace{bestIdx};
BestAnn = load(fileName); % Loads Best 1D-CNN


TrueLabelData = categorical(Target_LabelNumbered'); % transpose the original label mat. Not Shuffled

YTest_25dB = classify(BestAnn.trainedNet,TestMat_Chirp_25dB, SequencePaddingDirection="left");
acc_25dB = mean(YTest_25dB == TrueLabelData) % comparing the predicted labels with the true.

YTest_20dB = classify(BestAnn.trainedNet,TestMat_Chirp_20dB, SequencePaddingDirection="left");
acc_20dB = mean(YTest_20dB == TrueLabelData)

YTest_15dB = classify(BestAnn.trainedNet,TestMat_Chirp_15dB, SequencePaddingDirection="left");
acc_15dB = mean(YTest_15dB == TrueLabelData)

YTest_10dB = classify(BestAnn.trainedNet,TestMat_Chirp_10dB, SequencePaddingDirection="left");
acc_10dB = mean(YTest_10dB == TrueLabelData)

% ---------------------- Save Acc% Data file ------------------------------

% Open a text file for writing
fileID = fopen('Acc_Ann_Chirp.txt', 'w');

% Check if file opened successfully
if fileID == -1
    error('Error opening the file.');
end

% Write variables to the file
fprintf(fileID, 'Accuracy Values at different SNR test DataSet with ANN trained under HPO Bayesian Optimization\n', acc_25dB);
fprintf(fileID, 'Acc_Ann_25dB = %g\n', acc_25dB);
fprintf(fileID, 'Acc_Ann_20dB = %g\n', acc_20dB);
fprintf(fileID, 'Acc_Ann_15dB = %g\n', acc_15dB);
fprintf(fileID, 'Acc_Ann_10dB = %g\n', acc_10dB);

% Close the file
fclose(fileID);


% figure
% confusionchart(TrueLabelData,YTest_25dB)
% figure
% confusionchart(TrueLabelData,YTest_20dB)
% figure
% confusionchart(TrueLabelData,YTest_15dB)
% figure
% confusionchart(TrueLabelData,YTest_10dB)
% 
% Save WorkOut
save('ChirpWorkspace'); % inputName

