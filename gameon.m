clc;
clear all;
close all;
vid = webcam(2);
vid.Resolution = '1280x720';

vid.Contrast=10;
vid.Brightness=160;
vid.Saturation=60;
vid.Sharpness=25;
vid.WhiteBalance=3000

% vid.Contrast=5;
% vid.Brightness=143;
% vid.Saturation=83;
% vid.Sharpness=25;
% vid.WhiteBalance=2800

pause(1);
%preview(vid);


real_table = snapshot(vid);


imwrite(real_table,'hand.png');
figure()
imshow(real_table);


chip_initial = 33;
totalchips = [chip_initial,chip_initial,chip_initial,chip_initial];
data = guidata(blindpokergui);
set(data.chip1,'string', chip_initial);
set(data.chip2,'string', chip_initial);
set(data.chip3,'string', chip_initial);
set(data.chip4,'string', chip_initial);

real_table = snapshot(vid);
temp_board=zeros(5,4);
[boardborder,cards] = board_detect(real_table,1,temp_board,0);
dealer_flag = 0;
[dealer,sum] = Chips_detect(real_table,boardborder);
dealer_pos = dealer;

     
while(1)
    [boardborder,cards] = board_detect(real_table,1, temp_board,0);
    endturn=0;
    wrongcallflag=0;
    flag=0;
    playerbet=[0,0,0,0];
    newchips=0;
    formersum=0;
    fold=[0,0,0,0];
    stage=0;
    turnnum=0;
    call=0;
    set(data.player1card1 , 'Cdata' , []);
    set(data.player1card2 , 'Cdata' , []);
    set(data.player2card1 , 'Cdata' , []);
    set(data.player2card2 , 'Cdata' , []);
    set(data.player3card1 , 'Cdata' , []);
    set(data.player3card2 , 'Cdata' , []);
    set(data.player4card1 , 'Cdata' , []);
    set(data.player4card2 , 'Cdata' , []);
    set(data.flop1 , 'Cdata' , []);
    set(data.flop2 , 'Cdata' , []);
    set(data.flop3 , 'Cdata' , []);
    set(data.flop4 , 'Cdata' , []);
    set(data.flop5 , 'Cdata' , []);
    set(data.orders,'string', 'new game');
    set(data.chance1,'string', 0);
    set(data.chance2,'string', 0);
    set(data.chance3,'string', 0);
    set(data.chance4,'string', 0);
    set(data.player1back,'visible', 'off');
    set(data.player2back,'visible', 'off');
    set(data.player3back,'visible', 'off');
    set(data.player4back,'visible', 'off');
        real_table = snapshot(vid); 

        
        if dealer_flag == 1
            dealer_pos = nextplayer(dealer_pos,fold,0,data);
            pause(20);
        end
        dealer_flag = 1;
        
        playerturn = nextplayer(dealer_pos,fold,1,data); 
        voice_flag=1;
        while(flag == 0)
            real_table = snapshot(vid);
            [B,cards] = board_detect(real_table,0,boardborder,0); % only the players
            pause(3);
            if voice_flag
                voice_flag=0;
                tts('waiting for new cards');
            end
            player1card1= cards(2,1); 
            player1card2= cards(2,2); 
            player2card1= cards(1,1); 
            player2card2= cards(1,2); 
            player3card1= cards(3,1); 
            player3card2= cards(3,2); 
            player4card1= cards(4,1); 
            player4card2= cards(4,2);  
            
            if player1card1 ~= 0 && player1card2~= 0 && player2card1~= 0  && player2card2~= 0 && player3card1~= 0 && player3card2~= 0  && player4card1~= 0 && player4card2~= 0 
                flag=1;
            end
        end
       
        
        flag=0;
        set(data. player1card1, 'Enable', 'on');
        set(data. player1card2, 'Enable', 'on');
        
        set(data. player2card1, 'Enable', 'on');
        set(data. player2card2, 'Enable', 'on');

        set(data. player3card1, 'Enable', 'on');
        set(data. player3card2, 'Enable', 'on');

        set(data. player4card1, 'Enable', 'on');
        set(data. player4card2, 'Enable', 'on');

        Hand     = [player1card1 , player2card1, player3card1, player4card1; ... 
                    player1card2 , player2card2, player3card2, player4card2];
        Table    = [];
        nPlayers = 4;
        nIter    = 8000;
        chances= CardAnalyze(Hand,Table,nPlayers,nIter) * 100 ;
        chances=round(chances);
        for i=1:4
            playerchance(i,chances(i,1),data);
        end
        
        filename=sprintf('%0.1f.jpeg', player1card1);
        set(data.player1card1, 'cdata', imresize(imread(filename), [110 76]));
        filename=sprintf('%0.1f.jpeg', player1card2);
        set(data.player1card2, 'cdata', imresize(imread(filename), [110 76]));
        filename=sprintf('%0.1f.jpeg', player2card1);
        set(data.player2card1, 'cdata', imresize(imread(filename), [110 76]));
        filename=sprintf('%0.1f.jpeg', player2card2);
        set(data.player2card2, 'cdata', imresize(imread(filename), [110 76]));
        filename=sprintf('%0.1f.jpeg', player3card1);
        set(data.player3card1, 'cdata', imresize(imread(filename), [110 76]));
        filename=sprintf('%0.1f.jpeg', player3card2);
        set(data.player3card2, 'cdata', imresize(imread(filename), [110 76]));
        filename=sprintf('%0.1f.jpeg', player4card1);
        set(data.player4card1, 'cdata', imresize(imread(filename), [110 76]));
        filename=sprintf('%0.1f.jpeg', player4card2);
        set(data.player4card2, 'cdata', imresize(imread(filename), [110 76]));
        
    
    %    START BETTING!! BEFORE FLOP Player 2 starts:
        stage=1;
        
        
        
        
        while (playerturn)
           real_table = snapshot(vid);
           pause(1);
           call=0;

            % check if hand is on the board:
            if handonboard(playerturn,boardborder,vid)
                while(1)
                    real_table = snapshot(vid);
                    [dealer,sum]=Chips_detect(real_table,boardborder);
                    if sum >= formersum
                        break;
                    end
                end
                
                %% wrong small blind

                if sum~=1 && formersum==0
                    shortmessage= sprintf('Please bet a small blind');
                    set(data.orders,'string', shortmessage);
                    tts(shortmessage);
                    endturn=0;
                    count_check=0;
                    continue;
                end

                %% wrong big blind

                if sum~=3 && formersum==1
                    shortmessage= sprintf('Please bet a big blind');
                    set(data.orders,'string', shortmessage);
                    tts(shortmessage);
                    endturn=0;
                    count_check=0;
                    continue;
                    
                end

                %% set up values

                newchips=sum-formersum;
                playerbet(1,playerturn)=playerbet(1,playerturn)+newchips;
                totalchips(1,playerturn)=  totalchips(1,playerturn)- newchips;
                setchipfunc(playerturn,totalchips,data); 
                
                
                %% small blind

                if sum==1 
                    shortmessage= sprintf('Player %.01d bet a small blind', playerturn);
                    set(data.orders,'string', shortmessage);
                    tts(shortmessage);
                    smallblind=playerturn;
                    playerturn=nextplayer(playerturn,fold,1,data);
                    turnnum=turnnum+1;
                    formersum=1;
                    highestbet=1;
                    endturn=0;
                    count_check=0;
                    continue;
                end

                %% big blind

                if sum==3 && formersum==1 
                    shortmessage= sprintf('Player %.01d bet a big blind', playerturn);
                    set(data.orders,'string', shortmessage);
                    tts(shortmessage);
                    bigblind=playerturn;
                    playerturn=nextplayer(playerturn,fold,1,data);
                    formersum=3;
                    highestbet=2;
                    turnnum=turnnum+1;
                    endturn=0;
                    count_check=0;
                    continue;
                end

                %% wrong call

                if playerbet(1,playerturn) < highestbet && newchips>0
                       short=highestbet - playerbet(1,playerturn);
                       shortmessage= sprintf('need to add %d more', short);
                       set(data.orders,'string', shortmessage);
                       tts(shortmessage);
                       wrongcallflag=1;
                       endturn=0;
                       count_check=0;
                end

                %% good call

                if  playerbet(1,playerturn) == highestbet && newchips~=0
                    if ~(turnnum == 5 && highestbet == 2) %for the check from bigblind
                        callmessage= sprintf('Player %d called', playerturn);
                        set(data.orders,'string', callmessage);
                        tts(callmessage);
                        endturn=1; 
                        wrongcallflag=0;
                        call = collectivecall(playerbet,fold);
                        count_check=0;
                    end
                end

                %% raise

                if  playerbet(1,playerturn) > highestbet
                    raise= playerbet(1,playerturn) - highestbet;
                    raisemessage= sprintf('Player %d raised by %d', playerturn, raise);
                    set(data.orders,'string', raisemessage);
                    tts(raisemessage);
                    endturn=1;
                    wrongcallflag=0;
                    count_check=0;
                end

                %% fold

                if newchips==0 && wrongcallflag==0 && highestbet~=playerbet(1,playerturn)
                    fold(1,playerturn)=1;
                    foldmessage = sprintf('Player %d folds',playerturn);
                    set(data.orders,'string', foldmessage);
                    tts(foldmessage);
                    playercardoff(playerturn,data);
                    call = collectivecall(playerbet,fold);
                    
                    Hand=playerhand(fold,cards);
                    nPlayers=nPlayers-1;
                    chances= CardAnalyze(Hand,Table,nPlayers,nIter) * 100;
                    chances=round(chances);
                    updatechancesgui(fold,data,chances);
                    endturn=1;
                end
                
                
                sum_fold=fold(1,1)+fold(1,2)+fold(1,3)+fold(1,4);
                %% check
                if newchips == 0 && wrongcallflag==0 && highestbet==playerbet(1,playerturn)
                    checkmessage= sprintf('Player %d checks', playerturn);
                    set(data.orders,'string', checkmessage);
                    tts(checkmessage);
                    endturn=1; 
                    wrongcallflag=0;
                    count_check= count_check+1;
                    if count_check== 4- sum_fold || turnnum==5
                        call=1;    
                    end
                    
                end
                
                formersum=sum;
                highestbet=max(playerbet);
                
                

                %% all players folded 
                    
                if  sum_fold==3
                    playerturn=0;
                    [~,idx] = min(fold);
                    chickendinner= sprintf('Player %d Wins!', idx);
                    set(data.orders,'string', chickendinner);
                    tts(chickendinner);
                    tts('good game'); 
                    totalchips(1,idx) = totalchips(1,idx) + sum;
                    setchipfunc(idx,totalchips,data);
                    count_check=0;
                    continue;
                end

               % nPlayers = 4 - sum_fold;

                %% end of stage?
                %turnnum~=4 for big blind option
                if call && stage<=3 && turnnum~=4  
                    count_check=0;
                    stage= stage+1;
                    
                    
