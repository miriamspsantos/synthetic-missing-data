function [ limitInt, limitPdfIdx ] = deterInt( data, pdfEst,x,numDel,k)
% Author: Jastin Pompeu Soares
% Birth Date: 2016-11-3
% Last review Date: 2016-11-4
% This function gives the limits of the intervals for the most frequent
%values of a especifed input that follows a distribution using its PDF 
%estimations values.
%
% 'data' is a vector with all the samples
% 'pdfEst' is a vector of values of the pdf evaluated at 'x' (samples from 
% data)
% 'numDel' is the number of elements that we pretend to delete from 'data'
% 'k' is the multiplication factor of 'numDel' - k*numDel gives the number 
%  of elements that we want to found/select. (Default k=1)
%
%[ limitInt, limitPdfIdx ] = deterInt( data, pdfEst,x,numDel,k)
%

%Verification of input arguments
narginchk(4,5);

%check if k is defined
if ~exist('k','var')
    k=1;
end

%intial values
[lim, idx]=max(pdfEst);
limitPdfIdx=[idx idx];
limitInt=[x(idx) x(idx)];
numFound=0;

while(numFound<(k*numDel))
    %discrease the threshold
    lim=max(pdfEst(pdfEst<lim));
    
    %obtain the new intervals indexs of PDF to the new lim established 
    aux=find(pdfEst>=lim);
    limitPdfIdx=[aux(1) aux(end)];
    
    %obtain the new X intervals
    limitInt=[x(limitPdfIdx(1)) x(limitPdfIdx(2))];
    
    %calculate the number of values exist 
    %from data on the new limits 
    numFound=sum(data>=limitInt(1) & data<=limitInt(2));
end
