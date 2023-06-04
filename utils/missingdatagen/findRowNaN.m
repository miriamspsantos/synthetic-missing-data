function [ indx ] = findRowNaN( data )
% This function return the indexes from the rows that are all fill with NaN,
% if it doesn't exist returns [].
%
% Author: Jastin Pompeu Soares
% Last Review:22/01/2017

indx=find(sum(isnan(data'))'>(size(data,2)-1));

end