% -----------------------wait for flop:------------------------------------
% -------------------------------------------------------------------------
                   if stage == 2
                       tts('Please open Flop');
                        while(flag == 0)   
                           real_table = snapshot(vid);
                           [B,cards_flop] = board_detect(real_table,0,boardborder,2);
                           tablecard1= cards_flop(5,1); 
                           tablecard2= cards_flop(5,2);
                           tablecard3= cards_flop(5,3); 
                            if  tablecard1~= 0 && tablecard2~= 0 && tablecard3~= 0  
                               flag=1;
                            end
                            pause(3);
                        end  
                        Table    = [tablecard1 , tablecard2 , tablecard3];
                        chances= CardAnalyze(Hand,Table,nPlayers,nIter) * 100;
                        chances=round(chances);
                        updatechancesgui(fold,data,chances);
                        filename=sprintf('%0.1f.jpeg', tablecard2);
                        set(data.flop1, 'cdata', imresize(imread(filename), [110 76]));
                        filename=sprintf('%0.1f.jpeg', tablecard1);
                        set(data.flop2, 'cdata', imresize(imread(filename), [110 76]));
                        filename=sprintf('%0.1f.jpeg', tablecard3);
                        set(data.flop3, 'cdata', imresize(imread(filename), [110 76]));
                        
                        flag=0;
                        call=0;
                   end
