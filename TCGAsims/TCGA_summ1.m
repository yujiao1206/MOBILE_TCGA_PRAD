clc
load('TCGA_RPPA_v1.mat')
load('TCGA_RNAseq_v1.mat')
rng(6); % Set random number generating (rng) seed
warning('off','all') % Turn-off warning messages, mostly from glmnet package
addpath('funcs')

XXraw = TCGA_RNAseq_v1.data; % Right-hand-side (RHS) matrix: mRNAs
YYraw = TCGA_RPPA_v1.data; % Left-hand-side (LHS) matrix: Proteins
XXvar = flipud(sortrows([std(XXraw,1,2),(1:size(XXraw,1))'])); % calculate variance (std) of raw data
YYvar = flipud(sortrows([std(YYraw,1,2),(1:size(YYraw,1))']));
XXindices2keep = floor(0.1*size(XXraw,1)); % Find top 10% of highly variant mRNAs 
YYindices2keep = floor(0.2*size(YYraw,1)); % Find top 20% of highly variant proteins
XX = XXraw(sortrows(XXvar(1:XXindices2keep,2)),:); % Retain only top 10% of mRNAs 
YY = YYraw(sortrows(YYvar(1:YYindices2keep,2)),:); % Retain only top 20% of proteins/phosphoproteins
RNAseqIDs = sortrows(XXvar(1:XXindices2keep,2)); % Find indeces of retained mRNAs in raw data
RPPAIDs = sortrows(YYvar(1:YYindices2keep,2)); % Find indeces of retained proteins in raw data
%%%%% Find HER2 amplified samples ( log2(fpkm+1)>7 )
% gene = 'ERBB2';
% idx_rna = find(~cellfun(@isempty,(strfind(genes1(RNAseqIDs,1),gene))));
% H2ampIDs = find(XX(idx_rna,:)>7); % 7 is the break point in the histogram
%%%%% Remove HER2-amplified OR HER2-normal samples and run: LOGO happens here
% XX(:,H2ampIDs) = []; % For instance, excluding columns 4 & 5 makes EGF-LOGO
% YY(:,H2ampIDs) = [];
% Normalize the input matrices 
XX3 = prepnormmats(XX,6,1); 
YY3 = prepnormmats(YY,6,1);

% % Simulation clean-up and save Lasso Coefficient Matrices
% addpath('FULL_TCGA')
% listTLasFiles = dir('FULL_TCGA/TLas1_r*'); 
% numFiles = size(listTLasFiles,1);
% TLasMats = cell(numFiles,2);
% a0Mats = cell(numFiles,2);
% qqtodel = [];
% for qq = 1:numFiles % Loop for saving coefficient matrices
%     if listTLasFiles(qq,1).bytes > 700000
%         name1 = listTLasFiles(qq,1).name;
%         lname1 = load(name1,'TLas1');
%         TLasMats{qq,1} = sparse(lname1.TLas1);
%         clear lname1
%         aname1 = find(name1=='_');
%         NumName1 = name1((aname1(end)+2):end-4);
%         TLasMats{qq,2} = str2double(NumName1);
%         disp(qq)
%     else
%         qqtodel = [qqtodel;qq]; % If for some reason there was an error in saving files
%     end
% end
% for qq = 1:numFiles % Loop for saving y-intercept value arrays (usually all zero)
%     if listTLasFiles(qq,1).bytes > 700000
%         name1 = listTLasFiles(qq,1).name;
%         lname1 = load(name1,'a0Vals1');
%         a0Mats{qq,1} = sparse(lname1.a0Vals1);
%         clear lname1 
%         aname1 = find(name1=='_');
%         NumName1 = name1((aname1(end)+2):end-4);
%         a0Mats{qq,2} = str2double(NumName1);
%         disp(qq)
%     end
% end
% listTLasFiles(qqtodel,:) = [];
% a0Mats(qqtodel,:) = [];
% TLasMats(qqtodel,:) = [];
% save('FULL_TCGAsumm1.mat','a0Mats','TLasMats','listTLasFiles','qqtodel','-v7.3') ;
% %
% % Finding Robust Lasso Coefficient Matrix
% % Remember to run/load the "Data pre-processing" section above if needed (e.g. working on a different day after simulations are done)
% % load('RpR_FULL.mat') % Load the Lasso coefficient matrices data if not in workspace already
% [intranksR_FULL_TCGA,intsii_FULL_TCGA,numedges_FULL_TCGA,TLasTarget_FULL_TCGA] = ...
%     runAssocRankerTCGA(0.5,TLasMats,TCGA_RNAseq_v1,RNAseqIDs,TCGA_RPPA_v1,RPPAIDs);
% % Change the below name according to inputs: For example, for EGF-LOGO -> TLasBestRpR_EGFLOGO
% save('TLasBest_FULL_TCGA.mat','intranksR_FULL_TCGA','intsii_FULL_TCGA','numedges_FULL_TCGA','TLasTarget_FULL_TCGA','-v7.3') 
% disp('DONE and saved')


% % Simulation clean-up and save Lasso Coefficient Matrices
% addpath('H2out_TCGA')
% listTLasFiles = dir('H2out_TCGA/TLas1_r*'); 
% numFiles = size(listTLasFiles,1);
% TLasMats = cell(numFiles,2);
% a0Mats = cell(numFiles,2);
% qqtodel = [];
% for qq = 1:numFiles % Loop for saving coefficient matrices
%     if listTLasFiles(qq,1).bytes > 700000
%         name1 = listTLasFiles(qq,1).name;
%         lname1 = load(name1,'TLas1');
%         TLasMats{qq,1} = sparse(lname1.TLas1);
%         clear lname1
%         aname1 = find(name1=='_');
%         NumName1 = name1((aname1(end)+2):end-4);
%         TLasMats{qq,2} = str2double(NumName1);
%         disp(qq)
%     else
%         qqtodel = [qqtodel;qq]; % If for some reason there was an error in saving files
%     end
% end
% for qq = 1:numFiles % Loop for saving y-intercept value arrays (usually all zero)
%     if listTLasFiles(qq,1).bytes > 700000
%         name1 = listTLasFiles(qq,1).name;
%         lname1 = load(name1,'a0Vals1');
%         a0Mats{qq,1} = sparse(lname1.a0Vals1);
%         clear lname1 
%         aname1 = find(name1=='_');
%         NumName1 = name1((aname1(end)+2):end-4);
%         a0Mats{qq,2} = str2double(NumName1);
%         disp(qq)
%     end
% end
% listTLasFiles(qqtodel,:) = [];
% a0Mats(qqtodel,:) = [];
% TLasMats(qqtodel,:) = [];
% save('H2out_TCGAsumm1.mat','a0Mats','TLasMats','listTLasFiles','qqtodel','-v7.3') ;
% 
% % Finding Robust Lasso Coefficient Matrix
% % Remember to run/load the "Data pre-processing" section above if needed (e.g. working on a different day after simulations are done)
% % load('RpR_FULL.mat') % Load the Lasso coefficient matrices data if not in workspace already
% [intranksR_H2out_TCGA,intsii_H2out_TCGA,numedges_H2out_TCGA,TLasTarget_H2out_TCGA] = ...
%     runAssocRankerTCGA(0.5,TLasMats,TCGA_RNAseq_v1,RNAseqIDs,TCGA_RPPA_v1,RPPAIDs);
% % Change the below name according to inputs: For example, for EGF-LOGO -> TLasBestRpR_EGFLOGO
% save('TLasBest_H2out_TCGA.mat','intranksR_H2out_TCGA','intsii_H2out_TCGA','numedges_H2out_TCGA','TLasTarget_H2out_TCGA','-v7.3') 
% disp('DONE and saved')


% % Simulation clean-up and save Lasso Coefficient Matrices
% addpath('H2lowout_TCGA')
% listTLasFiles = dir('H2lowout_TCGA/TLas1_r*'); 
% numFiles = size(listTLasFiles,1);
% TLasMats = cell(numFiles,2);
% a0Mats = cell(numFiles,2);
% qqtodel = [];
% for qq = 1:numFiles % Loop for saving coefficient matrices
%     if listTLasFiles(qq,1).bytes > 100000
%         name1 = listTLasFiles(qq,1).name;
%         lname1 = load(name1,'TLas1');
%         TLasMats{qq,1} = sparse(lname1.TLas1);
%         clear lname1
%         aname1 = find(name1=='_');
%         NumName1 = name1((aname1(end)+2):end-4);
%         TLasMats{qq,2} = str2double(NumName1);
%         disp(qq)
%     else
%         qqtodel = [qqtodel;qq]; % If for some reason there was an error in saving files
%     end
% end
% for qq = 1:numFiles % Loop for saving y-intercept value arrays (usually all zero)
%     if listTLasFiles(qq,1).bytes > 100000
%         name1 = listTLasFiles(qq,1).name;
%         lname1 = load(name1,'a0Vals1');
%         a0Mats{qq,1} = sparse(lname1.a0Vals1);
%         clear lname1 
%         aname1 = find(name1=='_');
%         NumName1 = name1((aname1(end)+2):end-4);
%         a0Mats{qq,2} = str2double(NumName1);
%         disp(qq)
%     end
% end
% listTLasFiles(qqtodel,:) = [];
% a0Mats(qqtodel,:) = [];
% TLasMats(qqtodel,:) = [];
% save('H2lowout_TCGAsumm1.mat','a0Mats','TLasMats','listTLasFiles','qqtodel','-v7.3') ;
% 
% % Finding Robust Lasso Coefficient Matrix
% % Remember to run/load the "Data pre-processing" section above if needed (e.g. working on a different day after simulations are done)
% % load('RpR_FULL.mat') % Load the Lasso coefficient matrices data if not in workspace already
% [intranksR_H2lowout_TCGA,intsii_H2lowout_TCGA,numedges_H2lowout_TCGA,TLasTarget_H2lowout_TCGA] = ...
%     runAssocRankerTCGA(0.5,TLasMats,TCGA_RNAseq_v1,RNAseqIDs,TCGA_RPPA_v1,RPPAIDs);
% % Change the below name according to inputs: For example, for EGF-LOGO -> TLasBestRpR_EGFLOGO
% save('TLasBest_H2lowout_TCGA.mat','intranksR_H2lowout_TCGA','intsii_H2lowout_TCGA','numedges_H2lowout_TCGA','TLasTarget_H2lowout_TCGA','-v7.3') 
% disp('DONE and saved')

% Simulation clean-up and save Lasso Coefficient Matrices
addpath('ERPRout_TCGA')
listTLasFiles = dir('ERPRout_TCGA/TLas1_r*'); 
numFiles = size(listTLasFiles,1);
TLasMats = cell(numFiles,2);
a0Mats = cell(numFiles,2);
qqtodel = [];
for qq = 1:numFiles % Loop for saving coefficient matrices
    if listTLasFiles(qq,1).bytes > 500000
        name1 = listTLasFiles(qq,1).name;
        lname1 = load(name1,'TLas1');
        TLasMats{qq,1} = sparse(lname1.TLas1);
        clear lname1
        aname1 = find(name1=='_');
        NumName1 = name1((aname1(end)+2):end-4);
        TLasMats{qq,2} = str2double(NumName1);
        disp(qq)
    else
        qqtodel = [qqtodel;qq]; % If for some reason there was an error in saving files
    end
end
for qq = 1:numFiles % Loop for saving y-intercept value arrays (usually all zero)
    if listTLasFiles(qq,1).bytes > 500000
        name1 = listTLasFiles(qq,1).name;
        lname1 = load(name1,'a0Vals1');
        a0Mats{qq,1} = sparse(lname1.a0Vals1);
        clear lname1 
        aname1 = find(name1=='_');
        NumName1 = name1((aname1(end)+2):end-4);
        a0Mats{qq,2} = str2double(NumName1);
        disp(qq)
    end
end
listTLasFiles(qqtodel,:) = [];
a0Mats(qqtodel,:) = [];
TLasMats(qqtodel,:) = [];
save('ERPRout_TCGAsumm1.mat','a0Mats','TLasMats','listTLasFiles','qqtodel','-v7.3') ;
% Finding Robust Lasso Coefficient Matrix
% Remember to run/load the "Data pre-processing" section above if needed (e.g. working on a different day after simulations are done)
% load('RpR_FULL.mat') % Load the Lasso coefficient matrices data if not in workspace already
[intranksR_ERPRout_TCGA,intsii_ERPRout_TCGA,numedges_ERPRout_TCGA,TLasTarget_ERPRout_TCGA] = ...
    runAssocRankerTCGA(0.5,TLasMats,TCGA_RNAseq_v1,RNAseqIDs,TCGA_RPPA_v1,RPPAIDs);
% Change the below name according to inputs: For example, for EGF-LOGO -> TLasBestRpR_EGFLOGO
save('TLasBest_ERPRout_TCGA.mat','intranksR_ERPRout_TCGA','intsii_ERPRout_TCGA','numedges_ERPRout_TCGA','TLasTarget_ERPRout_TCGA','-v7.3') 
% disp('DONE and saved')

% Simulation clean-up and save Lasso Coefficient Matrices
addpath('TNBCout_TCGA')
listTLasFiles = dir('TNBCout_TCGA/TLas1_r*'); 
numFiles = size(listTLasFiles,1);
TLasMats = cell(numFiles,2);
a0Mats = cell(numFiles,2);
qqtodel = [];
for qq = 1:numFiles % Loop for saving coefficient matrices
    if listTLasFiles(qq,1).bytes > 600000
        name1 = listTLasFiles(qq,1).name;
        lname1 = load(name1,'TLas1');
        TLasMats{qq,1} = sparse(lname1.TLas1);
        clear lname1
        aname1 = find(name1=='_');
        NumName1 = name1((aname1(end)+2):end-4);
        TLasMats{qq,2} = str2double(NumName1);
        disp(qq)
    else
        qqtodel = [qqtodel;qq]; % If for some reason there was an error in saving files
    end
end
for qq = 1:numFiles % Loop for saving y-intercept value arrays (usually all zero)
    if listTLasFiles(qq,1).bytes > 600000
        name1 = listTLasFiles(qq,1).name;
        lname1 = load(name1,'a0Vals1');
        a0Mats{qq,1} = sparse(lname1.a0Vals1);
        clear lname1 
        aname1 = find(name1=='_');
        NumName1 = name1((aname1(end)+2):end-4);
        a0Mats{qq,2} = str2double(NumName1);
        disp(qq)
    end
end
listTLasFiles(qqtodel,:) = [];
a0Mats(qqtodel,:) = [];
TLasMats(qqtodel,:) = [];
save('TNBCout_TCGAsumm1.mat','a0Mats','TLasMats','listTLasFiles','qqtodel','-v7.3') ;
% Finding Robust Lasso Coefficient Matrix
% Remember to run/load the "Data pre-processing" section above if needed (e.g. working on a different day after simulations are done)
% load('RpR_FULL.mat') % Load the Lasso coefficient matrices data if not in workspace already
[intranksR_TNBCout_TCGA,intsii_TNBCout_TCGA,numedges_TNBCout_TCGA,TLasTarget_TNBCout_TCGA] = ...
    runAssocRankerTCGA(0.5,TLasMats,TCGA_RNAseq_v1,RNAseqIDs,TCGA_RPPA_v1,RPPAIDs);
% Change the below name according to inputs: For example, for EGF-LOGO -> TLasBestRpR_EGFLOGO
save('TLasBest_TNBCout_TCGA.mat','intranksR_TNBCout_TCGA','intsii_TNBCout_TCGA','numedges_TNBCout_TCGA','TLasTarget_TNBCout_TCGA','-v7.3') 
% disp('DONE and saved')


