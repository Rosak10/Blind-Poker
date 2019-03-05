function  [boardborder,cards,board1,board2,board3,board4]= board_detect( real_table,initial_detect,boardborder,feature_to_find )
%BOARDS_DETECT Summary of this function goes here
%   Detailed explanation goes here

gray_table = double(rgb2gray(real_table));
gray_table = (gray_table-min(gray_table(:)))/(max(gray_table(:))-min(gray_table(:)));
WIDTH=1280;
HEIGHT=720;
ref_board_X = [1;1;375;375];
ref_board_Y = [1;250;250;1];
ref_flop_X = [1;1;425;425];
ref_flop_Y = [1;150;150;1];
ref_card_X = [1;1;600;600];
ref_card_Y = [1;400;400;1];
cards = zeros(7,3);
debug = 0;

I = rgb2hsv(real_table);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.133;
channel1Max = 0.217;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.403;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.300;
channel3Max = 1.000;
% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW1 = sliderBW;
BW=bwareafilt(BW1,5);
BW2= medfilt2(BW,[9 9]);
if debug == 1
    figure()
    imshow(BW)
end
%BW=bwareafilt(BW,5);
%{
    figure()
    imshow(BW);
%}

stats = regionprops(BW,'BoundingBox');
if debug == 1
    figure();
    imshow(gray_table);
    hold on
end
j=1;
for k = 1 : length(stats)
    thisBB = stats(k).BoundingBox;
    thisBB= round(thisBB);
    if( thisBB(3)>100 && thisBB(4)>100 )
        boardborder(j,:)=thisBB;
        j=j+1;
        if debug == 1
            rectangle('Position', thisBB, 'EdgeColor','r','LineWidth',2 );
        end
        if (thisBB(3)<2*thisBB(4) && feature_to_find==1)
            if (thisBB(2)<HEIGHT/2)
                boardX = [thisBB(1);thisBB(1);thisBB(1)+thisBB(3);thisBB(1)+thisBB(3)];
                boardY = [thisBB(2);thisBB(2)+thisBB(4);thisBB(2)+thisBB(4);thisBB(2)];
            else
                boardX = [thisBB(1)+thisBB(3);thisBB(1)+thisBB(3);thisBB(1);thisBB(1)];
                boardY = [thisBB(2)+thisBB(4);thisBB(2);thisBB(2);thisBB(2)+thisBB(4)];
            end
            
            t = fitgeotrans([boardX boardY],[ref_board_X ref_board_Y],'similarity');
            straightened = imwarp(real_table,t,'OutputView',imref2d([250,375]));
            
            if( thisBB(1)<WIDTH/2 && thisBB(2)<HEIGHT/2)
                board1=straightened;
                %                       figure()
                %                       imshow(board1)
            end
            if( thisBB(1)>WIDTH/2 && thisBB(2)<HEIGHT/2)
                board4=straightened;
                %                       figure()
                %                       imshow(board2)
            end
            if( thisBB(1)>WIDTH/2 && thisBB(2)>HEIGHT/2)
                board3=straightened;
                %                       figure()
                %                       imshow(board3)
            end
            if( thisBB(1)<WIDTH/2 && thisBB(2)>HEIGHT/2)
                board2=straightened;
                %                       figure()
                %                       imshow(board4)
            end
        end
    end
end

