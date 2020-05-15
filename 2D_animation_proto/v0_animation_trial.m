%%% First attempt to use circle to represent a 2-D cartoon face %%%
%%% Using VedioWriter to adjust the framerate of the animation, circles of
%%% different sizes and positions are used to represent the face outline
%%% and the eyes.

clc
close all 
clear all 
vidObj = VideoWriter('Movie.avi');
vidObj.FrameRate=23;
open(vidObj);
for j=-100:0.1:100
figure(1)
x1=[1 cos(pi/12) cos(pi/6) cos(pi/4) cos(pi/3) cos(5*pi/12) cos(pi/2) -cos(5*pi/12) -cos(pi/3) -cos(pi/4) -cos(pi/6) -cos(pi/12) -1];
l=length(x1);
for i=1:l
    y1(i)=sqrt(1-(x1(i)^2));
end
plot(x1,y1);
yr1=-y1;
hold on
plot(x1,yr1);
x2=0.02*x1-0.4;
y2=0.02*y1+0.4;
yr2=-y2+0.8;
plot(x2,y2);
plot(x2,yr2);
x3=0.02*x1+0.4;
y3=0.02*y1+0.4;
yr3=-y3+0.8;
plot(x3,y3);
plot(x3,yr3);
x4=[0 0.05 0.1 0.15 0.2 0.25 0.3];
l1=length(x4);
for i=1:l1
    y4(i)=j*(x4(i)^2)-0.4;
end
 end
plot(x4,y4)
x5=-x4;
plot(x5,y4);
x6=[0 0 0];
y6=[-0.1 0 0.1];
plot(x6,y6);
axis([-2 2 -2 2]);
  f = getframe;
  writeVideo(vidObj,f);
  close(vidObj);
