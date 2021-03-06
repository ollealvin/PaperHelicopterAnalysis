function [angularFreq, angleVec] = readvideo(file,fps,startFrame,plotting,stop,...
                                    cropx,cropy)
%READVIDEO reads video of paper helicopter and calculates rotation
%
% INPUT
% file  (string)        :   Name and path to video file
% fps   (integer)       :   Number of frames per second in video
% startFrame (integer)  :   Cuts all frames up to this number
% plotting (true/false) :   Enable/disable plotting feature
% stop (true/false)     :   Determine whether the function should terminate
%                           after angular frequency is determined
% ------------  The following input arguments are optional  ---------------
% cropx (double array)  :   Cropping of the video, given on the format
%                           [firstpixel:lastpixel]
% cropy (double array)  :   Cropping of the video, given on the format
%                           [firstpixel:lastpixel]
%
% OUTPUT
% angular_freq          :   Calculated value of angular frequency
%
% Created 2017-02-03 by
% Olle Alvin, Jonathan Astermark, Julia H. Fovaeus, John Hellborg

if nargin == 5
    cropping = false;
elseif nargin == 7
    cropping = true;
else
    error('Invalid number of input arguments in readvideo')
end
        
v = VideoReader(file);

ctr = 1;
fprintf('Discarding first %d frames.\n',startFrame-1)
while hasFrame(v) && ctr < startFrame
    frame = readFrame(v);
    ctr = ctr+1;
end
if plotting
   figure(1)
   clf
end
timePerFrame = 1/fps;
found = false;
angularFreq = -Inf;

while hasFrame(v)
    frame = readFrame(v);
    if cropping
        croppedframe = frame(cropx,cropy,:);
    else
   frame = rgb2gray(frame);
    end
    T = (frame>180);
    [angle,c,vec] = angleCalc(T);
    % Save angle on first frame
    if ctr == startFrame
        startAngle = angle;
        relAngle = 0;
        time = 0;
        timeSinceReset = 0;
    else
        relAnglePrev = relAngle;
        relAngle = angle-startAngle;
    end
    % Half period completed when the relative angle crosses zero, but not
    % by a fold-around
    if ((relAngle > 0 && relAnglePrev < 0) ...
             || (relAngle < 0 && relAnglePrev > 0)) ...
            && abs(relAngle - relAnglePrev) < pi/4 ... % fold-around
            % Alternative: add && ~found to only look for first value
%         ctr
        elapsedTime = timeSinceReset;
        newFreq = pi/elapsedTime;
        if newFreq > angularFreq % Keep only fastest rotation speed
            angularFreq = newFreq;
        end
        found = true;
        if stop
            return
        else
            % Start new measurement
            startAngle = angle;
            relAngle = 0;
            timeSinceReset = 0;
        end
    end
    if plotting
%     imshow(grayimg)
%     imagesc(grayimg)
        colormap(gray)
        imagesc(T)
        %%%%%%%%%%%
        hold on
        p1 = c;
        p2 = c + vec*100;
        p3 = c + vec*(-100);
        plot(p1(1),p1(2), '*r')
        line([p1(1) p2(1)], [p1(2) p2(2)])
        line([p1(1) p3(1)], [p1(2) p3(2)])
        %%%%%%%%
        title(['frame: ',num2str(ctr), ', t = ',...
               num2str(time),' s, angle: ',num2str(angle)])
%         fprintf('Paused, press any button for next frame.\n')
        pause(0.05)
    end
    angleVec(ctr) = angle;
    time = time + timePerFrame;
    timeSinceReset = timeSinceReset + timePerFrame;
    ctr = ctr+1;
end

if ~found
    error(['Video ended before a value was calculated.\n',...
        ' Consider reducing value of startFrame.'])
end
angleVec = angleVec';
end
