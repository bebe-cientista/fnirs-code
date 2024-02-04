load Hemodynamic_response_individual_level.mat

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

[active_Mae, d_Cohen_Mae] = ...
    computeActivatedChannel_RG(Hb_Mae_avg(:,:,1),Hb_Mae_avg(:,:,2),...
    t,-3,15);

[active_Estranha, d_Cohen_Estranha] = ...
    computeActivatedChannel_RG(Hb_Estranha_avg(:,:,1),Hb_Estranha_avg(:,:,2),...
    t,-3,15);


SD.MeasList = data{1,1}.SD.MeasList(1:28,:);

% label sources and detectors
sources = convertCharsToStrings( arrayfun(@(x)num2str(x), SD.MeasList(:,1), 'UniformOutput', false) );
detectors = convertCharsToStrings( arrayfun(@(x)num2str(x), SD.MeasList(:,2), 'UniformOutput', false) );
channel = convertCharsToStrings( arrayfun(@(x)num2str(x), 1:size(SD.MeasList,1), 'UniformOutput', false) );
source_detectors_labels = "S" + sources + "_D" + detectors + " " + channel'; 

T_Cohen_Mae_hbo = array2table(d_Cohen_Mae(:,:,1), 'VariableNames', source_detectors_labels');
T_Cohen_Mae_hbr = array2table(d_Cohen_Mae(:,:,2), 'VariableNames', source_detectors_labels');
T_Cohen_Estranha_hbo = array2table(d_Cohen_Estranha(:,:,1), 'VariableNames', source_detectors_labels');
T_Cohen_Estranha_hbr = array2table(d_Cohen_Estranha(:,:,2), 'VariableNames', source_detectors_labels');

diretorio_out = 'C:\Users\User\Documents\fNIRS_Unicamp\';
writetable(T_Cohen_Mae_hbo, diretorio_out + "d_Cohen.xlsx", 'Sheet', 'd_Cohen_Mae_hbo');
writetable(T_Cohen_Mae_hbr, diretorio_out + "d_Cohen.xlsx", 'Sheet', 'd_Cohen_Mae_hbr');
writetable(T_Cohen_Estranha_hbo, diretorio_out + "d_Cohen.xlsx", 'Sheet', 'd_Cohen_Estranha_hbo');
writetable(T_Cohen_Estranha_hbr, diretorio_out + "d_Cohen.xlsx", 'Sheet', 'd_Cohen_Estranha_hbr');



