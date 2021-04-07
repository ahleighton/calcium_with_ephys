%% Whole cell recordings, action potentials during calcium imaging
% 1: duration (calcium); 2: jitter (calcium); 3: amplitude (calcium); 4:
% participation (calcium); 5: #APS; 6: Duration (ephys, frames); 7:
% Duration (ephys, seconds)

load('apdata5cells.mat')

nCells = max(apdata(:,9));

%% action potentials during L and H events

for iCell = 1:nCells
    celldata = apdata(apdata(:,9)==iCell,:);
    apLH(iCell,1) = nanmean(celldata(celldata(:,4)<80,5));
    apLH(iCell,2) = nanmean(celldata(celldata(:,4)>=80,5));
end

figure
bar(nanmean(apLH))
hold on
plot([1 2], [apLH(:,1) apLH(:,2)], '-o')
pimpPlot
set(gca, 'xticklabels', {'L-events', 'H-events'})
ylabel('#APs fired')

%% patched cell participates in L and H events

for iCell = 1:nCells
    celldata = apdata(apdata(:,9)==iCell,:);
    partLH(iCell,1) = sum(celldata(celldata(:,4)<80,5)>0)./sum(celldata(:,4)<80);
    partLH(iCell,2) = sum(celldata(celldata(:,4)>=80,5)>0)./sum(celldata(:,4)>=80);
end

figure
bar(nanmean(partLH))
hold on
plot([1 2], [partLH(:,1) partLH(:,2)], '-o')
pimpPlot
set(gca, 'xticklabels', {'L-events', 'H-events'})
ylabel('% of events in which patched cell fired')

%% Clustering into L and H based on ephys instead of calcium

%% Clustering, all cells

% using #APs and ephys duration

clusterme = [apdata(:,6) apdata(:,5)];
D = pdist(clusterme);
tree = linkage(D,'ward'); % same as tree2 = linkage(coacT,'ward');

figure()
subplot(2,1,1)
dendrogram(tree,0)
title('Default Leaf Order')
subplot(2,1,2)
for c_size = 2:size(clusterme,1)-1
    c = cluster(tree,'maxclust',c_size);
    s = silhouette(clusterme, c);
    s(s==1)=0;
    s(isnan(s))=0;
    savg(c_size,1) = nanmean(grpstats(s,c),1);
end
plot(savg(1:end,:));hold on;

% check split using 2 clusters and compare to classification with
% clustering
c_size = 2;
c = cluster(tree,'maxclust',c_size);
s = silhouette(clusterme, c);

meanAP1 = nanmean(apdata(c==1,5));
meanAP2 = nanmean(apdata(c==2,5));

if meanAP1>meanAP2
    caInd(apdata(:,4)<=80,:) = 2;
    caInd(apdata(:,4)>80,:) = 1;
else
    caInd(apdata(:,4)<=80,:) = 1;
    caInd(apdata(:,4)>80,:) = 2;
end

comp = c == caInd;
successrate = sum(comp)./size(comp,1);
% show results of all clustering output, but displayed per cell

for iCell = 1:5
    clear caInd
    
    meanAP1 = nanmean(apdata(apdata(:,9)==iCell & c==1,5));
    meanAP2 = nanmean(apdata(apdata(:,9)==iCell & c==2,5));
    
    if meanAP1>meanAP2
        caInd(apdata(:,9)==iCell & apdata(:,4)<=80,:) = 2;
        caInd(apdata(:,9)==iCell & apdata(:,4)>80,:) = 1;
    else
        caInd(apdata(:,4)<=80 & apdata(:,9)==iCell,:) = 1;
        caInd(apdata(:,4)>80 & apdata(:,9)==iCell,:) = 2;
    end
    comp = c(apdata(:,9)==iCell,:) == caInd(apdata(:,9)==iCell,:);
    successrate(iCell,1) = sum(comp)./size(comp,1);
   
    %% figure
    figure
    subplot(2,1,1)    
    scatter(apdata(apdata(:,9)==iCell,5), apdata(apdata(:,9)==iCell,6),15,c(apdata(:,9)==iCell,:))
    ylim([0 10])
    xlim([0 15])
    ylabel('Duration (s)')
    xlabel('# Aps fired')
    pimpPlot
     
    hold on
    celldata = apdata(apdata(:,9)==iCell,:);
    scatter(celldata(comp==0,5), celldata(comp==0,6),17,'black', 'filled');
    
    %%
    subplot(2,1,2)
    scatter(apdata(apdata(:,9)==iCell,4), apdata(apdata(:,9)==iCell,3),15,c(apdata(:,9)==iCell,:))
    ylabel('Amplitude (Calcium)')
    xlabel('Participation')
    
    hold on
    scatter(celldata(comp==0,4), celldata(comp==0,3),17,'black', 'filled');
    
end


%% Clustering, each cell

for iCell = 1:5
    
    celldata = apdata(apdata(:,9)==iCell,:);
    clear caInd
    figure()
    %subplot(3,1,1)
    clusterme = [celldata(:,6) celldata(:,5)];
    D = pdist(clusterme);
    tree = linkage(D,'ward'); % same as tree2 = linkage(coacT,'ward');
    c_size = 2;
    c = cluster(tree,'maxclust',c_size);
    s = silhouette(clusterme, c);
    
    meanAP1 = nanmean(celldata(c==1,5));
    meanAP2 = nanmean(celldata(c==2,5));
    
    if meanAP1>meanAP2
        caInd(celldata(:,4)<=80,:) = 2;
        caInd(celldata(:,4)>80,:) = 1;
    else
        caInd(celldata(:,4)<=80,:) = 1;
        caInd(celldata(:,4)>80,:) = 2;
    end
    
    comp = c == caInd;
    %dendrogram(tree,0)
    %title('Default Leaf Order')
    %%
    subplot(2,1,1)
    
    scatter(celldata(:,5), celldata(:,6),15,caInd)
    ylim([0 15])
    xlim([0 15])
    
    %%
    subplot(2,1,2)
    scatter(celldata(:,5), celldata(:,6),15,c)
    
    ylim([0 15])
    xlim([0 15])
    ylabel('Duration (s)')
    xlabel('# Aps fired')
    pimpPlot
    
    hold on
    scatter(celldata(comp==0,5), celldata(comp==0,6),17,'black', 'filled');
    
    corr(iCell,1) = sum(comp)./size(comp,1);
    
end

