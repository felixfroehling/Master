%% Define constants

frontcam         = CamSensor("/home/felix/Master/dataset/cameraParams.mat");

sensorDataFolder = "/media/felix/9ce00e1d-d50d-403d-ba09-269badf15f45/felix/SimOutput/";
%sensorDataFolder = "/home/felix/Master/SimOutput/";
sensorDataFile   = "rightlane4.txt";
sensorDataTxt    = load(fullfile(sensorDataFolder,sensorDataFile));

%% Read png folder and extract timestamps

disp('Reading png folder and extracting ts...');

imgDataFolder = fullfile(sensorDataFolder, "png-rightlane4");
imgList       = dir(fullfile(imgDataFolder, '/*.png'));

imgTimestamps = [];
for l = 1:size(imgList,1)
    imgTimestamps(end+1) = str2double(erase(imgList(l).name,'.png'));
end

imgTimestamps = sort(imgTimestamps);

%% Compare both timestamps

disp('Comparing both timestamps...');

commonTimestampsIdx = [];

l=1;
for k = 1:size(imgTimestamps,2)
    while l < size(sensorDataTxt,1)
        if isequal(imgTimestamps(k), sensorDataTxt(l,1))
            commonTimestampsIdx(end+1,:) = l;
            l = size(sensorDataTxt,1); % get out of loop
        end
        nObj = sensorDataTxt(l,2);
        l = l+nObj+1;
    end
    l=1;
end

%% Create Objects from Sensor Data

disp('Creating objects from sensor data...');

k = 1;
l = commonTimestampsIdx(1);
sensorDataArray = {};
while k < size(commonTimestampsIdx,1)
    detectionsArray = {};
    timestamp = sensorDataTxt(l,1);
    nObj = sensorDataTxt(l,2);

    for objIndex = 1:nObj
        class = sensorDataTxt(l+objIndex,1);
        bl_x  = sensorDataTxt(l+objIndex,2);
        bl_y  = sensorDataTxt(l+objIndex,3);
        bl_z  = sensorDataTxt(l+objIndex,4);
        tr_x  = sensorDataTxt(l+objIndex,5);
        tr_y  = sensorDataTxt(l+objIndex,6);
        tr_z  = sensorDataTxt(l+objIndex,7);
        yaw   = sensorDataTxt(l+objIndex,8);
        distR = sensorDataTxt(l+objIndex,9);
        distX = sensorDataTxt(l+objIndex,10);
        speed = sensorDataTxt(l+objIndex,11);
        detectionsArray{end+1} = Detection(class, bl_x, bl_y, bl_z, tr_x, tr_y, tr_z, yaw, distR, distX, speed);
    end
    
    sData = SensorData(timestamp, detectionsArray);
    sensorDataArray{end+1} = sData;
    
    k = k+1;
    l = commonTimestampsIdx(k);
end

% set(frontcam, 'SensorData', sensorDataArray);

frontcam.Data = sensorDataArray;

%% Convert from sensor coord to pixel 

disp('Converting objects to pixel coordinates...');

for k = 1:size(frontcam.Data,2)
    for l = 1:size(frontcam.Data{k}.Detections,2)
        frontcam.Data{k}.Detections{l} = frontcam.Data{k}.Detections{l}.toPixelCoord(frontcam.Object);
        frontcam.Data{k}.Detections{l} = frontcam.Data{k}.Detections{l}.calcDistances();
    end
end

%% Create dataset in YOLO format

disp('Saving dataset in YOLO format...');

folder = '/media/felix/9ce00e1d-d50d-403d-ba09-269badf15f45/felix/Dataset';
[status,msg] = mkdir(folder);
% figure; hold on;

for k = 1:1:size(frontcam.Data,2)
    name = '11';
    imgfile = [name sprintf('%05d', k) '.png'];
    copyfile(fullfile(imgList(k).folder,imgList(k).name),fullfile(folder,imgfile));
    %fprintf('%s   and  %s\n', imgList(k).name, imgfile);     %debug output
%     I = imread(fullfile(folder,imgfile));

    txtfile = [name sprintf('%05d', k) '.txt'];
    fid=fopen(fullfile(folder, txtfile), 'w');
        
    for l = 1:size(frontcam.Data{k}.Detections,2)
%     for l = 1:1
     
%         if ((frontcam.Data{k}.Detections{l}.DistX > 5) && (frontcam.Data{k}.Detections{l}.DistX < 40))
            
            x_center = frontcam.Data{k}.Detections{l}.BoundingBox.x + (frontcam.Data{k}.Detections{l}.BoundingBox.width/2);
            y_center = frontcam.Data{k}.Detections{l}.BoundingBox.y + (frontcam.Data{k}.Detections{l}.BoundingBox.height/2);
            
            label = [x_center / frontcam.Object.Intrinsics.ImageSize(2), ...
                     y_center / frontcam.Object.Intrinsics.ImageSize(1) - 75/1080, ...
                     frontcam.Data{k}.Detections{l}.BoundingBox.width / frontcam.Object.Intrinsics.ImageSize(2), ...
                     frontcam.Data{k}.Detections{l}.BoundingBox.height / frontcam.Object.Intrinsics.ImageSize(1), ...
                     frontcam.Data{k}.Detections{l}.DistX];
                 
            tooSmallElements = find(label<1E-3);
            if ~isempty(tooSmallElements)
                label(tooSmallElements) = label(tooSmallElements)+1E-3;
            end
            
            
            fprintf(fid, '%d %.4f %.4f %.4f %.4f %.4f\n', frontcam.Data{k}.Detections{l}.Class, label);
            %fprintf(fid, '%d %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f\n', frontcam.Data{k}.Detections{l}.Class, label,...
             %   frontcam.Data{k}.Detections{l}.DistX); %Added by Felix
                     
%             fprintf(fid, '%d %.3f %.3f %.3f %.3f %.3f %f\n', ...
%                 [frontcam.Data{k}.Detections{l}.Class ...
%                 x_center / frontcam.Object.Intrinsics.ImageSize(2) ...
%                 y_center / frontcam.Object.Intrinsics.ImageSize(1)...
%                 frontcam.Data{k}.Detections{l}.BoundingBox.width / frontcam.Object.Intrinsics.ImageSize(2) ...
%                 frontcam.Data{k}.Detections{l}.BoundingBox.height / frontcam.Object.Intrinsics.ImageSize(1) ...
%                 frontcam.Data{k}.Detections{l}.DistX ...
%                 abs(frontcam.Data{k}.Detections{l}.DistY)]);
            
%         end
%         bboxA = [frontcam.Data{k}.Detections{l}.BoundingBox.x, frontcam.Data{k}.Detections{l}.BoundingBox.y,...
%                  frontcam.Data{k}.Detections{l}.BoundingBox.width, frontcam.Data{k}.Detections{l}.BoundingBox.height ];
%         detect = insertShape(I,'FilledRectangle',bboxA,'Color','green');
%         imshow(detect);
    end
    
    fclose(fid);
end

