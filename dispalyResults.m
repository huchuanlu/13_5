function dispalyResults
%%Algorithms:
algorithm = [{'pca'},...            %IVT/IPCA Tracker
             {'l1'},...             %L1   Tracker
             {'pn'},...             %PN   Tracker
             {'vtd'},...            %VTD  Tracker
             {'mil'},...            %MIL  Tracker
             {'frag'},...           %Frag Tracker
             {'srpca'}...           %srpca
            ];
%%Color:
color     = [{'b'},...       
             {'g'},...      
             {'k'},...         
             {'y'},...           
             {'m'},...           
             {'c'},...           
             {'r'}...
            ];

%%VideoName
% videoName = 'Lemming';
videoName = 'Occlusion2';

%%FontSize && LineWidth
% fontSize  = 30;     lineWidth = 3.5;
fontSize  = 18;     lineWidth = 2.7;

%%结果文件或真值文件路径：
filePath  = ['Results' '\' videoName '\'];  

%%视频数据信息：[ 宽 高 帧数 ]
temp      = importdata(['Data\' videoName '\' 'datainfo.txt' ]);
imageSize = [ temp(2) temp(1) ];
frameNum  = temp(3);

%%Load Results:
for num = 1:length(algorithm)
    load([ filePath '\' videoName '_' algorithm{num} '_' 'rs.mat' ]);
end

figure('position',[ 100 100 imageSize(2) imageSize(1) ]); 
set(gcf,'DoubleBuffer','on','MenuBar','none');
for num = 1:frameNum
    framePath = [ 'Data\' videoName '\'  int2str(num) '.jpg'];
    imageRGB  = imread(framePath);
    axes('position', [0 0 1.0 1.0]);
    imagesc(imageRGB, [0,1]); 
    hold on; 

    numStr = sprintf('#%04d', num);
    text(10,20,numStr,'Color', 'r', 'FontWeight', 'bold', 'FontSize', fontSize);

    corner = pcaCornersAll{1,num};
    line(corner(1,:), corner(2,:), 'Color', 'b', 'LineWidth', lineWidth); 
    corner = l1CornersAll{1,num};
    line(corner(1,:), corner(2,:), 'Color', 'g', 'LineWidth', lineWidth);
    corner = pnCornersAll{1,num};
    line(corner(1,:), corner(2,:), 'Color', 'k', 'LineWidth', lineWidth); 
    corner = vtdCornersAll{1,num};
    line(corner(1,:), corner(2,:), 'Color', 'y', 'LineWidth', lineWidth); 
    corner = milCornersAll{1,num};
    line(corner(1,:), corner(2,:), 'Color', 'm', 'LineWidth', lineWidth);
    corner = fragCornersAll{1,num};
    line(corner(1,:), corner(2,:), 'Color', 'c', 'LineWidth', lineWidth);   
    corner = srpcaCornersAll{1,num};
    line(corner(1,:), corner(2,:), 'Color', 'r', 'LineWidth', lineWidth);    
 

    axis off;
    hold off;
    drawnow;
    savePath = sprintf('Dump/%s_%s_%04d.jpg', videoName, 'rs', num);
    imwrite(frame2im(getframe(gcf)),savePath);
    clf;
end