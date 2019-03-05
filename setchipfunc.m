function  setchipfunc(playerturn,totalchips,data)
    switch playerturn
        case 1   
        set(data.chip1,'string', totalchips(1,playerturn));
         case 2
        set(data.chip2,'string', totalchips(1,playerturn));
         case 3
        set(data.chip3,'string', totalchips(1,playerturn));
         case 4
        set(data.chip4,'string', totalchips(1,playerturn));
    end
end

