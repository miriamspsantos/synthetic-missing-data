function outputX = MCAR2unifo(inputX, mr)
% MCAR2unifo(inputX, mr) MCAR data generation (Garciarena 2017)
% generates MCAR data (Missing Completely At Random). It takes a matrix of data n x p
% (patterns x features) and the desired missing rate mr, determines how
% many xij elements in X should be missing and replaces them with NaN.
%
%
% INPUT:
%       inputX = matrix of data (n patterns x p features)
%       mr = missing rate (%) of the whole dataset
%
% OUTPUT:
%       outputX with mr missing values
%
%
% EXAMPLE:
% X = rand(5,10)
% outputX = MCAR2unifo(X, 50)
%
% REFERENCES:
%@article{garciarena2017extensive,
%  title={An extensive analysis of the interaction between missing data types, imputation methods, and supervised classifiers},
%  author={Garciarena, Unai and Santana, Roberto},
%  journal={Expert Systems with Applications},
%  volume={89},
%  pages={52--65},
%  year={2017},
%  publisher={Elsevier}
%}


outputX = inputX;
% Determine number of patterns n and number of features p in inputX
n = size(inputX,1);
p = size(inputX,2);

% Determine the number of elements xij to be missing, T
T = round((n*p*mr/100));

xij = randperm(n*p,T);
outputX(xij) = NaN;


% Return a warning if some patterns or some features are completely
% missing, or have only some values (defined by thresh)

% Number of features with all values missing (or only one value)

%------------------------------------------------------------------------
% Number of existing (non-NaN) values for each is considered 'risk'
thresh = 1;
%------------------------------------------------------------------------

nFeaturesRisk = sum(ge(sum(isnan(outputX)), n-thresh));
nPatternsRisk = sum(ge(sum(isnan(outputX),2),p-thresh));

if (nFeaturesRisk > 0)
    warning('FEATURES in risk of being all NaN: %d',nFeaturesRisk)
end


if (nPatternsRisk > 0)
    warning('PATTERNS in risk of being all NaN: %d',nPatternsRisk)
end

end
