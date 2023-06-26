program fishing;

uses wincrt, wingraph, sysutils;

const esc=#27; space=#32; enter=#13; tab=#9; up=#72; down=#80; left=#75; right=#77;

var gd,gm,count_main,n,c,i : integer; key : char; //кнопка и "время"
    score : longint; //очки
	bonus1,bonus2,bonus3 : integer; //начисляемые очки
	plus1,plus2,plus3 : integer; //очки прогресса
    press : boolean; //для создания задержки между нажатиями
	anim_mini,anim_hook : animattype; //потом уберется
	
    ////картинки

    //меню
    arrow : animattype; //стрелка
	menuA : pointer; //фон
	helppic : pointer;
	
	//рыбки плавают
	fish_red_r1,fish_red_r2,fish_red_r3 : animattype; //красная рыба вправо
	fish_red_l1,fish_red_l2,fish_red_l3 : animattype; //красная рыба влево
	fish_yellow_r1,fish_yellow_r2 : animattype; //желтая рыба вправо
	fish_yellow_l1,fish_yellow_l2 : animattype; //желтая рыба влево
	fish_green_r1,fish_green_r2 : animattype; //зеленая рыба вправо 
	fish_green_l1,fish_green_l2 : animattype; //зеленая рыба влево
	cross : animattype; //прицел
	worm : animattype; //червяк
	b1,b2,b3,b4 : pointer; //вода
	
	//ловля
	hook,mini,lamp_on,lamp_off : animattype; //крючок, рыбка, лампы
	catchbar1,catchbar2,won : pointer; //анимация ловли и фон
	
	////данные
	
	//меню
	width_ar,height_ar,step_ar,x_ar,y_ar : integer; //стрелка
	
	//рыбки плавают
	width_fish,height_fish : integer;
    step_red : array [1..4] of integer;
	step_yellow : array [1..4] of integer;
	step_green : array [1..4] of integer;
	x_f_red_r1,y_f_red_r1 : integer;
	  x_f_red_l1,y_f_red_l1 : integer;
	x_f_red_r2,y_f_red_r2 : integer;
	  x_f_red_l2,y_f_red_l2 : integer;
	x_f_yellow_r1,y_f_yellow_r1 : integer;
	  x_f_yellow_r2,y_f_yellow_r2 : integer;
	x_f_yellow_l1,y_f_yellow_l1 : integer;
	  x_f_yellow_l2,y_f_yellow_l2 : integer;
	x_f_green_r1,y_f_green_r1 : integer;
	  x_f_green_r2,y_f_green_r2 : integer;
	x_f_green_l1,y_f_green_l1 : integer;
	  x_f_green_l2,y_f_green_l2 : integer;
	//прицел
	width_cross,height_cross,step_cross,x_cross,y_cross : integer;
	//червяк
	worms,worms2,width_worm,height_worm : integer;
	//крючок
	width_hook,height_hook,up_hook,down_hook,x_hook,y_hook : integer;
	//рыбка
	width_mini,height_mini,step_mini1,step_mini2,step_mini3,x_mini,y_mini : integer;
	//лампы
	width_lamp,height_lamp,x_lamp,y_lamp : integer;

//позволяет обратится к процедуре "меню" в любой строке кода
  procedure menu; forward;
//позволяет обратится к процедуре "игра" в любой строке кода
  procedure game; forward;

//загрузка файла
function loader(filename:string):pointer;
  var f:file; size:longint; p:pointer;
    begin
       assign(f,filename);
       if fileexists(filename) then
         begin
            reset(f,1);
            size:=filesize(f);
            getmem(p,size);
            blockread(f,p^,size);
            close(f);
            loader:=p
         end;
    end;

//загрузка изображения
procedure newanim(width,height:integer; filename:string; var anim:animattype; col:longint);
  var p:pointer;
    begin
       p:=loader(filename);
       cleardevice;
       setfillstyle(1,col);
       bar(0,0,getmaxX,getmaxY);
       putimage(0,0,p^,0);
       getanim(0,0,width,height,col,anim);
       freemem(p);
       cleardevice;
    end;

