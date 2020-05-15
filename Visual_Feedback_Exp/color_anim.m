function color_anim(f,t,axes)
b = [0 0 1]; % Blue
r = [1 0 0]; % Red
xOk = [0;100];
n=round(t*f);

for i=1:n:f
    y = interp1(xOk,[b;r],i);
    bar(axes,1,100,1,'FaceColor',y) % Scatter x vs. x but color based on the interpolated color.
    xlim(axes,[0 2])
    ylim(axes,[0 100])
    pause(0.001)
end
for i=f:-n:1
    y = interp1(xOk,[b;r],i);
    bar(axes,1,100,1,'FaceColor',y) % Scatter x vs. x but color based on the interpolated color.
    xlim(axes,[0 2])
    ylim(axes,[0 100])
    pause(0.001)
end
end
