% Using RA
%  1 = yearseq
%  2 = cell30m
%  3 = Comparison Cultivar ID  (CM1510 = 10, CM1509 = 9, Improved = 0)
%  4 = Comparison Nitrogen ID
%  5 = Base Cultivar ID  (CM1510 = 10, CM1509 = 9, Improved = 0)
%  6 = Base Nitrogen Management ID
%  7 = Mean Yield for Comp
%  8 = Standard Deviation of Yield for Comp
%  9 = CV of Yield for Comp
% 10 = Maximum Yield for Comp
% 11 = Minimum Yield for Comp
% 12 = Probability of Crop Failure for Comp
% 13 = Min Proportion for Comp to SOSD Base
% 14 = Mean Yield for Base
% 15 = Standard Deviation of Yield for Base
% 16 = CV of Yield for Base
% 17 = Maximum Yield for Base
% 18 = Minimum Yield for Base
% 19 = Probability of Crop Failure for Base
% 20 = Min Proportion for Base to SOSD Comp
% 21 = Difference in mean Comp - Base
% 22 = Difference in standard deviation Comp - Base
% 23 = Difference in CV Comp - Base
% 24 = Difference in Prob of Crop Failure Comp - Base
% 25 = Min Proportion for Comp to SOSD Base divided by average base yield
% 26 = Min Proportion for Base to SOSD Comp divided by average base yield
% 27 = Comp More Risky (-1)/less Risky (1)/ Indeterminant (0) compared to Base
% 28 = Harvest Acres

% Create DescriptiveStat
% Rows
%   1 = Weighted Mean   UB
%   2 = Weighted S.D.   UB
%   3 = Minimum         UB
%   4 = 10th Percentile UB
%   5 = 25th Percentile UB
%   6 = Median          UB
%   7 = 75th Percentile UB
%   8 = 90th Percentile UB
%   9 = Maximum         UB
%  10 = Weighted Mean   LB
%  11 = Weighted S.D.   LB
%  12 = Minimum         LB
%  13 = 10th Percentile LB
%  14 = 25th Percentile LB
%  15 = Median          LB
%  16 = 75th Percentile LB
%  17 = 90th Percentile LB
%  18 = Maximum         LB
%  19 = Proportion of Acres in Green
%  20 = Proportion of Acres in Yellow
%  21 = Proportion of Acres in Red
%  22 = Total Acres
%  23 = Number of Cells
% Columns
%  1 = RC_01_00_00_09_00
%  2 = RC_01_00_00_10_00
%  3 = RC_01_00_40_00_00
%  4 = RC_01_00_40_09_00
%  5 = RC_01_00_40_10_00
%  6 = RC_01_09_40_09_00
%  7 = RC_01_10_40_10_00
%  8 = RC_10_00_00_09_00
%  9 = RC_10_00_00_10_00
% 10 = RC_10_00_40_00_00
% 11 = RC_10_00_40_09_00
% 12 = RC_10_00_40_10_00
% 13 = RC_10_09_40_09_00
% 14 = RC_10_10_40_10_00


% Define Scenarios of interest
scenarios = [ 1, 0];

