function ishandonboard = handonboard(playerturn,boardborder,vid)

temp=0;
WIDTH=1280;
HEIGHT=720;
ref_board_X = [1;1;375;375];
ref_board_Y = [1;250;250;1];

for counter=1:2
    real_table = snapshot(vid);
    for i = 1:5
        thisBB = boardborder(i,:);
        if thisBB(3)<2*thisBB(4)
            if (boardborder(i,2)<HEIGHT/2)
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
    
    
    switch playerturn
        case 1
            temp= hand_detect(board1)+temp;
        case 2
            temp= hand_detect(board2)+temp;
        case 3
            temp= hand_detect(board3)+temp;
        case 4
            temp= hand_detect(board4)+temp;
    end
    if temp==0
        ishandonboard=0;
        return;
    end
    pause(1);
    
end
if temp==2
    ishandonboard=1;
else
    ishandonboard=0;
end
end





