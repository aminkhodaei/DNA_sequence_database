function f1 = compute_macro_f1(confMat)
    numClasses = size(confMat, 1);
    f1s = zeros(numClasses, 1);
    for i = 1:numClasses
        tp = confMat(i,i);
        fp = sum(confMat(:,i)) - tp;
        fn = sum(confMat(i,:)) - tp;
        precision = tp / (tp + fp + eps);
        recall = tp / (tp + fn + eps);
        f1s(i) = 2 * precision * recall / (precision + recall + eps);
    end
    f1 = mean(f1s);
end