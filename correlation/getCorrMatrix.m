function Rij = getCorrMatrix(X,ftypes)
% getCorrMatrix(X,ftypes) returns the correlation matrix of X. X may have
% several feature types, as specified by ftypes (check CODES).
% 
%   INPUT:
%       X = matrix of data to be correlated
%      ftypes = type of feature, an array with codes as read from
%      arff2double.
% 
%       CODES:
%            0 = numeric/continuous
%            1 = categorical (nominal)
%            2 = string
%            3 = date
%            4 = ordinal (if coded as numeric)
%            5 = binary
%            6 = ordinal (if coded as categorical)
% 
% 
%   OUTPUT:
%       Rij = symmetric correlation matrix of X
% 
% 
% Copyright: Miriam Santos, 2017



N = size(X,2); 
Rij = zeros(N,N);
for i = 1:N
    for j = 1:N
        r = association(X(:,i), X(:,j), ftypes(i), ftypes(j)); 
        Rij(i,j) = r;
    end
end