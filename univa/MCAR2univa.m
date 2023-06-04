function [outputX, idx] = MCAR2univa(inputX, mr, flag, varargin)
% MCAR2univa(inputX, mr, varargin) performs MCAR from Rieger10.
%
% INPUT:
%   inputX: matrix of data (n patterns x p features)
%   mr: missing rate (%):
%               -- of the whole dataset if flag is 1
%               -- of that feature if flag is 0
%
%   flag:
%       -- if 1, then correction for mr of whole dataset is applied (N = p*mr)
%       -- if 0, mr is considered to be of that feature alone
%
% varargin:
%           -- if nothing is defined, then idx (feature to have missing
%               values) is randomly chosen
%           -- if its a number, the idx is specified by varargin{1}
%
% OUTPUT:
%   outputX: outputX with mr missing values in one feature
%
% EXAMPLE:
% X = rand(200,10)
% mr = 10;
% [outputX, idx] = MCAR2univa(X, mr, 0)
% [outputX, idx] = MCAR2univa(X, mr, 0, 4)
%
%
% REFERENCES:
% @article{Rieger10,
%   title={Random forests with missing values in the covariates},
%   author={Rieger, Anna and Hothorn, Torsten and Strobl, Carolin},
%   year={2010}
% }
%
% Copyright: Miriam Santos, 2017

outputX = inputX;

% Determine number of patterns n and number of features p in inputX
n = size(inputX,1);
p = size(inputX,2);


if flag
    if (mr >= 100/p)
        error('Error:: Missing Rate is too high for the existing number of features.');
    end
    N = round(n*p*mr/100); % Correction for mr of whole dataset
else
    if (mr >= 100)
        error('Error:: Missing Rate is too high, the whole feature will be deleted!');
    end
    N = round(n*mr/100); % mr for that feature only
end


% Check number of variables in varargin
switch length(varargin)
    % Nothing is specified, choose randomly
    case 0
        idx = randi(p);
    case 1
        % Something is specified, varargin{1} is the idx
        idx = varargin{1};
end




% Choose random positions to be missing
P = randperm(n,N);

% Introduce NaN in those positions
outputX(P,idx) = NaN;



end