%----------------------------flop-----------------------------------------
if feature_to_find == 2
    i0 = boardborder(3,1)+21;
    j0 = boardborder(3,2)+20;
    w=66;
    h=94;
    %w =  boardborder(3,3);
    %h =  boardborder(3,4);
    flop1(:,:,1) = real_table((j0):(j0+h),(i0):(i0+w),1);
    flop1(:,:,2) = real_table((j0):(j0+h),(i0):(i0+w),2);
    flop1(:,:,3) = real_table((j0):(j0+h),(i0):(i0+w),3);
    if debug == 1
        figure()
        imshow(flop1);
    end
    cards(5,2) = card_detect(flop1);
    
    i0 = boardborder(3,1)+87;
    flop2(:,:,1) = real_table((j0):(j0+h),(i0):(i0+w),1);
    flop2(:,:,2) = real_table((j0):(j0+h),(i0):(i0+w),2);
    flop2(:,:,3) = real_table((j0):(j0+h),(i0):(i0+w),3);
    if debug == 1
        figure()
        imshow(flop2);
    end
    cards(5,1) = card_detect(flop2);
    
    i0 = boardborder(3,1)+155;
    flop3(:,:,1) = real_table((j0):(j0+h),(i0):(i0+w),1);
    flop3(:,:,2) = real_table((j0):(j0+h),(i0):(i0+w),2);
    flop3(:,:,3) = real_table((j0):(j0+h),(i0):(i0+w),3);
    if debug == 1
        figure()
        imshow(flop3);
    end
    cards(5,3) = card_detect(flop3);
end
if feature_to_find == 3
    i0 = boardborder(3,1)+221;
    j0 = boardborder(3,2)+20;
    w=66;
    h=94;
    turn(:,:,1) = real_table((j0):(j0+h),(i0):(i0+w),1);
    turn(:,:,2) = real_table((j0):(j0+h),(i0):(i0+w),2);
    turn(:,:,3) = real_table((j0):(j0+h),(i0):(i0+w),3);
    if debug == 1
        figure()
        imshow(turn)
    end
    cards(6,1) = card_detect(turn);
end

if feature_to_find == 4
    i0 = boardborder(3,1)+287;
    j0 = boardborder(3,2)+20;
    w=66;
    h=94;
    river(:,:,1) = real_table((j0):(j0+h-1),(i0):(i0+w),1);
    river(:,:,2) = real_table((j0):(j0+h-1),(i0):(i0+w),2);
    river(:,:,3) = real_table((j0):(j0+h-1),(i0):(i0+w),3);
    if debug == 1
        figure()
        imshow(river)
    end
    cards(7,1) = card_detect(river);
