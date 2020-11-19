% DETECTOR        = vehicleDetectorACF('front-rear-view');

file = '1100905';
folder = "/media/felix/9ce00e1d-d50d-403d-ba09-269badf15f45/felix/Dataset";

img = strcat(fullfile(folder,file),'.png');

data = imread(img);
%img([1 1920], [1 1080], data);
figure; 
imshow(data);
hold on;

fid = fopen(strcat(fullfile(folder,file),'.txt'));
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    
    tline = sscanf(tline,'%f');

    x_center = tline(2)*1920;
    y_center = tline(3)*1080;
    width = tline(4)*1920;
    height = tline(5)*1080;
    bottom_left = [x_center-width/2.0 y_center-height/2.0];
    %top_right   = [x_center+(tline(5)*1920/2) y_center+(tline(4)*1080/2)];
    
    rectangle('Position', [bottom_left width height], 'Edgecolor', 'r');
    text(x_center+10, y_center, int2str(tline(6)), 'Color','red', 'FontSize', 14);

    plot(x_center,y_center,'r*');
end