//инициализация изображений	
procedure initpict;
  begin   
     won:=loader('won.bmp');
  
     menuA:=loader('mA.bmp');
		
	 helppic:=loader('help.bmp');
	   
	 b1:=loader('bk1.bmp');
	  b2:=loader('bk2.bmp');
	   b3:=loader('bk3.bmp');
	    b4:=loader('bk4.bmp');
		
	 catchbar1:=loader('cb1.bmp');
	  catchbar2:=loader('cb2.bmp');
	  
	 newanim(width_worm,height_worm,'worm.bmp',worm,white);
	  
	 newanim(width_ar,height_ar,'ar.bmp',arrow,white);
	  
	 newanim(width_fish,height_fish,'rr.bmp',fish_red_r1,white);
	  newanim(width_fish,height_fish,'rr.bmp',fish_red_r2,white);
	 newanim(width_fish,height_fish,'rl.bmp',fish_red_l1,white);
	  newanim(width_fish,height_fish,'rl.bmp',fish_red_l2,white);
	   
	 newanim(width_fish,height_fish,'yr.bmp',fish_yellow_r1,white);
      newanim(width_fish,height_fish,'yr.bmp',fish_yellow_r2,white);
	 newanim(width_fish,height_fish,'yl.bmp',fish_yellow_l1,white);
	  newanim(width_fish,height_fish,'yl.bmp',fish_yellow_l2,white);
	  
	 newanim(width_fish,height_fish,'gr.bmp',fish_green_r1,white);
	  newanim(width_fish,height_fish,'gr.bmp',fish_green_r2,white);
	 newanim(width_fish,height_fish,'gl.bmp',fish_green_l1,white);
	  newanim(width_fish,height_fish,'gl.bmp',fish_green_l2,white);
	 
	 newanim(width_cross,height_cross,'cr.bmp',cross,white);
	 
	 newanim(width_hook,height_hook,'hook.bmp',hook,white);
	 
	 newanim(width_mini,height_mini,'mini.bmp',mini,white);
	 
	 newanim(width_lamp,height_lamp,'lr.bmp',lamp_off,white);
	  newanim(width_lamp,height_lamp,'lg.bmp',lamp_on,white);
  end;

//инициализация данных  
procedure initdata;
  begin
    bonus1:=200; bonus2:=400; bonus3:=600;
	
	
	plus1:=30; plus2:=40; plus3:=50;
 
	 
     width_ar:=70; height_ar:=40; step_ar:=100; x_ar:=getmaxX div 2 -140; y_ar:=400;
	 
	 width_worm:=28; height_worm:=46; worms:=3;
	 
	 width_fish:=32; height_fish:=32; 
	 
     for i:=1 to 4 do step_red[i]:=1+i;
	 for i:=1 to 4 do step_yellow[i]:=2+i;
	 for i:=1 to 4 do step_green[i]:=3+i;
	 
	 x_f_red_r1:= -320 +random(-280+320); y_f_red_r1:=456 +random(424-456); 
	   x_f_red_l1:=(getmaxx +320) +random(280-320); y_f_red_l1:=584 +random(552-584); 
	   
	 x_f_red_r2:= -280 +random(-240+280); y_f_red_r2:=360 +random(328-360);
	   x_f_red_l2:= (getmaxx +280) +random(240-280); y_f_red_l2:=616 +random(584-616); 

     x_f_yellow_r1:= -240 +random(-200+240); y_f_yellow_r1:=296 +random(264-296); 	
       x_f_yellow_l1:= (getmaxx +240) +random(200-240); y_f_yellow_l1:=392 +random(360-392); 

     x_f_yellow_r2:= -200 +random(-160+200); y_f_yellow_r2:=488 +random(456-488);
       x_f_yellow_l2:= (getmaxx +200) +random(160-200); y_f_yellow_l2:=648 +random(616-648); 	

     x_f_green_r1:= -160 +random(-120+160); y_f_green_r1:=424 +random(392-424);   
	   x_f_green_l1:= (getmaxx +160) +random(120-160); y_f_green_l1:=328 +random(296-328);
	   
	 x_f_green_r2:= -120 +random(-80+120); y_f_green_r2:=552 +random(520-552);	 
	   x_f_green_l2:= (getmaxx +120) +random(80-120); y_f_green_l2:=520 +random(488-520);  
	 
	 width_cross:=22; height_cross:=22; step_cross:=10; 
	 x_cross:= getmaxx div 2; y_cross:= getmaxy +20;
	 
	 width_hook:=40; height_hook:=50; up_hook:=20; down_hook:=5;
	 x_hook:=getmaxX div 2 +46; y_hook:=getmaxY div 2;
	 
	 width_mini:=40; height_mini:=28; step_mini1:=6; step_mini2:=8; step_mini3:=10;
	 x_mini:=getmaxX div 2 +46; y_mini:=getmaxY div 2 -70;
	 
	 width_lamp:=35; height_lamp:=36; 
	 x_lamp:=getmaxX div 2 -46; y_lamp:=getmaxY div 2 +60;
	 
	 count_main:=60;
  end;
 
