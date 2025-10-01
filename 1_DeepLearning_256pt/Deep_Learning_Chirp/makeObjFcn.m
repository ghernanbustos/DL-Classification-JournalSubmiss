function ObjFcn = makeObjFcn(XTrain,TTrain,XValidation,TValidation)
ObjFcn = @valErrorFun;
    function [valError,cons,fileName] = valErrorFun(optVars)

        numFeatures = 1;
        numClasses = 5;
        numF = round(16/sqrt(optVars.SectionDepth));
        layers = [
            sequenceInputLayer(numFeatures)
            
            % The spatial input and output sizes of these convolutional
            % layers are 32-by-32, and the following max pooling layer
            % reduces this to 16-by-16.
            convBlock(3,numF,optVars.SectionDepth)
            % maxPooling2dLayer(3,'Stride',2,'Padding','same')
            
            % The spatial input and output sizes of these convolutional
            % layers are 16-by-16, and the following max pooling layer
            % reduces this to 8-by-8.
            convBlock(3,2*numF,optVars.SectionDepth)
            % maxPooling2dLayer(3,'Stride',2,'Padding','same')
            
            % The spatial input and output sizes of these convolutional
            % layers are 8-by-8. The global average pooling layer averages
            % over the 8-by-8 inputs, giving an output of size
            % 1-by-1-by-4*initialNumFilters. With a global average
            % pooling layer, the final classification output is only
            % sensitive to the total amount of each feature present in the
            % input image, but insensitive to the spatial positions of the
            % features.
            % convBlock(3,4*numF,optVars.SectionDepth)
            % averagePooling2dLayer(8)
            
            % Add the fully connected layer and the final softmax and
            % classification layers.
            globalAveragePooling1dLayer
            fullyConnectedLayer(numClasses)
            softmaxLayer
            classificationLayer];

        miniBatchSize = 27;
        validationFrequency = floor(numel(TTrain)/miniBatchSize);

        options = trainingOptions('sgdm', ...
            'InitialLearnRate',optVars.InitialLearnRate, ...
            'Momentum',optVars.Momentum, ...
            'MaxEpochs',60, ...
            'LearnRateSchedule','piecewise', ...
            'LearnRateDropPeriod',40, ...
            'LearnRateDropFactor',0.1, ...
            'MiniBatchSize',miniBatchSize, ...
            'L2Regularization',optVars.L2Regularization, ...
            'Shuffle','every-epoch', ...
            'Verbose',false, ...
            'Plots','training-progress', ...
            'ValidationData',{XValidation,TValidation}, ...
            'ValidationFrequency',validationFrequency);
%         pixelRange = [-4 4];
% imageAugmenter = imageDataAugmenter( ...
%     'RandXReflection',true, ...
%     'RandXTranslation',pixelRange, ...
%     'RandYTranslation',pixelRange);
% datasource = augmentedImageDatastore(numFeatures,XTrain,TTrain,'DataAugmentation',imageAugmenter);

        trainedNet = trainNetwork(XTrain',TTrain',layers,options);
        close(findall(groot,'Tag','NNET_CNN_TRAININGPLOT_UIFIGURE'))
                YPredicted = classify(trainedNet,XValidation);
        valError = 1 - mean(YPredicted == TValidation);
                fileName = num2str(valError) + ".mat";
        save(fileName,'trainedNet','valError','options')
        cons = [];
        
    end
end
