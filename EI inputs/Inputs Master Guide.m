animalList = dir('Bursts*.mat');

%% bin into H and L  

% not normalised charge 
[E,I] = HLbarAll(animalList);
title('Charge transferred in H and L events')
ylabel('Area under Current-time Curve')
[h,p]= ttest(I(:,1),I(:,2))
[h,p]= ttest(E(:,1),E(:,2))

% E:I ratio

I(I==0) = NaN;
E(E==0) = NaN;
figure
Irat = I(:,2)./I(:,1);
Erat = E(:,2)./E(:,1);
bar([nanmean(Erat) nanmean(Irat)]);
hold on;
for iAnimal = 1:size(animalList,1)
    plot([1 2],[Erat(iAnimal,1) Irat(iAnimal,1)],'r-o');hold on;
end
pimpPlot
title('H:L Charge transferred for Inhibitory and Excitatory inputs')
[h,p] = ttest(Irat,Erat)

%% Split by participation 

% mean amp
meanAmpByPart(animalList)

% charge
chargeByPart(animalList)