//управление прицелом, с помощью стрелок 
procedure control(var x_cross,y_cross:integer; width_cross,height_cross,step_cross:integer; anim:animattype);
  begin
     putanim(x_cross,y_cross,cross,bkgput);
     if keypressed then key:=readkey;
     if key=#0 then
       begin
          key:=readkey;
          case key of
               up: if (y_cross>0) and (y_cross>getmaxY div 2 -80) then y_cross:=y_cross -step_cross;
               down: if (y_cross<getmaxY -step_cross -height_cross) then y_cross:=y_cross +step_cross;
               right: if (x_cross<getmaxX -width_cross -step_cross) then x_cross:=x_cross +step_cross;
               left: if (x_cross>0 +step_cross) then x_cross:=x_cross -step_cross;
          end;
       end;
     putanim(x_cross,y_cross,cross,transput);
     updategraph(updateon);
  end;
  
////процедуры, которые отвечают за движение рыб  
 
procedure redmove_r1(var x,step:integer; y:integer; anim:animattype);
  begin
     putanim(x,y,anim,bkgput);
	   x:=x +step;
	   if x > getmaxx then x:=0;
	 putanim(x,y,anim,transput);
	 updategraph(updateon);
  end;
  
procedure redmove_r2(var x,step:integer; y:integer; anim:animattype);
  begin
     putanim(x,y,anim,bkgput);
	   x:=x +step;
	   if x > getmaxx then x:=0;
	 putanim(x,y,anim,transput);
	 updategraph(updateon);
  end;
  
procedure redmove_l1(var x,step:integer; y:integer; anim:animattype);
  begin
     putanim(x,y,anim,bkgput);
	   x:=x -step;
	   if x < 0 then x:=getmaxx;
	 putanim(x,y,anim,transput);
	 updategraph(updateon);
  end;
  
procedure redmove_l2(var x,step:integer; y:integer; anim:animattype);
  begin
     putanim(x,y,anim,bkgput);
	   x:=x -step;
	   if x < 0 then x:=getmaxx;
	 putanim(x,y,anim,transput);
	 updategraph(updateon);
  end;
  
procedure yellowmove_r1(var x,step:integer; y:integer; anim:animattype);
  begin
     putanim(x,y,anim,bkgput);
	   x:=x +step;
	   if x > getmaxx then x:=0;
	 putanim(x,y,anim,transput);
	 updategraph(updateon);
  end;
  
procedure yellowmove_r2(var x,step:integer; y:integer; anim:animattype);
  begin
     putanim(x,y,anim,bkgput);
	   x:=x +step;
	   if x > getmaxx then x:=0;
	 putanim(x,y,anim,transput);
	 updategraph(updateon);
  end;
  
procedure yellowmove_l1(var x,step:integer; y:integer; anim:animattype);
  begin
     putanim(x,y,anim,bkgput);
	   x:=x -step;
	   if x < 0 then x:=getmaxx;
	 putanim(x,y,anim,transput);
	 updategraph(updateon);
  end;
  
procedure yellowmove_l2(var x,step:integer; y:integer; anim:animattype);
  begin
     putanim(x,y,anim,bkgput);
	   x:=x -step;
	   if x < 0 then x:=getmaxx;
	 putanim(x,y,anim,transput);
	 updategraph(updateon);
  end;
  
procedure greenmove_r1(var x,step:integer; y:integer; anim:animattype);
  begin
     putanim(x,y,anim,bkgput);
	   x:=x +step;
	   if x > getmaxx then x:=0;
	 putanim(x,y,anim,transput);
	 updategraph(updateon);
  end;
  
