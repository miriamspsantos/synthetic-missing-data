function [outputX, idx_xd, idc_xs] = MAR1unifo(inputX, mr, nxs)
% MAR1unifo(inputX, mr) MAR data generation (Garciarena 2017)
% generates MAR data (Missing At Random). It takes a matrix of data n x p
% (patterns x features) and chooses a determining/causative feature xd
% randomly. The missing rate mr and number of features to have missing
% values, nxs, need to be specified. The values in the selected features xs
% will be missing for the lowest values of xd.
%
%
% INPUT:
%       inputX = matrix of data (n patterns x p features)
%       mr = missing rate (%) of the whole dataset
%       nxs = number of features to have missing values
%
% OUTPUT:
%       outputX with mr missing values in the nxs features
%       The last feature is outputX is the determining/causative feature
%
% EXAMPLE:
% X = rand(5,10)
% outputX = MAR1unifo(X, 50, 8)
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
% Last update: 20-10-2017

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


% Randomly choose the determining feature, xd and save it as an auxiliar
% variable
idx_xd = randi(p);
aux_xd = inputX(:,idx_xd);



% Randomly choose the simulated features xs (cannot be the same as xd)
values = 1:p;
values(idx_xd) = []; % idx_xd cannot be chosen
idc_xs = values(randperm(numel(values),nxs));


% Compute the number of patterns to have missing values
% Note that in MAR, all nxs variables are missing in the same indices,
% that is why we select patterns instead of xij values

N = round(n*p*mr/100/nxs);

% Determine the N lowest values of the determining feature xd
[~, xd_order] = sort(aux_xd);
lowestNindex = xd_order(1:N);


% Introduce the missing values in the features nxs corresponding to the
% indices of X where xd has the lowest values
outputX(lowestNindex,idc_xs) = NaN;


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
