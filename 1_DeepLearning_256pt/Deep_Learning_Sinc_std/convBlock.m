function layers = convBlock(filterSize,numFilters,numConvLayers)
layers = [
    convolution1dLayer(filterSize,numFilters,Padding="causal")
    reluLayer
    layerNormalizationLayer];
layers = repmat(layers,numConvLayers,1);
end