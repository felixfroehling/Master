list = dir('/media/felix/9ce00e1d-d50d-403d-ba09-269badf15f45/felix/Dataset/*.png');
% list = dir('/home/reway/06_cmprojects/dataset/archieve/working/20200717/*.png');
folder = list(1).folder;
list = vertcat(list.name);
list = strcat([folder '/'],list);

test = list(1:10:end,:);

t = [list; test];
[train, i1] = unique(t, 'rows', 'first');
[train, i2] = unique(t, 'rows', 'last');
train = train(i1==i2,:);

writematrix(test, 'test.txt');
writematrix(train, 'train.txt');

% list = dir('/home/reway/ros-img/*.jpg');
% folder = list(1).folder;
% list = vertcat(list.name);
% list = strcat([folder '/'],list);

% test = list(1:10:end,:);
% 
% t = [list; test];
% [train, i1] = unique(t, 'rows', 'first');
% [train, i2] = unique(t, 'rows', 'last');
% train = train(i1==i2,:);

% writematrix(test, 'test.txt');
% writematrix(list, 'train.txt');