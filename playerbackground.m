function  playerbackground(playerturn,data,mode)
    switch playerturn
        case 1   
            if mode
                set(data.player1back,'visible', 'on');
            else
                set(data.player1back,'visible', 'off');
            end
        case 2
            if mode
                set(data.player2back,'visible', 'on');
            else
                set(data.player2back,'visible', 'off');
            end
        case 3
            if mode
                set(data.player3back,'visible', 'on');
            else
                set(data.player3back,'visible', 'off');
            end
        case 4
            if mode
                set(data.player4back,'visible', 'on');
            else
                set(data.player4back,'visible', 'off');
            end
    end
end


