function outputX = mcarValdiviezo(inputX, mr, type)
% mcarValdiviezo(inputX, mr, type) MCAR data generation (Valdiviezo 2015)
% generates MCAR data (Missing Completely At Random). It takes a matrix of data n x p
% (patterns x features) and the desired missing rate mr, and replaces
% random elements in each feature by NaN. In this implementations, features
% will have the same number of missing elements.
%
%
% INPUT:
%       inputX = matrix of data (n patterns x p features)
%       mr = missing rate (%) of the whole dataset
%       type = type of generation of MCAR data:
%             -- 'all' for all features to be considered
%             -- 'third' to select only one third of features (randomly)
%
% OUTPUT:
%       outputX with mr missing values
%
%
% EXAMPLE:
% X = rand(300,30)
% outputX = mcarValdiviezo(X, 50, 'all')
% outputX = mcarValdiviezo(X, 10, 'third')
%
% Copyright: Miriam Santos, 2018


if (mr >= 100)
    error('Error: Missing Rate is too high, all the features will be deleted.')
end

if (mr > 100/3) && (strcmp(type,'third'))
     error('Error: Missing Rate is too high for "one third" scheme.')
end


outputX = inputX;
% Determine number of patterns n and number of features p in inputX
n = size(inputX,1);
p = size(inputX,2);



% Get the type of generation:
switch type
    case 'all'
        % Determine how many elements should be missing in each feature
        T = round(n*mr/100);
        for i = 1:p
             xi = randperm(n,T);
             outputX(xi,i) = NaN;
        end

    case 'third'
        % Adjust missing values accordinggly
        T = round(n*3*mr/100);

        % Choose p/3 features at random
        np = round(p/3);
        pidx = randperm(p,np);

        for i = 1:np
            xi = randperm(n,T);
            outputX(xi,pidx(i)) = NaN;
        end
end



%%
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
