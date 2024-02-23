%  Code to combine data into a single file and correct
% triggers

clear

mae = {};
estranha = {};

mae{2} = [1,2,3,4,11]; % [1,2,3,4,13];
estranha{2} = [5,6,7,8,9,10]; % [6,7,8,9,10,11];

mae{4} = [1,2,3,8]; %[2,3,4,9,10,11];
estranha{4} = [4,5,6,7,9,10]; % [5,6,7,8,13,14];

mae{5} = [1,2,3,12]; %[1,2,4,14];
estranha{5} = [4,5,6,7,8,9,10,11]; %[5,6,7,8,9,10,11,12];

mae{7} = [1,2,3,4,8,9]; %[1,2,3,4,9,10];
estranha{7} = [5,6,7]; %[5,6,7];

mae{8} = [1,2,3,4]; % [2,4,6,7];
estranha{8} = [5,6,7,8,9,10,11]; % [10,11,12,14,15,16,17];

mae{9} = [1,2,10,11,12]; %[3,4,13,14,15];
estranha{9} = [3,4,5,6,7,8,9]; %[5,6,7,8,9,10,12];

mae{10} = [1,2,6]; %[3,4,11];
estranha{10} = [3,4,5,7,8,9,10]; %[5,6,7,13,14,15,16];

mae{11} = [1,2,3]; %[1,2,3];
estranha{11} = [4,5,6]; %[5,6,7];

mae{12} = [1,2,3,4]; %[1,2,3,4];
estranha{12} = [5,6,7,8,9,10,11]; %[5,6,7,8,9,10,11];

mae{13} = [1,2,4,5]; %[1,9,11,12];
estranha{13} = [2,3,4,6,7]; %[5,7,13,15];

mae{14} = [1,2,3,4,12,13,14]; %[1,2,3,4,13,14,16];
estranha{14} = [5,6,7,8,9,10,11]; %[5,6,7,9,10,11,12];

mae{15} = [1,2,3,4,7,8]; %[1,2,3,4,11,12];
estranha{15} = [5,6,9,10]; %[6,7,13,14];

mae{16} = [1,2,5]; %[2,3, 12];
estranha{16} = [3,4,6]; %[5,8,15];

%mae{18} = [1,2,3,4,13,15,16]; % excluído, erro de sample
%estranha{18} = [5,6,7,8,9,10,11,12];

mae{19} = [1,2,3,5,6,7,8]; %[1,2,4,9,10,11,12];
mstranha{19} = [4,9,10,11,12]; %[5,13,14,15,16];

mae{20} = [1,2,3,4]; %[1,2,3,4];
estranha{20} = [5,6,7,8,9,10]; %[5,6,7,8,9,11];

mae{23} = [1,2,6,7,8]; %[3,4,9,11,12];
estranha{23} = [3,4,5,9,10,11,12]; %[5,6,8,13,14,15,16];


files = dir('C:\Users\User\Documents\fNIRS_Unicamp\BB_6M\06M*.lob');

for Nsub=1:size(files,1)
    
    
    % Extract file name
    data_name = files(Nsub).name;
    
    % Extract participant number
    N_index = str2num(data_name(6:8));
    
    % load file
    data_load_aux = load("C:\Users\User\Documents\fNIRS_Unicamp\BB_6M\" + data_name,'-mat');
    
    r = data_load_aux.data;
    
    % create new stim vector
    s_new = zeros(size(r.s,1),2);
    
    % trigger list
    lst_trigger = find(r.s==1);
    
    % Mao trigger will be saved in collum 1.
    s_new(lst_trigger(mae{N_index}),1) = 1;
    
    % Colher trigger will be saved in collum 1.
    s_new(lst_trigger(estranha{N_index}),2) = 1;
    
    %%% Update vector of stimulus
    r.s = s_new;
        
    % Remove negative values from light intensity
    lst = find(r.d<0);
    
    d_new = r.d;
    
    r.d(lst) = -1*r.d(lst);
    
%     for Nchan=1:56
%         figure(Nchan)
%         plot(d_new(:,Nchan),'-r');
%         hold on
%         plot(r.d(:,Nchan),'-k');
%     end
    
    
    data_NIRS{N_index} = r;
    
    clear lst* r s_new data_name data_load_aux d_new
    
    
    
    
end

% % Save combined data for further analysis
save('C:\Users\User\Documents\fNIRS_Unicamp\BB_6M\Grouped_06M_Mae_Estranha.lob','data_NIRS')


