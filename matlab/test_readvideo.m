% Testing script for readvideo.m
% Created 2017-02-03
% Serves the same purpose as readvideo did before 2017-02-03
% but now uses the fact that readvideo is a function
%
clear all

file = '../data/top9.mp4'; % Videos should be in '../data/'
%file = 'binarytest.avi'
fps = 119; % Camera specific
startFrame = 1;
%cropx = 300:520;
%cropy = 300:980;

plotting = true; % Toggle plotting
stop = false;     % Toggle whether the script terminates immediately after
                 % an angular frequency is found

tic;
[angular_freq, angleVec] = readvideo(file,fps,startFrame,plotting,stop)
toc;

fprintf('Highest angular frequency: %f rad/s\n',angular_freq)

angDiff = angleVec - circshift(angleVec,1); 
figure(2)
plot(angleVec)
figure(3)
rotSpeeds = normangle2(angDiff)*119
plot(rotSpeeds, '*')

