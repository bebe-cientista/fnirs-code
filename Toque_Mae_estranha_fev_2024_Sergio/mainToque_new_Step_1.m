
clear
% load data from all volunteers
load('Gouped_10M_Mae_Estranha.lob','-mat');

data = data_NIRS;

% Available Participants
AvailableParticipants = [1 2 5 9 13 14 15 16 ...
    18 21 22 23 24 25 28 29 35 37 38];

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
    dOD_tDDR = hmrMotionCorrectTDDR_adapted(dOD,r.SD,r.SD.f,Opt_tDDR);
    
    % Perform Wavelet Decomposition
    dODws = r.WaveletCorrection(dOD_tDDR, 1);

    % Estimate concentration
    r.dc = r.Convert2Conc(dODws,[3 3]);
    
    % Save data for further analysis
    data{Nsub} = r;
    
end

% Save Preprocessed Datar for further analysis
save('preprocessed_data_Mae_Estranha','AvailableParticipants','data')



