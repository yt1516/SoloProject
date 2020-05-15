function anim_face(f,t,ax,IM)
f=round(f);
if f <=1
    f=1;
elseif f>=101
    f=101;
end
n=round(t*f); % normalise step for speed control

for i=1:n:f
    imshow(IM{i},'Parent',ax)
    pause(0.001)
end
for i=f:-n:1
    imshow(IM{i},'Parent',ax)
    pause(0.001)
end
end