ScenariosLEN = length(scenarios);
DescriptiveStat = -999999 * ones(23, 1);

 for ind = 1

        datatemp = RA;
        CW = scenarios(ind, 1);

        if (scenarios(ind, 1) == 1)
             cellcond = (datatemp(:,2) ~= CW |  datatemp(:,25) <= 0);
        end

        if (scenarios(ind, 1) == 0 )
             cellcond = (datatemp(:,2) ~= CW |  datatemp(:,25) <= 0);
        end

        datatemp(cellcond,:) = [];

        if CW == 1
            COL = 1;
        elseif CW == 0
            COL = 2;

        else
            error('Something is wrong');
        end

        SampleN = size(datatemp, 1);



        totalacres = sum(datatemp(:, 25));
        wsumacresxLB  = 0;
        wsumacresxUB  = 0;
        wsumacresxLB2 = 0;
        wsumacresxUB2 = 0;
        percentilesLB = -99999999 * ones(2, SampleN);
        percentilesUB = -99999999 * ones(2, SampleN);
        propred = 0;
        propgreen = 0;

        for statind = 1:SampleN
            acres = datatemp(statind, 25);
            wtpLB = -1 * datatemp(statind, 17) / 1000;
            wtpUB = -1 * datatemp(statind, 10) / 1000;
            wsumacresxLB  = wsumacresxLB  +  wtpLB * (acres/totalacres);
            wsumacresxUB  = wsumacresxUB  +  wtpUB * (acres/totalacres);
            wsumacresxLB2 = wsumacresxLB2 + (wtpLB ^ 2) * (acres/totalacres);
            wsumacresxUB2 = wsumacresxUB2 + (wtpUB ^ 2) * (acres/totalacres);
            percentilesLB(statind, 1) = wtpLB;
            percentilesLB(statind, 2) = acres/totalacres;
            percentilesUB(statind, 1) = wtpUB;
            percentilesUB(statind, 2) = acres/totalacres;
            if datatemp(statind, 24) == -1
                propred = propred + acres/totalacres;
            elseif datatemp(statind, 24) == 1
                propgreen = propgreen + acres/totalacres;
            end
            clear acres wtpLB wtpUB;

        end
        percentilesLB = sortrows(percentilesLB);
        percentilesUB = sortrows(percentilesUB);

        cumLB = 0;
        cumUB = 0;
        for perind = 1:SampleN
            cumLBLast = cumLB;
            cumUBLast = cumUB;
            intervalLB = percentilesLB(perind, 2);
            intervalUB = percentilesUB(perind, 2);
            cumLB = cumLB + intervalLB;
            cumUB = cumUB + intervalUB;

            if cumLBLast <= 0.1 && cumLB >= 0.1
                DescriptiveStat( 4, COL) = ((0.1 - cumLBLast) / intervalLB) * percentilesLB(perind - 1, 1) + ((cumLB - 0.1) / intervalLB) * percentilesLB(perind, 1) ;
            end

            if cumUBLast <= 0.1 && cumUB >= 0.1
                DescriptiveStat(13, COL) = ((0.1 - cumUBLast) / intervalUB) * percentilesUB(perind - 1, 1) + ((cumUB - 0.1) / intervalUB) * percentilesUB(perind, 1) ;
            end

            if cumLBLast <= 0.25 && cumLB >= 0.25
                DescriptiveStat( 5, COL) = ((0.25 - cumLBLast) / intervalLB) * percentilesLB(perind - 1, 1) + ((cumLB - 0.25) / intervalLB) * percentilesLB(perind, 1) ;
            end

            if cumUBLast <= 0.25 && cumUB >= 0.25
                DescriptiveStat(14, COL) = ((0.25 - cumUBLast) / intervalUB) * percentilesUB(perind - 1, 1) + ((cumUB - 0.25) / intervalUB) * percentilesUB(perind, 1) ;
            end

            if cumLBLast <= 0.5 && cumLB >= 0.5
                DescriptiveStat( 6, COL) = ((0.5 - cumLBLast) / intervalLB) * percentilesLB(perind - 1, 1) + ((cumLB - 0.5) / intervalLB) * percentilesLB(perind, 1) ;
            end

            if cumUBLast <= 0.5 && cumUB >= 0.5
                DescriptiveStat(15, COL) = ((0.5 - cumUBLast) / intervalUB) * percentilesUB(perind - 1, 1) + ((cumUB - 0.5) / intervalUB) * percentilesUB(perind, 1) ;
            end

            if cumLBLast <= 0.75 && cumLB >= 0.75
                DescriptiveStat( 7, COL) = ((0.75 - cumLBLast) / intervalLB) * percentilesLB(perind - 1, 1) + ((cumLB - 0.75) / intervalLB) * percentilesLB(perind, 1) ;
            end

            if cumUBLast <= 0.75 && cumUB >= 0.75
                DescriptiveStat(16, COL) = ((0.75 - cumUBLast) / intervalUB) * percentilesUB(perind - 1, 1) + ((cumUB - 0.75) / intervalUB) * percentilesUB(perind, 1) ;
            end

            if cumLBLast <= 0.9 && cumLB >= 0.9
                DescriptiveStat( 8, COL) = ((0.9 - cumLBLast) / intervalLB) * percentilesLB(perind - 1, 1) + ((cumLB - 0.9) / intervalLB) * percentilesLB(perind, 1) ;
            end

            if cumUBLast <= 0.9 && cumUB >= 0.9
                DescriptiveStat(17, COL) = ((0.9 - cumUBLast) / intervalUB) * percentilesUB(perind - 1, 1) + ((cumUB - 0.9) / intervalUB) * percentilesUB(perind, 1) ;
            end

            clear cumLBLast cumUBLast intervalLB intervalUB;
        end
        DescriptiveStat( 1, COL) = wsumacresxLB;
        DescriptiveStat( 2, COL) = sqrt(wsumacresxLB2 - wsumacresxLB ^ 2);
        DescriptiveStat( 3, COL) = percentilesLB(1, 1);

        DescriptiveStat( 9, COL) = percentilesLB(SampleN, 1);

        DescriptiveStat(10, COL) = wsumacresxUB;
        DescriptiveStat(11, COL) = sqrt(wsumacresxUB2 - wsumacresxUB ^ 2);
        DescriptiveStat(12, COL) = percentilesUB(1, 1);

        DescriptiveStat(18, COL) = percentilesUB(SampleN, 1);
        DescriptiveStat(19, COL) = propgreen;
        DescriptiveStat(20, COL) = 1 - propred - propgreen;
        DescriptiveStat(21, COL) = propred;
        DescriptiveStat(22, COL) = totalacres;
        DescriptiveStat(23, COL) = SampleN;

        clear datatemp CW cellcond COL SampleN totalacres ...
              wsumacresxLB wsumacresxUB wsumacresxUB2 wsumacresxLB2 ...
              percentilesLB percentilesUB propgreen propred perind cumLB cumUB statind;

    end


clear scenarios ScenariosLEN yearseq ind;
