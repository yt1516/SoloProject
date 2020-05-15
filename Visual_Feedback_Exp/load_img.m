function IM=load_img()
idx=[];
for i=0:1:100
    idx=[idx 'Pain Intensity Images/'+string(i)+'.png'];
end
for k=1:1:101
    IM{k}=imread(idx(k));
end
end