function bar_anim(f,t,axes)
n=round(t*f);
for i=1:n:f
    bar(axes,1,i,1)
    xlim(axes,[0 2])
    ylim(axes,[0 100])
    pause(0.001)
end
for i=f:-n:1
    bar(axes,1,i,1)
    xlim(axes,[0 2])
    ylim(axes,[0 100])
    pause(0.001)
end
end