clc                                                     
delete(instrfindall);                
s = 'COM4';                           
TCS_Color = serial(s);               
TCS_Color.BaudRate = 9600;            
TCS_Color.Terminator = 'CR';          
TCS_Color.ByteOrder = 'bigEndian';    
if strcmp(TCS_Color.Status,'closed'), fopen(TCS_Color); end
data = fscanf(TCS_Color,'%d');        
i = 0;
x=[0 1 1 0];
y=[0 0 1 1];
right=1;
start=0;
while(i<2)
data = fscanf(TCS_Color,'%d',[2,2]);    
if start==0
    R = data(1,1);
    G = data(2,1); 
    B = data(1,2);
    start=1;
end
if abs(data(1,1)-R)>20 ||abs(data(2,1)-G)>20 ||abs(data(1,2))-B>20     
    R = data(1,1);
    G = data(2,1); 
    B = data(1,2);
end

r = R/255;
g = G/255;
b = B/255;

color = [r g b];
 
hold on
patch( x,y,color)
hold off
view(2)

xlim ([0 10])
ylim ([0 10])
zlim ([0 10])
title('Color Scanner');

hold on
pause(0.001)
i = i + .01;
if right==1
    if x(1)==9
        right=0;
        y(1)=y(1)+1;
        y(2)=y(2)+1;
        y(3)=y(3)+1;
        y(4)=y(4)+1;
    end
    if x(1)~=9
    x(1)=x(1)+1;
    x(2)=x(2)+1;
    x(3)=x(3)+1;
    x(4)=x(4)+1;
    end
else
    if x(1)==0
        right=1;
        y(1)=y(1)+1;
        y(2)=y(2)+1;
        y(3)=y(3)+1;
        y(4)=y(4)+1;
    end
    x(1)=x(1)-1;
    x(2)=x(2)-1;
    x(3)=x(3)-1;
    x(4)=x(4)-1;
end
end

fclose(TCS_Color);
