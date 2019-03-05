function winning(chances,totalchips,sum,data)
%WINNING Summary of this function goes here
%   Detailed explanation goes here

[maxchance,i]= max(chances);
k=1;
if maxchance>=98
   chickendinner= sprintf('Player %d Wins!', i);
   set(data.orders,'string', chickendinner);
   tts(chickendinner);
   tts('good game'); 
   totalchips(1,i) = totalchips(1,i) + sum;
   setchipfunc(i,totalchips,data);
end
if maxchance==50
    for j=1:4
        if chances(1,j)==50
           b(k)=j;
           k=k+1;            
        end
    end
   chickendinner= sprintf('Players %d  and %d Split the pot!',b(1),b(2));
   set(data.orders,'string', chickendinner);
   tts(chickendinner);
   tts('good game'); 
   totalchips(1,b(1)) = totalchips(1,b(1)) + sum\2;
   setchipfunc(b(1),totalchips,data);
   totalchips(1,b(2)) = totalchips(1,b(2)) + sum\2;
   setchipfunc(b(2),totalchips,data);
end

if maxchance>=33 && maxchance<=34
    for j=1:4
        if chances(1,j)==50
           b(k)=j;
           k=k+1;            
        end
    end
   chickendinner= sprintf('Players %d , %d and %d Split the pot!',b(1),b(2),b(3));
   set(data.orders,'string', chickendinner);
   tts(chickendinner);
   tts('good game');   
   totalchips(1,b(1)) = totalchips(1,b(1)) + sum\3;
   setchipfunc(b(1),totalchips,data);
   totalchips(1,b(2)) = totalchips(1,b(2)) + sum\3;
   setchipfunc(b(2),totalchips,data);
   totalchips(1,b(3)) = totalchips(1,b(3)) + sum\3;
   setchipfunc(b(3),totalchips,data);
end

if maxchance==25
   chickendinner= sprintf('All Players Split the pot!');
   set(data.orders,'string', chickendinner);
   tts(chickendinner);
   tts('good game');   
   totalchips(1,b(1)) = totalchips(1,b(1)) + sum\4;
   setchipfunc(b(1),totalchips,data);
   totalchips(1,b(2)) = totalchips(1,b(2)) + sum\4;
   setchipfunc(b(2),totalchips,data);
   totalchips(1,b(3)) = totalchips(1,b(3)) + sum\4;
   setchipfunc(b(3),totalchips,data);
   totalchips(1,b(3)) = totalchips(1,b(4)) + sum\4;
   setchipfunc(b(3),totalchips,data);
end

end
