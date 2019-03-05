function  playerchance(playerturn,chance, data)
    shortmessage= sprintf(' %d%%', chance);
    switch playerturn
        case 1 
        set(data.chance1,'string', shortmessage);
        case 2
        set(data.chance2,'string', shortmessage);
        case 3
        set(data.chance3,'string', shortmessage);
        case 4
        set(data.chance4,'string', shortmessage);
    end
end

