%load('Analyzed_Executa_10.mat','-mat')

load Results_ToqueMae.mat
[HbO,HbR,HbT] = organize_Data(1,data);


 
active = ...
        computeActivatedChannel(HbO,HbR,...
            data{1}{1}.fnirs.t,-3,10);
Nsub=2;
lst = find(active(Nsub,:)==1)
for N=lst
figure(N)
plot(data{1}{1}.fnirs.t,data{Nsub}{1}.fnirs.hrf(:,N,1),'-r');
hold on; 
plot(data{1}{1}.fnirs.t,data{Nsub}{1}.fnirs.hrf(:,N,2),'-b');
ylabel('Hemoglobin Changes');
xlabel('Time (s)');
name = ['Subject: ' num2str(Nsub) '; Channel: ' num2str(N) ...
    ' ( S' num2str(data{1}{1}.SD.MeasList(N,1)) ' - D' ...
    num2str(data{1}{1}.SD.MeasList(N,2)) ' )' ];
title(name);
print(['Executa_SUB_' num2str(Nsub) '_Channel_' num2str(N)],'-dpng','-r150');
end