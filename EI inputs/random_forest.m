%% random forest classifier to predict whether event is L or H

animalList = dir('Bursts*.mat');
animalList = animalList(1:end,:);
data = [];
clear auc variableImpE variableImpI

for iAnimal = 1:size(animalList,1)
    load(animalList(iAnimal).name);
    % normalise activity to mean of
    
    data = cat(1,data,cat(1,InfoBursts.E_HL_edit, InfoBursts.I_HL_edit));
    [~, ind] = unique(data(:,19), 'rows');
    data = data(ind,:);
    %% how much do excitatory and inhibitory inputs contribute to decision H vs L?
    
    exInd = data(:,18)<0;
    exData = data(exInd,:);
    inInd = data(:,18)>0;
    inData = data(inInd,:);
    
    %% excitatory inputs
    e = TreeBagger(100,[exData(:,18) exData(:,20) exData(:,19) ],exData(:,8)>=80,'OOBVarImp','on','oobpred','on','Method','classification');
    
    %% inhibitory inputs
    in = TreeBagger(100,[inData(:,18) inData(:,20) inData(:,19)],inData(:,8)>=80,'OOBVarImp','on', 'oobpred','on','Method','classification');
    
    %% shuffled data randomly assign h or l 
    
    answer = exData(:,8)>=80;
    randanswerE = randi(2,size(answer,1),1)-1;
    answer = inData(:,8)>=80;
    randanswerI = randi(2,size(answer,1),1)-1;
    
     %% excitatory inputs random
    eR = TreeBagger(100,[exData(:,18) exData(:,21) exData(:,20) exData(:,19) ],randanswerE,'OOBVarImp','on','oobpred','on','Method','classification');
    
    %% inhibitory inputs random 
    inR = TreeBagger(100,[inData(:,18) inData(:,21) inData(:,20) inData(:,19)],randanswerI,'OOBVarImp','on', 'oobpred','on','Method','classification');
    
    %% OOB error
    figure
    oobErrorE = oobError(e);
    plot(oobErrorE)
    hold on;
    oobErrorI = oobError(in);
    plot(oobErrorI)
   
    oobErrorE = oobError(eR);
    plot(oobErrorE)
    hold on;
    oobErrorI = oobError(inR);
    plot(oobErrorI)
    
    %% ROC curves
    figure
    % excitatory
    [y,s] = oobPredict(e);
    [X1,Y1,T,AUCE] = perfcurve(cell2mat(e.Y),s(:,1),'0','nboot',500,'boottype','norm');
    plot(X1(:,1),Y1(:,1),'g')
    hold on;
    % inhibitory
    [y,s] = oobPredict(in);
    [X1,Y1,T,AUCI] = perfcurve(cell2mat(in.Y),s(:,1),'0','nboot',500,'boottype','norm');
    plot(X1(:,1),Y1(:,1),'r')
    hold on;
    % excitatory
    [y,s] = oobPredict(eR);
    [X1,Y1,T,AUCER] = perfcurve(cell2mat(eR.Y),s(:,1),'0','nboot',500,'boottype','norm');
    plot(X1(:,1),Y1(:,1),'black')
    hold on;
    % inhibitory
    [y,s] = oobPredict(inR);
    [X1,Y1,T,AUCIR] = perfcurve(cell2mat(inR.Y),s(:,1),'0','nboot',500,'boottype','norm');
    plot(X1(:,1),Y1(:,1),'blue')
    
    legend({'Excitatory', 'Inhibitory','Ex random','In random'})
    
    auc(iAnimal,:) = [AUCE(:,1) AUCI(:,1) AUCER(:,1) AUCIR(:,1)];
    
    %% importance of factors 
    
    variableImpE(iAnimal,:) = e.OOBPermutedVarDeltaError;
    variableImpI(iAnimal,:) = in.OOBPermutedVarDeltaError;
    
end

figure
bar([mean(auc(:,1)) mean(auc(:,3)) mean(auc(:,2)) mean(auc(:,4))])
hold on
for iAnimal = 1:size(auc,1)
    plot([1 2 3 4], [auc(iAnimal,1) auc(iAnimal,3) auc(iAnimal,2)  auc(iAnimal,4)], '-o')
end
pimpPlot

set(gca,'xticklabel',{'Excitatory Inputs','Shuffled E','Inhibitory Inputs', 'Shuffled I'})


figure
bar([mean(auc(:,1)) mean(auc(:,2))])
hold on
for iAnimal = 1:size(auc,1)
    plot([1 2], [auc(iAnimal,1) auc(iAnimal,2)] , '-o')
end
pimpPlot
set(gca,'xticklabel',{'Excitatory Inputs','Inhibitory Inputs'})
