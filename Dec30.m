clc;
clear;
clear all;

EEGData_Path = "C:/Users/macke/OneDrive/Documents/MACKENZIE SCHOOL STUFF/MACtion Potential/Nov14Code/EEGData";
All_VideoOrders = load("Dt_Order_Movie");
All_VideoOrders = All_VideoOrders.PermutationList;
All_Ratings = load("Dt_SelfReports.mat");
All_Ratings = All_Ratings.Ratings;

% Get a list of all files and folders in EEGData_path
EEGData_FolderList = dir(EEGData_Path);
% Get a logical vector that tells which is a directory
DirFlags = [EEGData_FolderList.isdir];
% Include only the directories in the list
EEGData_FolderList = EEGData_FolderList(DirFlags);

% Loop through all folders in EEGData (58 folders - 1 per person)
All_PX_EEGClips = cell(58,36);
FolderIndex = 0;
for X = 1:60

    % Get the name of the folder ("Movie_PX")
    FolderName = EEGData_FolderList(X).name;

    % Skip the current folder (.) and the parent folder (..)
    if strcmp(FolderName, '.') || strcmp(FolderName, '..') || ~EEGData_FolderList(X).isdir
        continue
    end

    % Increment the folder index
    FolderIndex = FolderIndex + 1;

    % Get the full path of the folder
    Folder_Path = fullfile(EEGData_Path, FolderName);
    % Get a list of all files in the folder "Movie_PX"
    FileList = dir(fullfile(Folder_Path, '*.mat'));
    
    % Sort the files in Movie_PX to be in ascending order (36 files - 1 per video)
    Y_values = zeros(1, 36);
    for Y = 1:36
        FileName = FileList(Y).name;
        Y_str = regexp(FileName, 'EEG_Clip(\d+)', 'tokens', 'once');
        Y_values(Y) = str2double(Y_str{1});
    end

    % Sort the file list based on Y values in ascending order
    [~, order] = sort(Y_values);
    SortedFileList = FileList(order);

    % Load the sorted files
    for Y = 1:36
        SortedFileName = SortedFileList(Y).name;
        FullFilePath = fullfile(Folder_Path, SortedFileName);
        All_PX_EEGClips{FolderIndex, Y} = load(FullFilePath);
    end
        
end

% Format the Ratings Data
All_PX_Ratings = cell(58,36);
Sorted_PX_Ratings = cell(58,36);
for X = 1:58
    % Sort the Ratings so that each person's rating order corresponds to
    % the same movie order
    PX_VideoOrder = All_VideoOrders(X,:);
    PX_Ratings = squeeze(All_Ratings(:,X,:));
    for Y = 1:36
        PX_VY_ind = PX_VideoOrder(1,Y);
        Sorted_PX_Ratings{X,PX_VY_ind} = PX_Ratings(:,Y);
    end
end

% Add zeros to the end of each cell in Sorted_PX_Ratings to match the 
% length of the corresponding EEG (this is easy since now there is a 1:1
% correspondence between the order of the EEG and the Ratings
All_PX_VY_EEG_Ratings = cell(58,36);
for X = 1:58
    for Y = 1:36
        PX_VY_EEG = All_PX_EEGClips{X,Y}.ThisEEG;
        [electrodes,lengthEEG] = size(PX_VY_EEG);
        zeros_to_add = lengthEEG - 1;
        PX_VY_Rating = Sorted_PX_Ratings{X,Y};
        Padded_PX_VY_Rating = [PX_VY_Rating,zeros(5,zeros_to_add)];
        PX_VY_EEG_Rating = vertcat(PX_VY_EEG,Padded_PX_VY_Rating);
        All_PX_VY_EEG_Ratings{X,Y} = PX_VY_EEG_Rating;
    end
end

