% Example of use
% This example extracts the pulse and calc max and min sizes to show the
% pulse width variations during detection process.

clear all;
% Raw data signal, is not normalized.
load('Chirp_25dB_Test.mat');
% load('Sinc_10dB_Test.mat');
% Init vars
maxPulsearraySize = 0;
minPulsearraySize = 256;
clear OSig
OSig = Metodo_ESSC_ANN_V2(); % Construct Object Variable

% Generate time vector
    nColumns = size(TestMat_Chirp_25dB(1,:),2);
    timeArray = linspace(0, 1, nColumns);

% figure
%     plot(timeArray,TrainMat_Sinc_25dB(500,:));

% Sinc data signal

for nRow = 1: size(TestMat_Chirp_25dB,1)

    OSig.Carga_Signal(TestMat_Chirp_25dB(nRow,:), timeArray);
    detectedPulse = OSig.PulseExtraction();
    detectedPulseSize = size(detectedPulse,2);
    if  detectedPulseSize > maxPulsearraySize
         maxPulsearraySize = detectedPulseSize;
    end

end

for nRow = 1: size(TestMat_Chirp_25dB,1)

    OSig.Carga_Signal(TestMat_Chirp_25dB(nRow,:), timeArray);
    detectedPulse = OSig.PulseExtraction();
    detectedPulseSize = size(detectedPulse,2);
    if  detectedPulseSize < minPulsearraySize
         minPulsearraySize = detectedPulseSize;
    end

end

display(maxPulsearraySize);
display(minPulsearraySize);

% figure
%     plot(detectedPulse); % Check array size