function  playercardoff(playerturn,data)
    switch playerturn
        case 1   
        set(data. player1card1, 'Enable', 'off');
        set(data. player1card2, 'Enable', 'off');
        set(data.chance1,'string', "0");
         case 2
        set(data. player2card1, 'Enable', 'off');
        set(data. player2card2, 'Enable', 'off');
        set(data.chance2,'string', "0");
         case 3
        set(data. player3card1, 'Enable', 'off');
        set(data. player3card2, 'Enable', 'off');
         set(data.chance3,'string', "0");
         case 4
        set(data. player4card1, 'Enable', 'off');
        set(data. player4card2, 'Enable', 'off');
        set(data.chance4,'string', "0");
    end
end
  