procedure greenmove_r2(var x,step:integer; y:integer; anim:animattype);
  begin
     putanim(x,y,anim,bkgput);
	   x:=x +step;
	   if x > getmaxx then x:=0;
	 putanim(x,y,anim,transput);
	 updategraph(updateon);
  end;
  
procedure greenmove_l1(var x,step:integer; y:integer; anim:animattype);
  begin
     putanim(x,y,anim,bkgput);
	   x:=x -step;
	   if x < 0 then x:=getmaxx;
	 putanim(x,y,anim,transput);
	 updategraph(updateon);
  end;
  
procedure greenmove_l2(var x,step:integer; y:integer; anim:animattype);
  begin
     putanim(x,y,anim,bkgput);
	   x:=x -step;
	   if x < 0 then x:=getmaxx;
	 putanim(x,y,anim,transput);
	 updategraph(updateon);
  end;

//объединяет всё движение  
procedure move;
  begin
     redmove_r1(x_f_red_r1,step_red[1],y_f_red_r1,fish_red_r1);
	 redmove_r2(x_f_red_r2,step_red[2],y_f_red_r2,fish_red_r2);
	 redmove_l1(x_f_red_l1,step_red[3],y_f_red_l1,fish_red_l1);
	 redmove_l2(x_f_red_l2,step_red[4],y_f_red_l2,fish_red_l2);
	 yellowmove_r1(x_f_yellow_r1,step_yellow[1],y_f_yellow_r1,fish_yellow_r1);
	 yellowmove_r2(x_f_yellow_r2,step_yellow[2],y_f_yellow_r2,fish_yellow_r2);
	 yellowmove_l1(x_f_yellow_l1,step_yellow[3],y_f_yellow_l1,fish_yellow_l1);
	 yellowmove_l2(x_f_yellow_l2,step_yellow[4],y_f_yellow_l2,fish_yellow_l2);
	 greenmove_r1(x_f_green_r1,step_green[1],y_f_green_r1,fish_green_r1);
	 greenmove_r2(x_f_green_r2,step_green[2],y_f_green_r2,fish_green_r2);
	 greenmove_l1(x_f_green_l1,step_green[3],y_f_green_l1,fish_green_l1);
	 greenmove_l2(x_f_green_l2,step_green[4],y_f_green_l2,fish_green_l2);
  end;

//вода  
procedure background;
  begin
     if (count_main>=60) and (count_main<120) then putimage(0,0,b1^,0);
	 if (count_main>180) and (count_main<240) then putimage(0,0,b2^,0);
	 if (count_main>240) and (count_main<300) then putimage(0,0,b3^,0);
	 if (count_main>360) and (count_main<420) then putimage(0,0,b4^,0);
	 if (count_main>480) and (count_main<540) then putimage(0,0,b3^,0);
	 if (count_main>540) and (count_main<=600) then putimage(0,0,b2^,0);
	 if count_main>600 then count_main:=100;
  end;
  
//анимация для удения  
procedure catchground;
  begin
     delay(20);
     if c<15 then putimage(0,0,catchbar1^,0);
	 if c>15 then putimage(0,0,catchbar2^,0);
	 if c>30 then c:=0;
	 updategraph(updateon);
  end;  
  
//движение "рыбки"  
procedure minimove(var step_mini:integer);
  begin
     if (y_mini<180) or (y_mini>getmaxy -170) then step_mini:= -step_mini;
	 y_mini:=y_mini +step_mini;
	 putanim(x_mini,y_mini,mini,transput);
  end;
 
//падение крючка 
procedure falling;
  begin
     y_hook:=y_hook +down_hook;
     if (y_hook>getmaxy -190) or (y_hook<180) then y_hook:=y_hook -down_hook;
	 if y_hook=getmaxy -190 then y_hook:=getmaxy -270;
     putanim(x_hook,y_hook,hook,transput);
  end;
 
//проверка попадания по крючку 
function check(y_hook,y_mini:integer):boolean;
  begin
     if (y_hook <= y_mini) and (y_mini <= (y_hook + height_hook)) then check:=true
	   else check:=false;
  end;

