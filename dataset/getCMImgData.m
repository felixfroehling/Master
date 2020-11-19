%% Create results folder

SKIP_NO_FRAMES  = 0;

pathName = "/media/felix/9ce00e1d-d50d-403d-ba09-269badf15f45/felix/SimOutput/";
%pathName = "/home/felix/Master/SimOutput/";
dirName = ['png-' datestr(now, 'yymmdd-HHMM')];
%dirName = ['png-calib-1'];
resultsFolder = fullfile(pathName,dirName);

[status,msg] = mkdir(resultsFolder);

if ~isequal(status,1)
   disp("Error creating results folder:")
   disp(msg)
end

%% Get Video Data Stream + Embedded Data

vds = tcpclient('localhost', 2211);                     %*********Care Added By Felix (port verändert)****************
handshake = read(vds, 64);
disp(char(handshake));

while (1)    
    
    while isequal(vds.BytesAvailable,0)
        %sleep
    end
    
    %% Process image data    
    header = read(vds,64);
    disp(char(header));
  
    img = read(vds,(1920*1080*3));
    red = img(1:3:end);
    green = img(2:3:end);
    blue = img(3:3:end);
    img = [red(:) green(:) blue(:)];
    
    img = reshape(img, [1920,1080,3]);
    img = imrotate(img,-90);
    img = flip(img,2); 
    %imshow(img); hold on;
    
    %% Process Embeded Data
    header = read(vds,64);
%     disp(char(header));
    
    % Get Data
    nObj = read(vds, 1, 'double');

    %if (nObj>0)
    if 1
%         display(nObj);
        simTime = char(header(20:24));
        if str2double(simTime)<10
            pngFile = fullfile(resultsFolder,['0' simTime '.png']);
        else
            pngFile = fullfile(resultsFolder,[simTime '.png']);
        end
        imwrite(img, pngFile);
    end
    
    %% Skip desired number of frames
        
    if (SKIP_NO_FRAMES > 0)
        skipFrames = read(vds,SKIP_NO_FRAMES*(64+(640*480*3)+64+(8)));
        clear skipFrames;
    end
    
end