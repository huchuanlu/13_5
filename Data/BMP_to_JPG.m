function BMP_to_JPG

% % fileName = 'Car4';
% % fileName = 'Car11';
% % fileName = 'Cliffbar';
% % fileName = 'Deer';
% % fileName = 'Occlusion1';
% % fileName = 'Occlusion2';
% % fileName = 'DavidOutdoor';
% % fileName = 'Jumping';
% % fileName = 'Singer1';
% % fileName = 'Football';
% % fileName = 'Lemming';
% % fileName = 'Caviar1';
% % fileName = 'Caviar2';
% % fileName = 'DavidIndoor'; 
% % fileName = 'Football';
fileName = 'Panda';

temp = importdata(['./' fileName '/' 'datainfo.txt']);
NUM  = temp(3);

for num = 1:NUM
    num
    I = imread(['./' fileName '/' num2str(num) '.bmp']);
    imwrite(I, ['./' fileName '/' num2str(num) '.jpg']);
end