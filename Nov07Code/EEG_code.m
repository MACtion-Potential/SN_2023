clc;
clear;
clear all;

datafile = load("EEG_Clip1");
EEG_Clip1 = datafile.ThisEEG;
length_EEG = length(EEG_Clip1);
movie_order = load("Dt_Order_Movie");
PermutationList = movie_order.PermutationList;
self_reports = load("Dt_SelfReports.mat");
AllRatings = self_reports.Ratings;

% Let's start with the first video for P01
Movie_P01_path = "C:/Users/macke/OneDrive/Documents/MACKENZIE SCHOOL STUFF/MACtion Potential/Movie_P01";
addpath(Movie_P01_path);
P = 1;
% Create a matrix for person 1 composed of the rating column for each movie
P1_ratings = zeros(5,36);
for movie = 1:36
    P1_movie_rating = AllRatings(:,P,movie);
    P1_ratings(:,movie) = P1_movie_rating;
end

% Find the EEG recording for person 1 for the first video from
% Movie_P01_path
Grouped_EEG_Rating_P1 = zeros(13,length_EEG,36);
for i = 1:36
    clip_num = PermutationList(P,i);
    % Construct the filename for the current clip number
    filename = sprintf('%s/EEG_Clip%d.mat', Movie_P01_path, clip_num);
    EEG_data = load(filename);
    EEG = EEG_data.ThisEEG;
    Grouped_EEG_Rating_P1(1:5,length_EEG,i) = EEG;
    Grouped_EEG_Rating_P1(6:13,1,i) = P1_ratings(:,i);
end


