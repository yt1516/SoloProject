function bar_anim(f,f_l,f_h,axes)
if f>f_l && f<f_h
    bar(axes,1,f,1,'b')
else
    bar(axes,1,f,1,'b')
end
title(axes,'Bar Animation')
xlim(axes,[0 2])
ylim(axes,[0 100])
end