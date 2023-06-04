function [outputX,idc_xs] = MNAR1unifo(inputX, mr, nxs)
% MNAR1unifo(inputX, mr) MIV data generation (Garciarena 2017)
% generates MNAR data (Missing Not At Random), according to procedure MIV
% (Missingness depending on its Value Itself): The lowest values in the
% randomly selected xs features are set to NaN.
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
% outputX = MNAR1unifo(X, 50, 8)
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

% For each selected feature xs, determine it lowest N values and replace
% them with NaN
for i = 1:nxs
% Determine the N lowest of xs
[~, xd_order] = sort(inputX(:,idc_xs(i)));
lowestNindex = xd_order(1:N);

% Introduce the missing values in the features nxs corresponding to the
% indices of X where xd has the lowest values
outputX(lowestNindex,idc_xs(i)) = NaN;


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
