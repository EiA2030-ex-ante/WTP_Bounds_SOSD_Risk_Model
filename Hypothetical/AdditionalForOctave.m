%pkg install io-2.6.4.tar.gz
pkg load io


% 1 Q as baseline vs G ---------------------------------------------
clear
ndataseq01060216=xlsread('GvsQ.xlsx')
CreateWTPBoundsbyCell
CreateTableData


xlswrite('RA_GvsQ',RA)
xlswrite('DescriptiveStat_GvsQ_.xlsx',DescriptiveStat)

%clear
%RA
%RAGvsQ=xlsread('RA_GvsQ.xlsx')
%CreateFigureData
%xlswrite('CELL30MIDMAP_GvsQ.xlsx',CELL30MIDMAP)
%xlswrite('PriceSensitivity_GvsQ.xlsx',PriceSensitivity)


%2 F vs Q: Q as baseline
clear
ndataseq01060216=xlsread('FvsQ.xlsx')
CreateWTPBoundsbyCell
CreateTableData


%2 F vs G : F as baseline
clear
ndataseq01060216=xlsread('GvsF.xlsx')
CreateWTPBoundsbyCell
CreateTableData




% TRY G as base --------

