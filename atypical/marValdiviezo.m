function [outputX,xd] = marValdiviezo(inputX, mr, type)
% marValdiviezo(inputX, mr) MAR data generation (Valdiviezo 2015)
% generates MAR data (Missing At Random). When defined as 'all', it used
% one determining feature chosen at random and transforms their values
% according to a logistic function. Then, p-1 features are replaced by NaN.
% It type is 'third', then only one third of features will have missing
% values (the MR is adjusted accordinly).
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
% outputX = marValdiviezo(X, 50, 'all')
% outputX = marValdiviezo(X, 10, 'third')
%
%
% Copyright: Miriam Santos, 2018


if (mr > 100/3) && (strcmp(type,'third'))
    error('Error: Missing Rate is too high for "one third" scheme.')
end


outputX = inputX;
% Determine number of patterns n and number of features p in inputX
n = size(inputX,1);
p = size(inputX,2);


if mr > 100*(1-1/p)
    error('Error: Missing Rate is too high, all the p-1 features will be deleted.')
end


% Choose a determining feature at random
vars = 1:p;
xd = randi(p);
vars(xd) = [];

% Transform that feature into a probability by logistic function
xlog = Logistic(inputX(:,xd));



% Get the type of generation:
switch type
    case 'all'
        % Determine how many elements should be missing in each feature
        T = round(n*p*mr/100/(p-1));
        idx = samplefromp(n,xlog,T);
        outputX(idx,vars) = NaN;

    case 'third'
        % Adjust missing values accordingly
        T = round(n*3*mr/100);

        % Choose p/3 features at random
        np = round(p/3);
        pidx = randperm(length(vars),np);
        idx = samplefromp(n,xlog,T);
        outputX(idx,vars(pidx)) = NaN;

end


end
