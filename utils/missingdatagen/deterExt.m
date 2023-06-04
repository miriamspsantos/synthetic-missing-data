function [limitExt, limitPdfIdx] = deterExt(data, pdfEst,x,numDel,k)
% Author: Jastin Pompeu Soares
% Birth Date: 2016-11-3
% Last review Date: 2016-11-4
% This function gives the limits of the intervals for the outer values of
% a especifed input that follows a distribution using its PDF estimations 
%values.
%
% 'data' is a vector with all the samples
% 'pdfEst' is a vector of values of the pdf evaluated at 'x' (samples from 
%  data)
% 'numDel' is the number of elements that we pretend to delete from 'data'
% 'k' is the multiplication factor of 'numDel' - k*numDel gives the number 
%  of elements that we want to found/select. (Default k=1)
%
% [limitInt, limitPdfIdx] = deterExt(data, pdfEst,x,numDel,k)
%

%Verification of input arguments
narginchk(4,5);

%check if k is defined
if ~exist('k','var')
    k=1;
end

%intial values
limitExt=[NaN NaN];
minPdf=min(pdfEst);
limitPdfIdx = obtainLimitPdfIdx(minPdf,pdfEst);
numFound=0; %because we what to run one time the while cycle

while(numFound<(k*numDel))
    
    %obtain the new minPdf fater the atual one
    minPdf=min(pdfEst(pdfEst>minPdf));
    
    %obtain the new intervals indexs of PDF to the new minPdf established 
    limitPdfIdx = obtainLimitPdfIdx(minPdf,pdfEst);
    
    %obtain the new X intervals with the verification of the exists of
    %right and left limits
    if sum(isnan(limitPdfIdx))==0
        limitExt=[x(limitPdfIdx(1)) x(limitPdfIdx(2))];
    else
        if isnan(limitPdfIdx(1)) && ~isnan(limitPdfIdx(2))
            %if the left side doesn't have a limit
            limitExt=[NaN x(limitPdfIdx(2))];
        else
            if isnan(limitPdfIdx(2)) && ~isnan(limitPdfIdx(1))
                %if the right side doesn't have a limit
                limitExt=[x(limitPdfIdx(1)) NaN];
            else
                %if the both side doesn't have a limit (it will not happen)
                limitExt=[NaN NaN];   
            end
        end
    end
    
    %calculate the number of values exist 
    %from data on the new limits 
    numFound=sum(data<=limitExt(1))+sum(data>=limitExt(2));
end



end