//поднятие крючка и удение рыбы  
procedure rising(plus:integer);
  begin
     key:=#0;
	 putanim(x_hook,y_hook,hook,bkgput);
     if keypressed then key:=readkey;
     if key=space then if (y_hook>195) and (y_hook<getmaxy -190) then begin y_hook:=y_hook -up_hook; end;
	 if keypressed then press:=false else press:=true; //не позволяет зажимать enter 
	 if (key=enter) and (check(y_hook,y_mini)) and (press=true) then 
	   begin
	     setcolor(red);
	     outtextxy(getmaxx div 2 -58,getmaxy div 2 +5,'H I T'); 
	     n:=n +plus; 
	   end;
     putanim(x_hook,y_hook,hook,transput);
	 key:=#0;
  end;
  
//случай проигрыша  
procedure fail;
  begin
    if n=0 then
	begin
    worms:=worms -1;
       repeat
          cleardevice;
          settextstyle(1,0,5);
		  setcolor(purple);
          outtextXY(getmaxX div 2 -170,getmaxY div 2,'The fish got off the hook');
	      outtextXY(getmaxX div 2 -120,getmaxY div 2 +50,'"esc" to continue');
          key:=readkey;
       until key=esc;
	   game;
	end;
  end;
 
//отображение прогресса, случай победы 
procedure lamps(bonus,w1,w2,w3,w4,w5,w6,w7:integer); 
var s:string;
  begin
     putanim(x_lamp,y_lamp,lamp_off,transput);
     putanim(x_lamp,y_lamp +45,lamp_off,transput);
     putanim(x_lamp,y_lamp +90,lamp_off,transput);
	 if (n>w1)and(n<=w2) then putanim(x_lamp,y_lamp,lamp_on,transput);
         if (n>w3)and(n<=w4) then 
		 begin
		   putanim(x_lamp,y_lamp,lamp_on,transput); 
		   putanim(x_lamp,y_lamp +45,lamp_on,transput); 
		 end;
         if (n>w5)and(n<=w6) then 
		 begin 
		   putanim(x_lamp,y_lamp,lamp_on,transput); 
		   putanim(x_lamp,y_lamp +45,lamp_on,transput);
		   putanim(x_lamp,y_lamp +90,lamp_on,transput); 
		 end;
         if (n>w7) then  
		   begin
		     score:=score +bonus;
			 str(bonus,s);
	         putanim(x_lamp,y_lamp,lamp_on,transput);
			 putanim(x_lamp,y_lamp +45,lamp_on,transput);
             putanim(x_lamp,y_lamp +90,lamp_on,transput);
             repeat
                cleardevice;
				putimage(0,0,won^,1);
                settextstyle(1,0,5);
				setcolor(purple);
                outtextxy(getmaxx div 2 -60,getmaxY div 2 -40,'Success');
                outtextxy(getmaxx div 2 -90,getmaxY div 2 +10,'Score earned');
                outtextxy(getmaxx div 2 -30,getmaxY div 2 +60,s);
				outtextxy(getmaxx div 2 -110,getmaxY div 2 +150,'"esc to continue"');
				key:=readkey;
             until key=esc;
			 game;
           end;
  end;
 
//объединение всех процедур удения 
procedure catch(var step_mini:integer; bonus,w1,w2,w3,w4,w5,w6,w7,plus:integer); //бонус - начисляемые очки, w1..w7 - числа сравнения для прогресса
  begin
  n:=150;
     cleardevice;	 
	 repeat
	    c:=c +1; //анимация
		n:=n -1; //"время"
		catchground;
		minimove(step_mini);
		falling;
		rising(plus);
	    fail;
		lamps(bonus,w1,w2,w3,w4,w5,w6,w7);
		if n<0 then n:=150;
     until 0=2;
  end;

//очки  
procedure scored;
var s:string;
  begin
     str(score,s);
	 setcolor(purple);
	 outtextxy(getmaxx -200,16,'Score :');
     outtextxy(getmaxx -90,17,s);	
     updategraph(updateon);	 
  end;
 
//попытки 
procedure attempts;
  begin
  worms2:=worms;
     if worms = 3 then 
	   begin
	     putanim(30,18,worm,transput);
		 putanim(70,18,worm,transput);
		 putanim(110,18,worm,transput);
	   end;
	 if worms = 2 then 
	   begin
	     putanim(30,18,worm,transput);
		 putanim(70,18,worm,transput);
	   end;
	 if worms = 1 then putanim(30,18,worm,transput);
	 if worms > 3 then worms:= 3;
	 if worms2 > worms then worms:=worms2;
  end;
  
