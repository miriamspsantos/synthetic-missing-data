function [outputX,idc_xs] = muovGarciarena(inputX, mr, nxs)
% muovGarciarena(inputX, mr) MuOV data generation (Garciarena 2017)
% generates MNAR data (Missing Not At Random), according to procedure MuOV
% (Missingness depending on unobserved Variables): The patterns to have
% missing values in the features xs are randomly selected.
%
%
% INPUT:
%       inputX = matrix of data (n patterns x p features)
%       mr = missing rate (%) of the whole dataset
%       nxs = number of features to have missing values
%
% OUTPUT:
%       outputX with mr missing values in the nxs features
%
%
% EXAMPLE:
%
% X = rand(5,10)
% outputX = muovGarciarena(X, 50, 8)
%
%
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
%
%
% Copyright: Miriam Santos, 2017

outputX = inputX;
% Determine number of patterns n and number of features p in inputX
n = size(inputX,1);
p = size(inputX,2);


if (n*p*mr/100/nxs)>n
    error('Error:: Number of nxs is to low for specified missing rate.')
end

if nxs>=p
    error('Error:: Number of features to simulate is higher than the existing number of features.')
end


% Randomly choose the simulated features xs
idc_xs = randperm(p,nxs);

% Compute the number of patterns to have missing values
% Note that in MAR, all nxs variables are missing in the same indices,
% that is why we select patterns instead of xij values
N = round(n*p*mr/100/nxs);

% For MuOV generation, the N patterns are randomly selected
S = randperm(n,N);

% Introduce missing values in the selected patterns and features
outputX(S,idc_xs) = NaN;


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
