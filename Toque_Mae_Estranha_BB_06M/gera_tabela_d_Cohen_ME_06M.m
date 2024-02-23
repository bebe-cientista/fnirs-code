load("C:\Users\User\Documents\fNIRS_Unicamp\BB_6M\" + "Hemodynamic_response_individual_level.mat")

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

[active_ME, d_Cohen_ME] = ...
    computeActivatedChannel_ME(Hb_Mae_avg(:,:,1),Hb_Mae_avg(:,:,2),Hb_Estranha_avg(:,:,1),Hb_Estranha_avg(:,:,2),...
    t,-3,15);

SD.MeasList = data{1,2}.SD.MeasList(1:28,:); % somente um modelo... qualquer ocorrência serve

% label sources and detectors
sources = convertCharsToStrings( arrayfun(@(x)num2str(x), SD.MeasList(:,1), 'UniformOutput', false) );
detectors = convertCharsToStrings( arrayfun(@(x)num2str(x), SD.MeasList(:,2), 'UniformOutput', false) );
channel = convertCharsToStrings( arrayfun(@(x)num2str(x), 1:size(SD.MeasList,1), 'UniformOutput', false) );
source_detectors_labels = "S" + sources + "_D" + detectors + " " + channel'; 
source_detectors = "S" + sources + " D" + detectors;

T_Cohen_ME_hbo = array2table(d_Cohen_ME(:,:,1), 'VariableNames', source_detectors_labels');
T_Cohen_ME_hbr = array2table(d_Cohen_ME(:,:,2), 'VariableNames', source_detectors_labels');

diretorio_out = 'C:\Users\User\Documents\fNIRS_Unicamp\BB_6M\';
writetable(T_Cohen_ME_hbo, diretorio_out + "d_Cohen_ME_06M.xlsx", 'Sheet', 'd_Cohen_ME_hbo');
writetable(T_Cohen_ME_hbr, diretorio_out + "d_Cohen_ME_06M.xlsx", 'Sheet', 'd_Cohen_ME_hbr');

% Plot Activated Channels for each condition

lst_active_ME = find(active_ME==1);

% ME
figure(1);
i = 1;
for Nchan = lst_active_ME
    % figure(Nchan)
    subplot(3,5,i);
    plot(t,Hb_Mae_avg(:,Nchan,1),'-r','LineWidth',1);
    hold on;
    plot(t,Hb_Mae_avg(:,Nchan,2),'-b','LineWidth',1);
    grid on;
    plot(t,Hb_Estranha_avg(:,Nchan,1),':r','LineWidth',1);
    hold on;
    plot(t,Hb_Estranha_avg(:,Nchan,2),':b','LineWidth',1);
    grid on;
    
    y_min_max = axis(gca);
    y_min_max = y_min_max(3:4)
    % disp(y_min_max);
    fill([2,15,15,2],[y_min_max(1)+1,y_min_max(1)+1,y_min_max(2)-1,y_min_max(2)-1],'b', 'FaceAlpha', 0.05, 'EdgeColor', 'none');
    
    if i==2
        legend('HBO Mãe','HBR Mãe','HBO Estranha','HBR Estranha', 'Location', 'Best', 'FontSize', 5);
    end
    xlim([-3 25]);
    
    if i==1
        ylabel('Hemoglobin Changes');
    end
    
    xlabel('Time (s)');
    title([char(source_detectors(Nchan)) ' (' num2str(Nchan) ')']);
    set(gca,'Fontname','Times','Fontsize',10)
    print(['ME_Hb_canal_' num2str(Nchan)],'-dpng','-r300');
    
    i = i + 1;
end

