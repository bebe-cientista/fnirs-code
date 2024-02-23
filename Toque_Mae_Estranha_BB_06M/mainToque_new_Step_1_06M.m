
clear
% load data from all volunteers
load('C:\Users\User\Documents\fNIRS_Unicamp\BB_6M\Grouped_06M_Mae_Estranha.lob','-mat');

data = data_NIRS;

% Available Participants
AvailableParticipants = [2 4 8];

% Step 1: Preprocess the fNIRS data

for Nsub = AvailableParticipants
        
    % Select data to analyze
    r = data{Nsub};
    
    % Compute Optical Density
    dOD = r.Convert2OD();
    
    % TDDR Correction
    r.SD.MeasListAct = ones(size(r.d,2),1);
    
    % Perform TDDR correction
    Opt_tDDR = 0;
    dOD_tDDR = TDDR(dOD,r.SD.f);
    
    % Perform Wavelet Decomposition
    dODws = r.WaveletCorrection(dOD_tDDR, 1);

    % Estimate concentration
    r.dc = r.Convert2Conc(dODws,[3 3]);
    
    % Save data for further analysis
    data{Nsub} = r;
    
end

% Save Preprocessed Datar for further analysis
save("C:\Users\User\Documents\fNIRS_Unicamp\BB_6M\" + "preprocessed_06M_data_Mae_Estranha",'AvailableParticipants','data')



