%%% 2-D cartoon face with Action Unit Weights %%%

%%% Added Action Unit (AU) as parameters to control the angle, size and
%%% location of all the moving facial features. Input a force value in the
%%% command window and the face will change to exhibit a corresponding pain
%%% expression for 3 seconds and then back to normal.

ex = linspace(-0.5,0.5);
for i = 1:length(ex)
    clf
    face(0,0,3);
    eye(-1,1,0.3)
    brow(-1,1.5,0);
    cheek(-1.5,-0.2,0.5);
    mouth(0);
    prompt = 'enter palpation force';
    f = input(prompt);
    %outmouth=f/9*1-0.5;
    %outbrow=(f-5)/10;
    %outcheeks=(f-5)/15;
    %outeye = (f-5)/40;
    clf
    face(0,0,3);
    eye(-1,1,f)
    brow(-1,1.5,f);
    cheek(-1.5,0,f);
    mouth(f);
%     c = circle(0,0,3);
%     le = circle(-1,1,0.2+outeye);
%     re = circle(1,1,0.2+outeye);
%     lb = brow(-1,1.5+outbrow,outbrow);
%     rb = brow(1,1.5+outbrow,-outbrow);
%     lc = circle(-1.5,0-outcheeks,0.5);
%     lc = circle(1.5,0-outcheeks,0.5);
%     m = mouth(f);
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

function l = brow(px,py,r)
% p is midpoint, a is tilt, a=0 is neutral.
%AU weights
au4y = 1+r/2;  %AU4 brow angle 
au4x = 1-r/20; %AU4 brow location

x = linspace(px*au4x-0.5,px*au4x+0.5);
y = -0.1*au4y*x + py*au4x;
hold on 
l = plot(x,y,'g','LineWidth',8);
plot(-x,y,'g','LineWidth',8);
hold off
end

function e = eye(x,y,r)

%AU weight
au7 = 1-r/10;

grid on
th = 0:pi/50:2*pi;
xunit = 0.3*au7 * cos(th) + x;
yunit = 0.3*au7 * sin(th) + y;
hold on
e = plot(xunit, yunit,'k','LineWidth',8);
plot(-xunit, yunit,'k','LineWidth',8);
pbaspect([1 1 1])
hold off
end

function c = cheek(x,y,r)

%AU weight
au6 = 1+r/10;

grid on
th = 0:pi/50:2*pi;
xunit = 0.5 * cos(th) + x;
yunit = 0.5 * sin(th) + y*au6;
hold on
c = plot(xunit, yunit,'k','LineWidth',8);
plot(-xunit, yunit,'k','LineWidth',8);
pbaspect([1 1 1])
hold off
end

function m = mouth(r)

% AU weights
au20 = 1+r/2; %AU20 horizontal lip streth
au12 = 1-r/20; %AU12 lip corner pull
au10 = 1-r/30; %AU10 upper lip raise weight

ux = -1/5*au20:0.01:1/5*au20; 
uy = -au12*ux.^2;
for i=1:size(uy)
    count = 0;
    z = max(uy)-uy;
    if z(i)==0
        count = count + 1;
    end
end
range = max(uy(:))-min(uy(:));
if count >= 1
    dy = uy - range - (1.8*au10-range/2);
    uy = uy - range - (2-range/2);
else 
    dy = uy - (1.8*au10-range/2);
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