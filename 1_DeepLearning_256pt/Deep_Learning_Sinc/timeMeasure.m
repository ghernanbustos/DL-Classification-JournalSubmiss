% Measure execution time.
% Load SincWorkspace.mat file to access the best ANN trained.
% This code aims to measure execution time of 1D-CNN algorithm while
% classifing a whole datase. 
% Use timeit for fair comparisons in scientific publications.
clear all;
clc;

load SincWorkspace.mat;
load sinc_gauss1_25dB_testElement.mat;

%original data sample is 1024, nos subsample 1024 to 256
data_256 = downsample(sinc_gauss1_amp, 4);

% Check if one element or the whole Dataset
% f = @() cnn_computingTime(BestAnn.trainedNet,num2cell(data_256) ); % handle to function
f = @() cnn_computingTime(BestAnn.trainedNet,data_256); % handle to function

nTimer = 100;
timeArray = zeros(nTimer,1);

for i= 1: nTimer
    timeArray(i,:) =  timeit(f);
end

mean(timeArray)
std(timeArray)