end
%------------------------------------------------------------------------------------------------
% Gflop1_cropped = imcrop(Gflop1, [0 0 0.3*size(flop1,2) 0.5*size(flop1,1)]);
% figure()
% imshow(Gflop1_cropped)
%----------------------------------------------------------------------------------------------------
%-----------------------------board 1-------------------------------------
if feature_to_find == 0
    i0 = boardborder(1,1);
    j0 = boardborder(1,2);
    w =  boardborder(1,3);
    h =  boardborder(1,4);
    board_1(:,:,1) = real_table((j0):(j0+h-1),(i0):(i0+w),1);
    board_1(:,:,2) = real_table((j0):(j0+h-1),(i0):(i0+w),2);
    board_1(:,:,3) = real_table((j0):(j0+h-1),(i0):(i0+w),3);
    board_1 = imrotate(board_1,180);
    if debug == 1
        figure()
        imshow(board_1)
    end
    
    %-----------------------------board 4-------------------------------------
    i0 = boardborder(2,1);
    j0 = boardborder(2,2);
    w =  boardborder(2,3);
    h =  boardborder(2,4);
    board_4(:,:,1) = real_table((j0):(j0+h-1),(i0):(i0+w),1);
    board_4(:,:,2) = real_table((j0):(j0+h-1),(i0):(i0+w),2);
    board_4(:,:,3) = real_table((j0):(j0+h-1),(i0):(i0+w),3);
    %board_4 = imrotate(board_4,180);
    if debug == 1
        figure()
        imshow(board_4)
    end
    
    %-----------------------------board 2-------------------------------------
    i0 = boardborder(4,1);
    j0 = boardborder(4,2);
    w =  boardborder(4,3);
    h =  boardborder(4,4);
    board_2(:,:,1) = real_table((j0):(j0+h-1),(i0):(i0+w),1);
    board_2(:,:,2) = real_table((j0):(j0+h-1),(i0):(i0+w),2);
    board_2(:,:,3) = real_table((j0):(j0+h-1),(i0):(i0+w),3);
    if debug == 1
        figure()
        imshow(board_2)
    end
    
    %-----------------------------board 3-------------------------------------
    i0 = boardborder(5,1);
    j0 = boardborder(5,2);
    w =  boardborder(5,3);
    h =  boardborder(5,4);
    board_3(:,:,1) = real_table((j0):(j0+h-1),(i0):(i0+w),1);
    board_3(:,:,2) = real_table((j0):(j0+h-1),(i0):(i0+w),2);
    board_3(:,:,3) = real_table((j0):(j0+h-1),(i0):(i0+w),3);
    board_3 = imrotate(board_3,180);
    if debug == 1
        figure()
        imshow(board_3)
    end
    
    %------------------------player 1 cards detection-------------------------
    %-------------------------------------------------------------------------
    I = rgb2hsv(board_1);
    
    sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
        (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
        (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
    BW = sliderBW;
    BW=bwareafilt(BW,1);
    BW= medfilt2(BW,[9 9]);
    BW = edge(BW,'Canny');
    if debug == 1
        figure()
        imshow(BW)
        hold on
    end
    stats = regionprops(BW,'BoundingBox');
    for k = 1 : length(stats)
        thisBB = stats(k).BoundingBox;
        thisBB= round(thisBB);
        if debug == 1
            rectangle('Position', thisBB, 'EdgeColor','r','LineWidth',2 );
        end
        if (thisBB(1)<40 && thisBB(2)>60 && thisBB(2)<150 && thisBB(3)>100 && thisBB(4)>80)
            i0 = thisBB(1)+8;
            j0 = thisBB(2)+3;
            w =  (thisBB(3)-17)/2;
            h =  thisBB(4)-4;
            cards_11(:,:,1) = board_1((j0):(j0+h),(i0):(i0+w),1);
            cards_11(:,:,2) = board_1((j0):(j0+h),(i0):(i0+w),2);
            cards_11(:,:,3) = board_1((j0):(j0+h),(i0):(i0+w),3);
            if debug == 1
                figure()
                imshow(cards_11);
            end
            
            i0 = thisBB(1)+10+w;
            cards_12(:,:,1) = board_1((j0):(j0+h),(i0):(i0+w),1);
            cards_12(:,:,2) = board_1((j0):(j0+h),(i0):(i0+w),2);
            cards_12(:,:,3) = board_1((j0):(j0+h),(i0):(i0+w),3);
            if debug == 1
                figure()
                imshow(cards_12);
            end
        end
    end
    cards(1,1) = card_detect(cards_11);
    cards(1,2) = card_detect(cards_12);
    
    %------------------------player 4 cards detection-------------------------
    %-------------------------------------------------------------------------
    I = rgb2hsv(board_2);
    
    sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
        (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
        (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
    BW = sliderBW;
    BW=bwareafilt(BW,1);
    BW= medfilt2(BW,[9 9]);
    BW = edge(BW,'Canny');
    if debug == 1
        figure()
        imshow(BW)
    end
    
    stats = regionprops(BW,'BoundingBox');
    for k = 1 : length(stats)
        thisBB = stats(k).BoundingBox;
        thisBB= round(thisBB);
        if debug == 1
            rectangle('Position', thisBB, 'EdgeColor','r','LineWidth',2 );
        end
        if (thisBB(1)<40 && thisBB(2)>60 && thisBB(2)<150 && thisBB(3)>100 && thisBB(4)>80)
            i0 = thisBB(1)+3;
            j0 = thisBB(2);
            w =  (thisBB(3)-18)/2 + 4;
            h =  thisBB(4)-4;
            cards_21(:,:,1) = board_2((j0):(j0+h),(i0):(i0+w),1);
            cards_21(:,:,2) = board_2((j0):(j0+h),(i0):(i0+w),2);
            cards_21(:,:,3) = board_2((j0):(j0+h),(i0):(i0+w),3);
            if debug == 1
                figure()
                imshow(cards_21);
            end
            i0 = thisBB(1)+5+w;
            cards_22(:,:,1) = board_2((j0):(j0+h),(i0):(i0+w),1);
            cards_22(:,:,2) = board_2((j0):(j0+h),(i0):(i0+w),2);
            cards_22(:,:,3) = board_2((j0):(j0+h),(i0):(i0+w),3);
            if debug == 1
                figure()
                imshow(cards_22);
            end
        end
    end
    cards(4,1) = card_detect(cards_21);%הח�?פה בי�? 2 �? 4
    cards(4,2) = card_detect(cards_22);
    %------------------------player 3 cards detection-------------------------
    %-------------------------------------------------------------------------
    I = rgb2hsv(board_3);
    
    sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
        (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
        (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
    BW = sliderBW;
    BW=bwareafilt(BW,1);
    BW= medfilt2(BW,[9 9]);
    BW = edge(BW,'Canny');
    if debug == 1
        figure()
        imshow(BW)
    end
    stats = regionprops(BW,'BoundingBox');
    for k = 1 : length(stats)
        thisBB = stats(k).BoundingBox;
        thisBB= round(thisBB);
        if debug == 1
            rectangle('Position', thisBB, 'EdgeColor','r','LineWidth',2 );
        end
        if (thisBB(1)<40 && thisBB(2)>60 && thisBB(2)<130 && thisBB(3)>100 && thisBB(4)>80)
            i0 = thisBB(1)+5;
            j0 = thisBB(2)+4;
            w =  (thisBB(3)-18)/2 + 4;
            h =  thisBB(4)-7;
            cards_31(:,:,1) = board_3((j0):(j0+h),(i0):(i0+w),1);
            cards_31(:,:,2) = board_3((j0):(j0+h),(i0):(i0+w),2);
            cards_31(:,:,3) = board_3((j0):(j0+h),(i0):(i0+w),3);
            if debug == 1
                figure()
                imshow(cards_31);
            end
            i0 = thisBB(1)+5+w;
            cards_32(:,:,1) = board_3((j0):(j0+h),(i0):(i0+w),1);
            cards_32(:,:,2) = board_3((j0):(j0+h),(i0):(i0+w),2);
            cards_32(:,:,3) = board_3((j0):(j0+h),(i0):(i0+w),3);
            if debug == 1
                figure()
                imshow(cards_32);
            end
        end
    end
    cards(3,1) = card_detect(cards_31);
    cards(3,2) = card_detect(cards_32);
    %------------------------player 2 cards detection-------------------------
    %-------------------------------------------------------------------------
    I = rgb2hsv(board_4);
    
    sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
        (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
        (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
    BW = sliderBW;
    BW=bwareafilt(BW,1);
    BW= medfilt2(BW,[9 9]);
    BW = edge(BW,'Canny');
    if debug == 1
        figure()
        imshow(BW)
    end
    stats = regionprops(BW,'BoundingBox');
    for k = 1 : length(stats)
        thisBB = stats(k).BoundingBox;
        thisBB= round(thisBB);
        if debug == 1
            rectangle('Position', thisBB, 'EdgeColor','r','LineWidth',2 );
        end
        if (thisBB(1)<40 && thisBB(2)>80 && thisBB(2)<150 && thisBB(3)>100 && thisBB(4)>80)
            i0 = thisBB(1)+5;
            j0 = thisBB(2)+5;
            w =  (thisBB(3)-20)/2 + 4;
            h =  thisBB(4)-6;
            cards_41(:,:,1) = board_4((j0):(j0+h),(i0):(i0+w),1);
            cards_41(:,:,2) = board_4((j0):(j0+h),(i0):(i0+w),2);
            cards_41(:,:,3) = board_4((j0):(j0+h),(i0):(i0+w),3);
            if debug == 1
                figure()
                imshow(cards_41);
            end
            i0 = thisBB(1)+5+w;
            cards_42(:,:,1) = board_4((j0):(j0+h),(i0):(i0+w),1);
            cards_42(:,:,2) = board_4((j0):(j0+h),(i0):(i0+w),2);
            cards_42(:,:,3) = board_4((j0):(j0+h),(i0):(i0+w),3);
            if debug == 1
                figure()
                imshow(cards_42);
            end
        end
    end
    cards(2,1) = card_detect(cards_41);
    cards(2,2) = card_detect(cards_42);
end
