function [result] = SOSDIntegralTestv3(DOMINANT,DOMINATED)
% Tests for second-order stochastic dominance assuming uniform distribution
% over vector elements
% Algorithm Adapted from Levy, H. (2006). Stochastic Dominance: Investment Decision
%    Making Under Uncertainty (Second Edition). Springer. New York, NY.
%    Pages 180-182.
% result = 1 implies suspected DOMINANT distribution is in fact SOSD over DOMINATED
% result = 0 implies suspected DOMINANT distribution is not SOSD over DOMINATED

len1 = length(DOMINANT);
len2 = length(DOMINATED);
if len1 ~= len2
    error('Lengths do not match!');
end

DOMINANTSORT = sortrows(DOMINANT,1);
DOMINATEDSORT = sortrows(DOMINATED,1);
work = zeros(len1,2);

flag1 = 1; % stays 1 if cumulative of suspected dominated >= cumulative of suspected dominant
flag2 = 0; % stays 0 unless cumulative of supected dominated > cumulative suspected dominant for some value
for ind = 1:len1 % Check to see if suspected dominant distribution satisfies SOSD integral condition 
                  % relative to the suspected dominated distribution
    if ind == 1
        work(ind,1) = DOMINANTSORT(ind,1);
        work(ind,2) = DOMINATEDSORT(ind,1);
    else
        work(ind,1) = DOMINANTSORT(ind,1)  + work(ind - 1,1);
        work(ind,2) = DOMINATEDSORT(ind,1) + work(ind - 1,2);
    end
    if work(ind,1) < work(ind,2) 
        flag1 = 0; % Not SOSD because suspected dominant distribution has higher cumulative value than suspected dominated
    end
    if work(ind,1) > work(ind,2)
        flag2 = 1; % To be SOSD the suspected dominated distribution must have higher cumulative
                   % distribution than suspected dominant distribution for at least one value
    end
end

result = flag1 * flag2;