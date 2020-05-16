function IM=load_img()
idx={};
for i=0:1:100
    idx{end+1}='Pain Intensity Images/'+string(i)+'.png';
end
for k=1:1:101
    IM{k}=imread(char(string(idx{k})));
end
end