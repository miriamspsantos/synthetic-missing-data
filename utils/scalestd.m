function scaledData = scalestd(data)
%SCALESTD Z-score normalization.
%   scaledData = SCALETD(data), perfoms z-score normalization. Data should
%   be samples x features (rows x columns). Features will be scaled
%   according to:
%
%              new_x = (x_actual - mean(X))/std(X)
% 
% The new_x will have a mean of 0 and std of 1.
% 
% This implementation handles missing data as well. Missing values will not
% be scaled and will remain NaN. The remaining values are scaled.
% 
% 
% Example:
% 
%       scaled_data = scalestd(data);
% 
% 
% 
% Author: Miriam Seoane Santos (last-update: Dec, 2016)


for i = 1: size(data,2)
    
    idxComp = find(isnan(data(:,i))==0);
    idxInc = find(isnan(data(:,i))==1);
    
    scaledData(idxInc,i) = NaN;
    scaledData(idxComp,i) = (data(idxComp,i)-mean(data(idxComp,i)))/std(data(idxComp,i));
end



