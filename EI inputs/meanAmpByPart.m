function[E,I] = meanAmpByPart(animalList)
%% plots bar comparing means in L and H events

for iAnimal = 1:size(animalList,1)
    load(animalList(iAnimal).name);
    edges = [21:20:101];
    [~, ~, bin] = histcounts(InfoBursts.E_HL_edit(:,8),edges);
    for iBin = 1:max(bin)
        meanE(iAnimal,iBin) = nanmean(InfoBursts.E_HL_edit(bin==iBin,20));
    end
    
    [~, ~, bin] = histcounts(InfoBursts.I_HL_edit(:,8),edges);
    for iBin = 1:max(bin)
        meanI(iAnimal,iBin) = nanmean(InfoBursts.I_HL_edit(bin==iBin,20));
    end   
end


%% fig comparing means in L and H events

figure
subplot(2,1,1)
bar([nanmean(meanE)])
set(gca,'xtick',[1 2 3 4])
set(gca,'Xticklabel',{'20-40','40-60','60-80','80-100'} )
hold on
for iAnimal = 1:size(animalList,1)
    plot([1:4],meanE(iAnimal,:),'-o')
end
title('Excitatory mean amplitude with participation')
pimpPlot
ylim([-100 0])

subplot(2,1,2)
bar([nanmean(meanI)])
set(gca,'xtick',[1 2 3 4])
set(gca,'Xticklabel',{'20-40','40-60','60-80','80-100'} )
hold on
for iAnimal = 1:size(animalList,1)
    plot([1:4],meanI(iAnimal,:),'-o')
end
title('Inhibitory mean amplitude with participation')
pimpPlot
ylim([0 100])

