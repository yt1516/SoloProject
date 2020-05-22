dat=readtable('survey.csv','HeaderLines',1);
%%
t_head=["gender","age","ethnicity","occupation"];
weights=["l","m","h"];
for i=1:3
    for j=1:3
        for k=1:3
            for l=1:3
                var=join([weights(i),weights(j),weights(k),weights(l)],"_");
                t_head(end+1)=var;
            end
        end
    end
end
dat.Properties.VariableNames=t_head;
%%
n=0;
testres=[];
totalMean=[];
totalMedian=[];
totalStd=[];

sel_mean=[];

tiledlayout(9,9)

idx=[];
for i=5:length(t_head)
    totalMean(end+1)=mean(table2array(dat(:,i)));
    totalMedian(end+1)=median(table2array(dat(:,i)));
    totalStd(end+1)=std(table2array(dat(:,i)));
    [test_r,val]=swtest(table2array(dat(:,i)),0.05);
    val = round(val,2);
    testres(end+1)=test_r;
    nexttile
    if test_r == 0
        idx(end+1)=i-4;
        sel_mean(end+1)=mean(table2array(dat(:,i)));
        histogram(table2array(dat(:,i)),'BinWidth',1,'FaceColor','r')
        title(['p=' num2str(val)])
        n=n+1;
    else
        histogram(table2array(dat(:,i)),'BinWidth',1,'FaceColor','b')
        title(['p=' num2str(val)])
    end
    
end
%%
dat_mat=[];
for i=5:length(t_head)
    dat_mat(:,end+1)=table2array(dat(:,i));
end
figure
boxplot(dat_mat)
%%
au4=[];
au7=[];
au9=[];
au10=[];
for i=0:0.5:1
    for j=0:0.5:1
        for k=0:0.5:1
            for l=0:0.5:1
                au4(end+1)=i;
                au7(end+1)=j;
                au9(end+1)=k;
                au10(end+1)=l;
            end
        end
    end
end
au=[au4;au7;au9;au10];
%% Selected normal distributions
sel_au=zeros(4,n);
for i=1:1:length(idx)
    sel_au(:,i)=au(:,idx(i));
end
[b,bint,r,rint,stats] = regress(sel_mean',sel_au');
au_t=sel_au';
R_t=sel_mean';

b

%% All Images
[b,bint,r,rint,stats] = regress(totalMean',au');
au_t=au';
R_t=totalMean';

b