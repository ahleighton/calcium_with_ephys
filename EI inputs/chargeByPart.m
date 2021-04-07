function[E,I] = chargeByPart(animalList)
%% plots bar comparing means of charge transferred in L and H events

for iAnimal = 1:size(animalList,1)
    load(animalList(iAnimal).name);
    edges = [21:20:101];
    [~, ~, bin] = histcounts(InfoBursts.E_HL_edit(:,8),edges);
    for iBin = 1:max(bin)
        chargeE(iAnimal,iBin) = nanmean(InfoBursts.E_HL_edit(bin==iBin,18));
    end
    
    [~, ~, bin] = histcounts(InfoBursts.I_HL_edit(:,8),edges);
    for iBin = 1:max(bin)
        chargeI(iAnimal,iBin) = nanmean(InfoBursts.I_HL_edit(bin==iBin,18));
    end   
end


%% fig comparing means of charge in L and H events

figure
subplot(2,1,1)
bar([nanmean(chargeE)])
set(gca,'xtick',[1 2 3 4])
set(gca,'Xticklabel',{'20-40','40-60','60-80','80-100'} )
hold on
for iAnimal = 1:size(animalList,1)
    plot([1:4],chargeE(iAnimal,:),'-o')
end
title('Excitatory charge with participation')
pimpPlot

subplot(2,1,2)
bar([nanmean(chargeI)])
set(gca,'xtick',[1 2 3 4])
set(gca,'Xticklabel',{'20-40','40-60','60-80','80-100'} )
hold on
for iAnimal = 1:size(animalList,1)
    plot([1:4],chargeI(iAnimal,:),'-o')
end
title('Inhibitory charge with participation')
pimpPlot
ylim([0 400])

