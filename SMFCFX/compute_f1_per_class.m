function f1_per_class = compute_f1_per_class(confMat)
    TP = diag(confMat);
    FP = sum(confMat, 1)' - TP;
    FN = sum(confMat, 2) - TP;
    precision = TP ./ (TP + FP);
    recall = TP ./ (TP + FN);
    precision(isnan(precision)) = 0;
    recall(isnan(recall)) = 0;
    f1_per_class = 2 * (precision .* recall) ./ (precision + recall);
    f1_per_class(isnan(f1_per_class)) = 0; 
end
