% This script generates a DataSet from txt raw data file. Some of data
% might have higher dimension that 256 size. So, in this program when this
% is detected only takes first 256 element from the row and stores in a new
% matrix 1000x256 dimension. At the end essambles all in one mat 
% Check nom_dir, nom_arch_SSCx and TestMat_Sinc_XXdB
%--------------------------------------------------------------------------
clear all, clc;
%---------------------- Nombre de Archivos --------------------------------
nom_dir = 'C:\Users\guill\OneDrive\Escritorio\ann_paper_hpo\1_DeepLearningExamples\Gauss_20dB\';
inputName     = 'Gauss_20dB_Test'; % .mat name
%--------------------------------------------------------------------------
cont = 1;
n_raw = 1000;
n_column = 256;

% individual files
nom_arch_SSC1 = 'Gauss_20dB_NoDef_raw_signal_Test'; 
nom_arch_SSC2 = 'Gauss_20dB_Gauss1_raw_signal_Test';
nom_arch_SSC3 = 'Gauss_20dB_Gauss2_raw_signal_Test';
nom_arch_SSC4 = 'Gauss_20dB_Pb1_raw_signal_Test';
nom_arch_SSC5 = 'Gauss_20dB_Pb2_raw_signal_Test';
%Cantidad de Sublotes (Deformaciones)
cant_signal = 5; 

%---------------------------- ---------------------------- ----------------
nom_arch = [nom_dir,nom_arch_SSC1,'.txt'];
%%%% Apertura del archivo SSC - Modo lectura
archSSC = 0;
[archSSC,msjarchSSC] = fopen(nom_arch,'rt');
if archSSC == -1 
    disp(msjarchSSC);
    return
end

Mat_database_SSC1 = zeros(n_raw,n_column); %Evito asig dinamica de memoria

% Check size 256 long elements and store in a Mat.
frewind(archSSC); % Reset file line ptr value.
while feof(archSSC) == 0
        SSCMat_Aux = str2num(fgetl(archSSC)); % fgetl increase file ptr
        if size(SSCMat_Aux,2) > n_column
            Mat_database_SSC1(cont,1:n_column) = SSCMat_Aux(1,1:n_column); %only takes first 256 elements
        else
            Mat_database_SSC1(cont,:) = SSCMat_Aux(1,:); 
        end
        cont = cont + 1;
end

%---------------------------- ---------------------------- ----------------
nom_arch = [nom_dir,nom_arch_SSC2,'.txt'];
%%%% Apertura del archivo SSC - Modo lectura
archSSC = 0;
[archSSC,msjarchSSC] = fopen(nom_arch,'rt');
if archSSC == -1 
    disp(msjarchSSC);
    return
end
cont = 1;
n_raw = 1000;
n_column = 256;
Mat_database_SSC2 = zeros(n_raw,n_column); %Evito asig dinamica de memoria

% Check size 256 long elements and store in a Mat.
frewind(archSSC); % Reset file line ptr value.
while feof(archSSC) == 0
        SSCMat_Aux = str2num(fgetl(archSSC)); % fgetl increase file ptr
        if size(SSCMat_Aux,2) > n_column
            Mat_database_SSC2(cont,1:n_column) = SSCMat_Aux(1,1:n_column); %only takes first 256 elements
        else
            Mat_database_SSC2(cont,:) = SSCMat_Aux(1,:); 
        end
        cont = cont + 1;
end

%---------------------------- ---------------------------- ----------------
nom_arch = [nom_dir,nom_arch_SSC3,'.txt'];
%%%% Apertura del archivo SSC - Modo lectura
archSSC = 0;
[archSSC,msjarchSSC] = fopen(nom_arch,'rt');
if archSSC == -1 
    disp(msjarchSSC);
    return
end
cont = 1;
n_raw = 1000;
n_column = 256;
Mat_database_SSC3 = zeros(n_raw,n_column); %Evito asig dinamica de memoria

% Check size 256 long elements and store in a Mat.
frewind(archSSC); % Reset file line ptr value.
while feof(archSSC) == 0
        SSCMat_Aux = str2num(fgetl(archSSC)); % fgetl increase file ptr
        if size(SSCMat_Aux,2) > n_column
            Mat_database_SSC3(cont,1:n_column) = SSCMat_Aux(1,1:n_column); %only takes first 256 elements
        else
            Mat_database_SSC3(cont,:) = SSCMat_Aux(1,:); 
        end
        cont = cont + 1;
end

%---------------------------- ---------------------------- ----------------
nom_arch = [nom_dir,nom_arch_SSC4,'.txt'];
%%%% Apertura del archivo SSC - Modo lectura
archSSC = 0;
[archSSC,msjarchSSC] = fopen(nom_arch,'rt');
if archSSC == -1 
    disp(msjarchSSC);
    return
end
cont = 1;
n_raw = 1000;
n_column = 256;
Mat_database_SSC4 = zeros(n_raw,n_column); %Evito asig dinamica de memoria

% Check size 256 long elements and store in a Mat.
frewind(archSSC); % Reset file line ptr value.
while feof(archSSC) == 0
        SSCMat_Aux = str2num(fgetl(archSSC)); % fgetl increase file ptr
        if size(SSCMat_Aux,2) > n_column
            Mat_database_SSC4(cont,1:n_column) = SSCMat_Aux(1,1:n_column); %only takes first 256 elements
        else
            Mat_database_SSC4(cont,:) = SSCMat_Aux(1,:); 
        end
        cont = cont + 1;
end

%---------------------------- ---------------------------- ----------------
nom_arch = [nom_dir,nom_arch_SSC5,'.txt'];
%%%% Apertura del archivo SSC - Modo lectura
archSSC = 0;
[archSSC,msjarchSSC] = fopen(nom_arch,'rt');
if archSSC == -1 
    disp(msjarchSSC);
    return
end
cont = 1;
n_raw = 1000;
n_column = 256;
Mat_database_SSC5 = zeros(n_raw,n_column); %Evito asig dinamica de memoria

% Check size 256 long elements and store in a Mat.
frewind(archSSC); % Reset file line ptr value.
while feof(archSSC) == 0
        SSCMat_Aux = str2num(fgetl(archSSC)); % fgetl increase file ptr
        if size(SSCMat_Aux,2) > n_column
            Mat_database_SSC5(cont,1:n_column) = SSCMat_Aux(1,1:n_column); %only takes first 256 elements
        else
            Mat_database_SSC5(cont,:) = SSCMat_Aux(1,:); 
        end
        cont = cont + 1;
end

%==========================================================================
% Concatenate and save final DataSet file.

TestMat_Gauss_20dB    = [Mat_database_SSC1;Mat_database_SSC2; ...
                 Mat_database_SSC3; Mat_database_SSC4; ...
                 Mat_database_SSC5];
save(inputName,'TestMat_Gauss_20dB'); % inputName

