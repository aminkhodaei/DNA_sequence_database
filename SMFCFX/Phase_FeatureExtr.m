clear all
clc
format short
%% load data
load('output_Flu.mat')
signals = output;
fs = 8000;    
%% MFCC parameters 
win_size = 1.5; % 300
frameLength = win_size * round(0.025 * fs);      
overlapLength = round(frameLength/2); % 50% overlap
numCoefficients = 13;  % Number of MFCCs
numSignals = numel(signals);
features = zeros(numSignals, 1* (numCoefficients+1) * 6);  
for i = 1:numSignals
    signal = signals{i};
    if isrow(signal)
        signal = signal';
    end
    [coeffs, delta, deltaDelta, loc] = mfcc(signal, fs, ...
        'WindowLength', frameLength, ...
        'OverlapLength', overlapLength, ...
        'NumCoeffs', numCoefficients);
    
    f_coeffs     = [mean(coeffs, 1), std(coeffs, 0, 1), skewness(coeffs, 0, 1), kurtosis(coeffs, 0, 1), max(coeffs, [], 1), min(coeffs, [], 1)];
    features(i, :) = [f_coeffs];
end

save('features_Flu.mat','features')
