function[E,I] = HLbarAll(animalList)
%% plots bar comparing means of charge transferred in L and H events

for iAnimal = 1:size(animalList,1)
    load(animalList(iAnimal).name);
    indLE = InfoBursts.E_HL_edit(:,8)<80;
    indLI = InfoBursts.I_HL_edit(:,8)<80;
    indHE = InfoBursts.E_HL_edit(:,8)>=80;
    indHI = InfoBursts.I_HL_edit(:,8)>=80;
    I(iAnimal,1) = nanmean(InfoBursts.I_HL_edit(indLI,18));
    E(iAnimal,1) = nanmean(InfoBursts.E_HL_edit(indLE,18));    
    I(iAnimal,2) = nanmean(InfoBursts.I_HL_edit(indHI,18));
    E(iAnimal,2) = nanmean(InfoBursts.E_HL_edit(indHE,18));
end


%% fig comparing means of charge in L and H events

figure
x1 = [0.85 1.85; 1.15 2.15]';
means_I = [nanmean(I(:,1)) nanmean(I(:,2))];
means_E = [nanmean(E(:,1)) nanmean(E(:,2))];
means =[means_I; means_E];
bar(means)
set(gca,'xticklabel',{'Inhibitory Inputs', 'Excitatory Inputs'})

errorbar(x1,means,[nanstd(I(:,1)) nanstd(I(:,2));nanstd(E(:,1)) nanstd(E(:,2))], '.')
hold on;
bar([means])
pimpPlot

% add in lines for each animal

for iAnimal = 1:size(animalList)
    plot([0.85 1.15], [I(iAnimal,1) I(iAnimal,2)],'ro-'); hold on
    plot([1.85 2.15], [E(iAnimal,1) E(iAnimal,2)],'bo-'); hold on
end

legend('L events','H events'); hold on;

