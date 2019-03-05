%set(handles.staticText1, 'String', num2str(value));
data = guidata(blindpokergui);
Hand     = [0 , 2.3, 11.4, 9.3; 0, 10.1, 13.1, 10.2];
Table    = [2.1, 5.4, 4.2];
nPlayers = 4;
nIter    = 8000;
win= CardAnalyze(Hand,Table,nPlayers,nIter);

%set(data.pushbutton1, 'String', num2str(value));
%set(data.axes1, 'String', num2str(value));

I = imread('QC.jpeg');
I2=imresize(I, [110 76]);
I = imread('QD.jpeg');
I3=imresize(I, [110 76]);
I = imread('AC.jpeg');
I4=imresize(I, [110 76]);
I = imread('KC.jpeg');
I5=imresize(I, [110 76]);
I = imread('JC.jpeg');
I6=imresize(I, [110 76]);
I = imread('10C.jpeg');
I7=imresize(I, [110 76]);


set(data.player1back,'visible', 'off');
set(data.player2back,'visible', 'off');
set(data.player3back,'visible', 'off');
set(data.player4back,'visible', 'off');
%imshow(I2)

set(data. player1card1, 'cdata', I2);
pause(1);
set(data. player1card2, 'cdata', I4);
pause(1);
set(data.player1back,'visible', 'on');
pause(1);
set(data. flop1, 'cdata', I3);
pause(1);
set(data. flop2, 'cdata', I5);
pause(1);
set(data. flop3, 'cdata', I6);
pause(1);
set(data. flop4, 'cdata', I7);




