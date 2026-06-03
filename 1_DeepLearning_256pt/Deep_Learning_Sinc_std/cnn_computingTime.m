function [Y_pred] = cnn_computingTime(net, X)


% Standardize 
X_std = rescale(X,-1,1); 
Y_pred = classify(net,X);

end