% -----------------------wait for turn:------------------------------------
% -------------------------------------------------------------------------
                   if stage == 3
                       tts('Please open Turn');
                        while(flag == 0)
                           real_table =snapshot(vid);
                           [ B,cards_turn] = board_detect(real_table,0,boardborder,3);
                           tablecard4= cards_turn(6,1); 
                            if  tablecard4~= 0
                               flag=1;
                            end
                            pause(3);
                        end
                        Table    = [tablecard1 , tablecard2 , tablecard3 , tablecard4];
                        chances= CardAnalyze(Hand,Table,nPlayers,nIter) * 100;
                        chances=round(chances);
                        updatechancesgui(fold,data,chances);
                        filename=sprintf('%0.1f.jpeg', tablecard4);
                        set(data.flop4, 'cdata', imresize(imread(filename), [110 76]));
                        flag=0;
                        call=0;
                   end

% -----------------------wait fo river:------------------------------------
% -------------------------------------------------------------------------
                   if stage == 4
                       tts('Please open River');
                        while(flag == 0)
                           real_table = snapshot(vid);
                           [ B,cards_river] = board_detect(real_table,0,boardborder,4);
                           tablecard5= cards_river(7,1); 
                            if  tablecard5~= 0
                               flag=1;
                            end
                            pause(3);
                        end
                        Table    = [tablecard1 , tablecard2 , tablecard3 , tablecard4 , tablecard5];
                        chances= CardAnalyze(Hand,Table,nPlayers,nIter) * 100;
                        chances=round(chances);
                        updatechancesgui(fold,data,chances);
                        filename=sprintf('%0.1f.jpeg', tablecard5);
                        set(data.flop5, 'cdata', imresize(imread(filename), [110 76]));
                        flag=0;
                   end
                   for i = 1:4
                        playerbackground(i,data,0);
                   end 
                   playerturn=nextplayer(dealer_pos,fold,1,data); 
                   call=0;
                   turnnum=turnnum+1;
%------------------------ShowDown:-----------------------------------------
%--------------------------------------------------------------------------
                elseif call  && stage==4 
                    
                   stage= 0;
                   playerturn=0;
                   winning(chances,totalchips,sum,data) % need to check player with highest chance

                   
%------------------------nextplayer:---------------------------------------
%--------------------------------------------------------------------------                  
                elseif endturn==1
                    turnnum=turnnum+1;
                    playerturn=nextplayer(playerturn,fold,1,data);
                end
            end
        end

end



