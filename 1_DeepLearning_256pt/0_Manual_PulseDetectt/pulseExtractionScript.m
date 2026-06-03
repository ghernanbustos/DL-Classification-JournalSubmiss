% Example of use
% This example extracts the pulse and calc max and min sizes to show the
% pulse width variations during detection process.

clear all;
% Raw data signal, is not normalized.
load('Sinc_25dB_Train.mat');

load ('Sinc_25dB_Test.mat');  % 5000x1024
load ('Sinc_20dB_Test.mat');  % 5000x1024
load ('Sinc_15dB_Test.mat');  % 5000x1024
load ('Sinc_10dB_Test.mat');  % 5000x1024

% Preallocate Cell array
Sinc_25dB_Train_Cell = cell(size(TrainMat_Sinc_25dB,1),1);

% Sinc_25dB_Train_Cell = cell(size(Sinc_25dB_Test,1),1);
% Sinc_20dB_Train_Cell = cell(size(Sinc_20dB_Test,1),1);
% Sinc_15dB_Train_Cell = cell(size(Sinc_15dB_Test,1),1);
% Sinc_10dB_Train_Cell = cell(size(Sinc_10dB_Test,1),1);

%  Object Variable initialization.
clear OSig
OSig = Metodo_ESSC_ANN_V2();            % Construct Object Variable

nColumns = size(TrainMat_Sinc_25dB(1,:),2);
timeArray = linspace(0, 1, nColumns);   % Dumb Variable needed by method

% Generate time vector
    % nRow = size(TrainMat_Sinc_25dB,1);
    

for nRow = 1 : size(TrainMat_Sinc_25dB,1)
    OSig.Carga_Signal(TrainMat_Sinc_25dB(nRow,:), timeArray);
    detectedPulse = OSig.PulseExtraction();
    detectedPulse_n = rescale(detectedPulse,-1,1); % Normalize
    Sinc_25dB_Train_Cell{nRow} = num2cell(detectedPulse_n);
end
 




% figure
%     plot(timeArray,TrainMat_Sinc_25dB(500,:));
figure
    plot(detectedPulse_n); % Check array size
% 
% TrainMat_Sinc_25dB_shuffle = TrainMat_Sinc_25dB(randomIndices,:); 
% TrainMat_Sinc_25dB_shuffle = num2cell(TrainMat_Sinc_25dB_shuffle,2);
% 
% TestMat_Sinc_25dB = num2cell(TestMat_Sinc_25dB,2);
% TestMat_Sinc_20dB = num2cell(TestMat_Sinc_20dB,2);
% TestMat_Sinc_15dB = num2cell(TestMat_Sinc_15dB,2);
% TestMat_Sinc_10dB = num2cell(TestMat_Sinc_10dB,2);