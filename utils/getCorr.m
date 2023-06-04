function idx_xd = getCorr(inputX, idx_xs, ftypes)
% getCorr(inputX, idx_xs, ftypes) determines the feature most correlated
% with xs.
% 
% 
%   INPUT:
%       inputX: dataset X
%       idx_xs: index of feature to be missing (chosen feature)
%       ftypes: types of features accordig to arff codes (SEE arff2double)
% 
%   OUTPUT:
%       idx_xd: index of feature most correlated with xs
% 
% 
%   EXAMPLES:
% X = rand(100,4);
% ftypes = [0 0 0 0];
% idx_xs = 4;
% idx_xd = getCorr(inputX, idx_xs, ftypes)
% 
% 
% 
% Copyright: Miriam Santos, 2017


p = size(inputX, 2);

% Get correlation of the remaining features with xs (inputX(:,idx_xs))
for i = 1:p
    rxs(i) = association(inputX(:,i), inputX(:,idx_xs), ftypes(i), ftypes(idx_xs));
end

rxs(idx_xs) = NaN;
[~, idx_xd] = max(rxs);


end

