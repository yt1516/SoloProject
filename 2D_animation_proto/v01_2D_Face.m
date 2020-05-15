%%% 2-D cartoon face implementation %%%

%%% Input a force from 1 to 10 in the command window and the face exhibits
%%% a corresponding pain expression. Eyebrows, eyes, cheeks and the mouth
%%% all change parametrically and the locations are defined by functions. 

ex = linspace(-0.5,0.5);
for i = 1:length(ex)
    clf
    face(0,0,3);
    eye(-1,1,0.2)
    %circle(-1,1,0.2);
    %eye(1,1,0.2)
    %re = circle(1,1,0.2);
    brow(-1,1.5,0);
    brow(1,1.5,0);
    cheek(-1.5,0,0.5);
    %lc = circle(1.5,0,0.5);
    mouth(2);
    %l = mouth1(0,3);
    %l2 = mouth2(0,3);
    prompt = 'enter palpation force';
    f = input(prompt);
    outmouth=f/9*1-0.5;
    outbrow=(f-5)/10;
    outcheeks=(f-5)/15;
    outeye = (f-5)/40;
    clf
    c = circle(0,0,3);
    le = circle(-1,1,0.2+outeye);
    re = circle(1,1,0.2+outeye);
    lb = brow(-1,1.5+outbrow,outbrow);
    rb = brow(1,1.5+outbrow,-outbrow);
    lc = circle(-1.5,0-outcheeks,0.5);
    lc = circle(1.5,0-outcheeks,0.5);
    m = mouth(f);
    %l = mouth1(outmouth,3);
    %l2 = mouth2(outmouth,3);
    pause(3);
end

function e = face(x,y,r)
grid on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
hold on
e = plot(xunit, yunit,'k','LineWidth',8);
pbaspect([1 1 1])
hold off
end

function l = brow(px,py,a)
% p is midpoint, a is tilt, a=0 is neutral.
x = linspace(px-0.5,px+0.5);
y = a*x + py;
hold on 
l = plot(x,y,'g','LineWidth',8);
plot(-x,y,'g','LineWidth',8);
hold off
end

function e = eye(x,y,f)
r = f;
grid on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
hold on
e = plot(xunit, yunit,'k','LineWidth',8);
plot(-xunit, yunit,'k','LineWidth',8);
pbaspect([1 1 1])
hold off
end

function c = cheek(x,y,f)
r = f;
grid on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
hold on
c = plot(xunit, yunit,'k','LineWidth',8);
plot(-xunit, yunit,'k','LineWidth',8);
pbaspect([1 1 1])
hold off
end

function m = mouth(f)
r = f;
ux = -1/5*r:0.1:1/5*r;
uy = (r/9*1-0.5)*ux.^2;
for i=1:size(uy)
    count = 0;
    z = max(uy)-uy;
    if z(i)==0
        count = count + 1;
    end
end
range = max(uy(:))-min(uy(:));
if count >= 1
    dy = uy - range - (1.8-range/2);
    uy = uy - range - (2-range/2);
else 
    dy = uy - (1.8-range/2);
    uy = uy - (2-range/2);  
end

hold on
m = plot(ux,uy,'r','LineWidth',8);
plot(ux,dy,'r','LineWidth',8);
pbaspect([1 1 1])
hold off
end



%%
function m = mouth1(a,r)
x = -1/5*r:0.1:1/5*r;
y = a*x.^2;
for i=1:size(y)
    count = 0;
    z = max(y)-y;
    if z(i)==0
        count = count + 1;
    end
end
range = max(y(:))-min(y(:));
if count >= 1
    y = y - range - (2-range/2);
else 
    y = y - (2-range/2);
end
hold on
m = plot(x,y,'r','LineWidth',8);
pbaspect([1 1 1])
hold off
end

function m = mouth2(a,r)
x = -1/5*r:0.1:1/5*r;
y = a*x.^2;
for i=1:size(y)
    count = 0;
    z = max(y)-y;
    if z(i)==0
        count = count + 1;
    end
end
range = max(y(:))-min(y(:));
if count >= 1
    y = y - range - (1.8-range/2);
else 
    y = y - (1.8-range/2);
end
hold on
m = plot(x,y,'r','LineWidth',8);
pbaspect([1 1 1])
hold off
end