//проигрыш  
procedure lose;
  begin
  score:=0; //начинает игру сначала, после проигрыша
  worms:=3; 
  setcolor(purple);
     cleardevice;
	   repeat
	   outtextxy(getmaxx div 2 -60,getmaxy div 2 -100, 'You lose');
	   outtextxy(getmaxx div 2 -120,getmaxy div 2 + 80, 'press "enter" to exit');
	   key:=readkey;
	   until key=enter;
	 menu;
  end;
  
function check_red_r1(x_f_red_r1,y_f_red_r1,x_cross,y_cross:integer):boolean;
  begin
     if (x_cross >= x_f_red_r1) and (x_cross <= (x_f_red_r1 + width_fish)) 
	 and (y_cross >= y_f_red_r1 -height_fish) 
	 and (y_cross <= (y_f_red_r1 + height_fish)) 
	 then check_red_r1:=true
	   else check_red_r1:=false;
  end;
  
function check_red_r2(x_f_red_r2,y_f_red_r2,x_cross,y_cross:integer):boolean;
  begin
     if (x_cross >= x_f_red_r2) and (x_cross <= (x_f_red_r2 + width_fish)) 
	 and (y_cross >= y_f_red_r2 -height_fish) 
	 and (y_cross <= (y_f_red_r2 + height_fish)) 
	 then check_red_r2:=true
	   else check_red_r2:=false;
  end;
 
function check_red_l1(x_f_red_l1,y_f_red_l1,x_cross,y_cross:integer):boolean;
  begin
     if (x_cross >= x_f_red_l1) and (x_cross <= (x_f_red_l1 + width_fish)) 
	 and (y_cross >= y_f_red_l1 -height_fish) 
	 and (y_cross <= (y_f_red_l1 + height_fish)) 
	 then check_red_l1:=true
	   else check_red_l1:=false;
  end;
  
function check_red_l2(x_f_red_l2,y_f_red_l2,x_cross,y_cross:integer):boolean;
  begin
     if (x_cross >= x_f_red_l2) and (x_cross <= (x_f_red_l2 + width_fish)) 
	 and (y_cross >= y_f_red_l2 -height_fish) 
	 and (y_cross <= (y_f_red_l2 + height_fish)) 
	 then check_red_l2:=true
	   else check_red_l2:=false;
  end;
  
function check_yellow_r1(x_f_yellow_r1,y_f_yellow_r1,x_cross,y_cross:integer):boolean;
  begin
     if (x_cross >= x_f_yellow_r1) and (x_cross <= (x_f_yellow_r1 + width_fish)) 
	 and (y_cross >= y_f_yellow_r1 -height_fish) 
	 and (y_cross <= (y_f_yellow_r1 + height_fish)) 
	 then check_yellow_r1:=true
	   else check_yellow_r1:=false;
  end;
  
function check_yellow_r2(x_f_yellow_r2,y_f_yellow_r2,x_cross,y_cross:integer):boolean;
  begin
     if (x_cross >= x_f_yellow_r2) and (x_cross <= (x_f_yellow_r2 + width_fish)) 
	 and (y_cross >= y_f_yellow_r2 -height_fish) 
	 and (y_cross <= (y_f_yellow_r2 + height_fish)) 
	 then check_yellow_r2:=true
	   else check_yellow_r2:=false;
  end;
  
function check_yellow_l1(x_f_yellow_l1,y_f_yellow_l1,x_cross,y_cross:integer):boolean;
  begin
     if (x_cross >= x_f_yellow_l1) and (x_cross <= (x_f_yellow_l1 + width_fish)) 
	 and (y_cross >= y_f_yellow_l1 -height_fish) 
	 and (y_cross <= (y_f_yellow_l1 + height_fish)) 
	 then check_yellow_l1:=true
	   else check_yellow_l1:=false;
  end;
  
