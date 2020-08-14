[orange2, green2, green, orange, dgreen, grey, greyl, blue, red, pink, yellow]  = colors ();


%Read the relevant file
data = readtable('3.xlsx');
data.modality(data.modality == 0) = 2;



%%

%Reformat relevant data: Timestamps, modality, tempo and trial number
for i = 1:length(data.trial_index)
    stmp{i} = strsplit(data.time_stamps{i},',');
 
    
    for j = 1:length(stmp{i})
        stmpV(i,j) = str2num(stmp{i}{j});
        modalityV(i,j) = data.modality(i);
        TempoV(i,j) = data.trial_tempo(i);
        trialNum(i,j) = i;
        if modalityV(i,j) == 2
            SCPoint(i,j) = data.stimulation_start(i) + ((data.trial_tempo(i)+50)*30);
        else
            SCPoint(i,j) = data.stimulation_start(i) + (data.trial_tempo(i)*30);
        end
        if stmpV(i,j) <= SCPoint(i,j)
            SC(i,j) = 1;
        else
            SC(i,j) = 2;
        end
    end
end

%%
%Transpose data and calculate difference for timestamps
trialNum = trialNum';
respOrder = 1:length(trialNum);
Modality = modalityV';
Tempo = TempoV';
stmpDiff = diff(stmpV');
SCPoint = SCPoint';
SC = SC';
%a = stmpV';

%Erase missing data
trialNum(trialNum == 0) = [];
Modality(Modality == 0) = [];
Tempo(Tempo == 0) = [];
SCPoint(SCPoint == 0) = [];
SC(SC == 0) = [];
stmpDiff(stmpDiff==0) = [];
stmpDiff = [stmpDiff,0,0,0]; %Add back missing entries to level out the table

lData = table(trialNum',Modality',Tempo',stmpDiff', SC', 'variablenames',{'trialNum','Modality','Tempo','Resp', 'SC'});
%%
lData.Offset = lData.Resp - lData.Tempo;
lData.Tempo = lData.Tempo./1000; %milliseconds -> seconds
lData.Resp = lData.Resp ./1000; %milliseconds -> seconds
lData.Resp(lData.Resp<0.100) = NaN; %mark 'corrupted' data
lData.Resp(lData.Resp>2.5) = NaN; %mark 'corrupted' data

%Number the taps for each trial
for i = 1:length(unique(lData.trialNum))
    lData.resOrd(lData.trialNum == i) = 1:length(lData.trialNum(lData.trialNum == i));
end

%remove 'corrupted' data
lData(isnan(lData.Resp),:) = [];
%%

%Estimate of move from Synchrinization to Continuation
%for i = 1:length(unique(lData.trialNum))
    
    
    %lData.cumSum(lData.trialNum == i) = cumsum(lData.Resp(lData.trialNum == i));

    %lData.divP(lData.trialNum == i) = max(lData.cumSum(lData.trialNum == i)./2);
    %lData.SC(lData.cumSum <= lData.divP) = 1;
    %lData.SC(lData.cumSum > lData.divP) = 2;
    
%end

%Cumulative Average
for i=1:length(unique(lData.trialNum))
    lData.cumSum(lData.trialNum == i) = cumsum(lData.Resp(lData.trialNum == i));
end
lData.cumAvg = lData.cumSum ./ lData.resOrd;

%Mark first taps of each trial as 'corrupted'
lData.Resp(lData.resOrd<4) = NaN;

%figure;
%for i = 1:length(unique(lData.trialNum))
    
%    subplot(2,5,i) % 2 X 5 plots
%    nhist(lData.Resp(lData.trialNum == i),'color',green,'linewidth',0.1);
%    hold on; xline(lData.Tempo(lData.trialNum == i & lData.resOrd == 5),'linewidth',2.5);
    
%    lData.TF(lData.trialNum == i & lData.SC == 1) = isoutlier(lData.Resp(lData.trialNum == i & lData.SC == 1),'quartiles');
    
%    lData.TF(lData.trialNum == i & lData.SC == 2) = isoutlier(lData.Resp(lData.trialNum == i & lData.SC == 2),'quartiles');
    
  
%end


%figure;
%for i = 1:length(unique(lData.trialNum))
    
%    subplot(2,5,i)
%    nhist(lData.Resp(lData.trialNum == i),'color',green,'linewidth',0.1);
%    hold on; xline(lData.Tempo(lData.trialNum == i & lData.resOrd == 5),'linewidth',2.5);
%    
%    lData.TF(lData.trialNum == i & lData.SC == 1) = isoutlier(lData.Resp(lData.trialNum == i & lData.SC == 1),'quartiles');
%    
%    lData.TF(lData.trialNum == i & lData.SC == 2) = isoutlier(lData.Resp(lData.trialNum == i & lData.SC == 2),'quartiles');
%    
%  
%end

lData.RespN = lData.Resp;
%lData.RespN(lData.TF == 1) = NaN;

%figure;
%for i = 1:length(unique(lData.trialNum))
    
%    subplot(2,5,i)
%    nhist(lData.RespN(lData.trialNum == i),'color',green,'linewidth',0.1);
%    hold on; xline(lData.Tempo(lData.trialNum == i & lData.resOrd == 5),'linewidth',2.5);
%end

% Cumulative Average Chart

for i = 1:10
    figure;
    subplot(1,2,1)
    plot(lData.resOrd(lData.trialNum == i & lData.SC == 1), lData.Resp(lData.trialNum == i & lData.SC == 1), '.-');
    hold on; plot(lData.resOrd(lData.trialNum == i & lData.SC == 1 & lData.Modality == 1), lData.cumAvg(lData.trialNum == i & lData.SC == 1 & lData.Modality == 1));
    hold on; yline(lData.Tempo(lData.trialNum == i & lData.resOrd == 5), 'linewidth', 2.5);
    title('Auditory Sync');
    xlabel('Tap Index');
    subplot(1,2,2)
    plot(lData.resOrd(lData.trialNum == i & lData.SC == 2), lData.Resp(lData.trialNum == i & lData.SC == 2), '.-');
    hold on; plot(lData.resOrd(lData.trialNum == i & lData.SC == 2), lData.cumAvg(lData.trialNum == i & lData.SC == 2));
    hold on; yline(lData.Tempo(lData.trialNum == i & lData.resOrd == 5), 'linewidth', 2.5);
    title('Auditory Cont');
    xlabel('Tap Index');
end




%%   


dt  =  grpstats(lData,{'Tempo','Modality','SC'},{'mean','std'},...
    'DataVars',{'RespN', 'Offset'});
dt.cv = dt.std_RespN./dt.mean_RespN;



%%

Mod = 1; %(1 tactile 2 auditory)
SC = 2;
if Mod == 1
    sName = 'Tactile';
else
    sName = 'Auditory ';
end

if SC == 1 %(1 sync 2 cont)
    cName = 'Syncronization';
else
    cName = 'Continuation';
end

    
    
%% 
figure;

plot(dt.Tempo(dt.Modality == Mod & dt.SC==SC),dt.mean_RespN(dt.Modality == Mod & dt.SC==SC)...
    ,'o', 'MarkerSize',5,'MarkerFaceColor',orange2,'MarkerEdgeColor',orange2,'color',orange2,'linewidth',2);
hold on; plot(dt.Tempo(dt.Modality == Mod & dt.SC==SC),dt.mean_RespN(dt.Modality == Mod & dt.SC==SC)+dt.std_RespN(dt.Modality == Mod & dt.SC==SC)...
    ,'o', 'MarkerSize',2,'MarkerFaceColor',grey,'MarkerEdgeColor',grey,'color',grey,'linewidth',1);
hold on; plot(dt.Tempo(dt.Modality == Mod & dt.SC==SC),dt.mean_RespN(dt.Modality == Mod & dt.SC==SC)-dt.std_RespN(dt.Modality == Mod & dt.SC==SC)...
    ,'o', 'MarkerSize',2,'MarkerFaceColor',grey,'MarkerEdgeColor',grey,'color',grey,'linewidth',1);

xlabel('Target tempo (sec)','fontsize',15);
ylabel('Produced tempo (sec)','fontsize',15);

hold on;
xlim([0.1,2]);
%
ylim([0.1,2]);
hline = refline(1,0);
hline.Color = grey;
hline.LineWidth = 1;

% txtvec1 = nData.sub(1);
%     txtvec = ['sub ', num2str(txtvec1(1))];
%     slp = ['beta ', num2str(round(coef(i),2))];
%     R = ['Rsq ', num2str(round(Rsquared(i),2))]
%     text(1.200,0.250,txtvec);
%     text(1.200,0.200,slp);
%     text(1.200,0.150,R);
title(['Prodiced tempo: ',sName,' ',cName,]);

% plot(nData.fTempo, polyval(p,nData.fTempo),'color',grey,'linewidth',1.3);hold on;
set(gca, ...
    'Box', 'off', ...
    'TickDir', 'out');
grid off
% t1 = text(0.20,1.5, ['Beta ', num2str(round(coef(i),2))], 'FontSize', 14, 'Color', grey);
% t2 = text (0.2,1.34,['Rsquared ', num2str(round(Rsquared(i),2))],'FontSize', 14, 'Color', grey);
% t3 = text(0.2,1.42,['Sub ', num2str(txtvec1(1))],'FontSize', 14, 'Color',grey);
%pause;

% saveas(figure(i),[figuresdirLin,num2str(txtvec1(1)),'_','lin_sd_',sName,'_',num2str(cond),'.jpg']);
%  close;



%%

    

figure;


plot(dt.Tempo(dt.Modality == Mod & dt.SC == SC),dt.cv(dt.Modality == Mod & dt.SC == SC),'o','MarkerSize',8,'MarkerFaceColor',green,'MarkerEdgeColor',green,'color',green,'linewidth',1);


title(['Vriability: ',sName,' ',cName,]);
xlabel('Tempo (sec)');
ylabel('Variability (CV)');


grid on;
hold on;
xlim([0.1,2]);
% %
ylim([0,0.15]);
% hline = refline(1,0);
% hline.Color = grey;
% hline.LineWidth = 1;
grid off;
% txtvec1 = nData.sub(1);
% txtvec = ['sub ', num2str(txtvec1(1))];
% 
% text(1.200,0.200,txtvec);

%%
X = categorical(unique(lData.Tempo));
Mods = {'Tactile', 'Auditory'};
SynCont = {'Sync', 'Cont'};
figure;
bar(X, dt.mean_Offset(dt.Modality == Mod & dt.SC==SC));
title(['Mean offset of ' Mods(Mod) SynCont(SC)]);
ylim([-250, 150])




