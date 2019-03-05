function [nextturn] = nextplayer(playerturn,fold,sound,data)
    while (1)
        if playerturn>=4
            nextturn=1;
        else
            nextturn=playerturn+1;
        end
        if (~fold(1,nextturn))
            break;
        else
            if playerturn < 4
                playerturn=playerturn+1;
            else
               playerturn = 1;
            end
        end
    end
    for i=1:4
        playerbackground(i,data,0);
    end
        if sound
            playermessage= sprintf('it is players %d Turn', nextturn);
            tts(playermessage);
            playerbackground(nextturn,data,1);
        end 
end