function check_yellow_l2(x_f_yellow_l2,y_f_yellow_l2,x_cross,y_cross:integer):boolean;
  begin
     if (x_cross >= x_f_yellow_l2) and (x_cross <= (x_f_yellow_l2 + width_fish)) 
	 and (y_cross >= y_f_yellow_l2 -height_fish) 
	 and (y_cross <= (y_f_yellow_l2 + height_fish)) 
	 then check_yellow_l2:=true
	   else check_yellow_l2:=false;
  end;
  
function check_green_r1(x_f_green_r1,y_f_green_r1,x_cross,y_cross:integer):boolean;
  begin
     if (x_cross >= x_f_green_r1) and (x_cross <= (x_f_green_r1 + width_fish)) 
	 and (y_cross >= y_f_green_r1 -height_fish) 
	 and (y_cross <= (y_f_green_r1 + height_fish)) 
	 then check_green_r1:=true
	   else check_green_r1:=false;
  end;
  
function check_green_r2(x_f_green_r2,y_f_green_r2,x_cross,y_cross:integer):boolean;
  begin
     if (x_cross >= x_f_green_r2) and (x_cross <= (x_f_green_r2 + width_fish)) 
	 and (y_cross >= y_f_green_r2 -height_fish) 
	 and (y_cross <= (y_f_green_r2 + height_fish)) 
	 then check_green_r2:=true
	   else check_green_r2:=false;
  end;
 
function check_green_l1(x_f_green_l1,y_f_green_l1,x_cross,y_cross:integer):boolean;
  begin
     if (x_cross >= x_f_green_l1) and (x_cross <= (x_f_green_l1 + width_fish)) 
	 and (y_cross >= y_f_green_l1 -height_fish) 
	 and (y_cross <= (y_f_green_l1 + height_fish)) 
	 then check_green_l1:=true
	   else check_green_l1:=false;
  end;
  
function check_green_l2(x_f_green_l2,y_f_green_l2,x_cross,y_cross:integer):boolean;
  begin
     if (x_cross >= x_f_green_l2) and (x_cross <= (x_f_green_l2 + width_fish)) 
	 and (y_cross >= y_f_green_l2 -height_fish) 
	 and (y_cross <= (y_f_green_l2 + height_fish)) 
	 then check_green_l2:=true
	   else check_green_l2:=false;
  end;
 
//промах
procedure unhit;
  begin
	 if keypressed then press:=false else press:=true; //не позволяет зажимать пробел 
	 if (key=space) and (press=true) then worms:=worms -1;	
     key:=#0;	 
  end;

//попадание  
procedure hit;
  begin
     if (key=space) and (check_red_r1(x_f_red_r1,y_f_red_r1,x_cross,y_cross)) then 
	 begin worms2:=worms2 +1; catch(step_mini1,bonus1,160,190,180,210,200,230,220,plus1);   end;
	 
	 if (key=space) and (check_red_r2(x_f_red_r2,y_f_red_r2,x_cross,y_cross)) then 
	 begin worms2:=worms2 +1; catch(step_mini1,bonus1,160,190,180,210,200,230,220,plus1);   end; 
	 
	 if (key=space) and (check_red_l1(x_f_red_l1,y_f_red_l1,x_cross,y_cross)) then 
	 begin worms2:=worms2 +1; catch(step_mini1,bonus1,160,190,180,210,200,230,220,plus1);   end;
	 
	 if (key=space) and (check_red_l2(x_f_red_l2,y_f_red_l2,x_cross,y_cross)) then
	 begin worms2:=worms2 +1; catch(step_mini1,bonus1,160,190,180,210,200,230,220,plus1);   end;
	 
	 if (key=space) and (check_yellow_r1(x_f_yellow_r1,y_f_yellow_r1,x_cross,y_cross)) then 
	 begin worms2:=worms2 +1; catch(step_mini2,bonus2,200,240,230,270,260,300,290,plus2);   end;
	 
	 if (key=space) and (check_yellow_r2(x_f_yellow_r2,y_f_yellow_r2,x_cross,y_cross)) then 
	 begin worms2:=worms2 +1; catch(step_mini2,bonus2,200,240,230,270,260,300,290,plus2);   end;
	 
	 if (key=space) and (check_yellow_l1(x_f_yellow_l1,y_f_yellow_l1,x_cross,y_cross)) then 
	 begin worms2:=worms2 +1; catch(step_mini2,bonus2,200,240,230,270,260,300,290,plus2);   end;
	 
	 if (key=space) and (check_yellow_l2(x_f_yellow_l2,y_f_yellow_l2,x_cross,y_cross)) then 
	 begin worms2:=worms2 +1; catch(step_mini2,bonus2,200,240,230,270,260,300,290,plus2);   end;
	 
	 if (key=space) and (check_green_r1(x_f_green_r1,y_f_green_r1,x_cross,y_cross)) then 
	 begin worms2:=worms2 +1; catch(step_mini3,bonus3,250,300,290,340,330,380,370,plus3);  end;
	 
	 if (key=space) and (check_green_r2(x_f_green_r2,y_f_green_r2,x_cross,y_cross)) then 
	 begin worms2:=worms2 +1; catch(step_mini3,bonus3,250,300,290,340,330,380,370,plus3);   end;
	 
	 if (key=space) and (check_green_l1(x_f_green_l1,y_f_green_l1,x_cross,y_cross)) then 
	 begin worms2:=worms2 +1; catch(step_mini3,bonus3,250,300,290,340,330,380,370,plus3);   end;
	 
	 if (key=space) and (check_green_l2(x_f_green_l2,y_f_green_l2,x_cross,y_cross)) then 
	 begin worms2:=worms2 +1; catch(step_mini3,bonus3,250,300,290,340,330,380,370,plus3);   end;
  end;
 
