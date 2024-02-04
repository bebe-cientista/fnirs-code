% This steps computes the average hemodynamic response function
% for the data preprocessed in step 1.
clear

% load data
load preprocessed_data_Mae_Estranha_10_meses.mat

% Define parameters of analysis
fNIRS_Properties.t_baseline = 3;
fNIRS_Properties.t_recovery = 25;
fNIRS_Properties.StimType = nan;
fNIRS_Properties.duration = 15;

% Remove participants that do not have one of the tasks
% Remove_participants = [9 13 28 29 37];
AvailableParticipants(18) = [];
AvailableParticipants(16) = [];
AvailableParticipants(15) = [];
AvailableParticipants(5) = [];
AvailableParticipants(4) = [];

for Nsub = AvailableParticipants
    
    for Nstim=1:2
        
        fNIRS_Properties.StimType = Nstim;
        
        % get preprocessed data
        dummy = data{Nsub};
        
        % Band-pass filter the data
        dummy.dc = hmrBandpassFilt(dummy.dc,dummy.SD.f,0.005,.2);
        
        %%% Lets start the functional analysis
        temp = fnirs;
        temp.duration = fNIRS_Properties.duration;
        [temp.t, temp.concs] = dummy.CombineTrials(fNIRS_Properties);
        
        % Average HRF across all trials
        temp = temp.AverageTrials;
        data{Nsub}.fnirs{Nstim} = temp;
        
        
        clear dummy temp;
        
    end
end


% save hemodynamic responses of each participant
save('Hemodynamic_response_individual_level','data',...
    'AvailableParticipants')

% Combine data into a single variable to facilitate
% group analysis
cnt = 0;
for Nsub=AvailableParticipants
    
    cnt = cnt+1;
    
    Hb_all_Mae(:,:,:,cnt) = data{Nsub}.fnirs{1}.hrf;
    Hb_all_Estranha(:,:,:,cnt) = data{Nsub}.fnirs{2}.hrf;
    
    
end

t = data{2}.fnirs{1}.t;

% Gran Averages
Hb_Mae_avg = mean(Hb_all_Mae,4);
Hb_Estranha_avg = mean(Hb_all_Estranha,4);


% for Nchan=1:28
%
%     figure(Nchan)
% %     plot(t,Hb_Mao_avg(:,Nchan,1),'-r');
% %     hold on;
% %     plot(t,Hb_Mao_avg(:,Nchan,2),'-b');
% %
% %         hold on
% %
% %         plot(t,Hb_Colher_avg(:,Nchan,1),'--r');
% %         hold on;
% %         plot(t,Hb_Colher_avg(:,Nchan,2),'--b');
%
% end

close all

active_Mae = ...
    computeActivatedChannel(Hb_Mae_avg(:,:,1),Hb_Mae_avg(:,:,2),...
    t,-3,15);

active_Estranha = ...
    computeActivatedChannel(Hb_Estranha_avg(:,:,1),Hb_Estranha_avg(:,:,2),...
    t,-3,15);



lst_active_Mae = find(active_Mae==1);

lst_active_Estranha = find(active_Estranha==1);


% Plot Activated Channels for each condition

% Mao
for Nchan = lst_active_Mae
    figure(Nchan)
    plot(t,Hb_Mae_avg(:,Nchan,1),'-r','LineWidth',2);
    hold on;
    plot(t,Hb_Mae_avg(:,Nchan,2),'-b','LineWidth',2);
    grid on;
    xlim([-3 25]);
    ylabel('Hemoglobin Changes');
    xlabel('Time (s)');
    title(['Canal: ' num2str(Nchan)]);
    set(gca,'Fontname','Times','Fontsize',14)
    print(['Mae_avg_HbO_canal_' num2str(Nchan)],'-dpng','-r300');
end

% Colher
for Nchan = lst_active_Estranha
    figure(Nchan)
    plot(t,Hb_Estranha_avg(:,Nchan,1),'-r','LineWidth',2);
    hold on;
    plot(t,Hb_Estranha_avg(:,Nchan,2),'-b','LineWidth',2);
    grid on;
    xlim([-3 25]);
    ylabel('Hemoglobin Changes');
    xlabel('Time (s)');
    title(['Canal: ' num2str(Nchan)]);
    set(gca,'Fontname','Times','Fontsize',14)
    print(['Estranha_avg_HbO_canal_' num2str(Nchan)],'-dpng','-r300');
end