procedure pause;
  begin
     repeat
	   setcolor(red);
	   outtextxy(getmaxx div 2 -60,getmaxy div 2 -50,'P A U S E');
	   outtextxy(getmaxx div 2 -112,getmaxy div 2 +50,'"enter" to continue');
	   outtextxy(getmaxx div 2 -75,getmaxy div 2 +120,'"esc" to exit');
       key:=readkey;
	   if key=esc then menu;
	   if key=enter then game;
	 until 0=2;	 
  end;

procedure game;
  begin
  cleardevice;
    repeat
     count_main:=count_main +10;
	 scored;
	 attempts;
     delay(20);
	 background;
	 move;
	 hit;
	 unhit;
	 if worms2 < 1 then lose;
       if keypressed then control(x_cross,y_cross,width_cross,height_cross,step_cross,cross);
	       putanim(x_cross,y_cross,cross,bkgput);
	       putanim(x_cross,y_cross,cross,transput);
	until key=esc;
	pause;
  end;
  
procedure help;
  begin
  cleardevice;
    repeat
      putimage(0,0,helppic^,0);
	  updategraph(updateon);
	  key:=readkey;
	until key=esc;
	menu;
  end;
  
procedure menu_pic;
  begin
     putimage(0,0,menuA^,1);
  end;
  
procedure menu;
  begin
  cleardevice;
  menu_pic;
  settextstyle(1,0,4);
  setcolor(purple);
  outtextxy(getmaxX div 2 -85,50,'FISHERMAN`S');
  outtextxy(getmaxX div 2 -50,80,'DREAM');
  outtextxy(getmaxX div 2 -60,200,'M  E  N  U');
  outtextxy(getmaxX div 2 -60,300,'G  A  M  E');
  outtextxy(getmaxX div 2 -60,400,'H  E  L  P');
  outtextxy(getmaxX div 2 -60,500,'E  X   I   T');
  repeat
    putanim(x_ar,y_ar,arrow,transput);
    key:=readkey;
    if key=#0 then key:=readkey;
	putanim(x_ar,y_ar,arrow,bkgput);
      case key of
           up: begin if y_ar= 300 then y_ar:= 500 else y_ar:=y_ar -step_ar; putanim(x_ar,y_ar,arrow,transput); end;
           down: begin if y_ar= 500 then y_ar:= 300 else y_ar:=y_ar +step_ar; putanim(x_ar,y_ar,arrow,transput); end;
      end;
    putanim(x_ar,y_ar,arrow,bkgput);
    until key=enter;
      case y_ar of
           300:game;
           400:help;
           500:halt;
      end;
  end;
   
begin
   cleardevice;
   randomize;
   setwindowsize(800,700);
   gd:=nopalette; gm:=mcustom;
   initgraph(gd,gm,'');
   initdata;
   initpict;
   repeat
     menu;
   until 0=2;
end.