
clear;clc;close all;

% Loop Setup

IM = load_img();

% Define bed
wid = 400;
len = 400;

% Settings

mu_range=[100,300];

sig_range=[45,55];

% sig=25;
% sig=50;
sig=75;

trial_number=4;

click_number=6;

speed_factor=0.04;

show_training=0;

% Debugger
if mu_range(1)-sig_range(1)<=0 || mu_range(2)+sig_range(2)>=wid
    warning('Out of bound, reduce mu and sigma ranges')
else
    [mu_pos,sig_pos]=set_gen(mu_range,sig_range,trial_number);
end

sig_pos=[25,50,75];
% Force Field Plot

% 2D human face 
figure
ax1=axes;
imshow(IM{1})

% % Number Animation
% figure
% ax1=axes;
% xlim(ax1,[0 100])
% ylim(ax1,[0 100])

% % Bar Animation
% figure
% ax1=axes;
% xlim(ax1,[0 2])
% ylim(ax1,[0 100])

% % Color Animation
% figure
% ax1=axes;
% xlim(ax1,[0 2])
% ylim(ax1,[0 100])

% Traing
if show_training==1
    figure
    ax3=axes;
end
% phantom display
figure
ax2=axes;
%% Main Loop
current_set=1;
trial_array=1:trial_number;
trial_array_rand=trial_array(randperm(length(trial_array)));
prob_store=[];
x_store=[];

x_final=[];

mu_store=[];
x_var=[];
pain_store=[];
ts_click=[]; % record timestamp at each click
ts_show=[]; % record timestamp after each visual cue animation
ts_thinking=[0];

flag=0;
x = 0:1:wid;
tic
while current_set<=trial_number
    
    % generate mu and sigma for current trial
    id_rand=trial_array_rand(current_set);
    mu=mu_pos(id_rand);
    mu_store(end+1)=mu;
    %sig=sig_pos(id_rand);
    
    % save this probability distribution
    prob_cur=normpdf(x,mu,sig);
    prob_cur_norm=prob_cur*6000;%100/max(prob_cur)*prob_cur;
    prob_store=[prob_store;prob_cur_norm];
    pain_dist=prob_store(current_set,:);
    x_store_cur=[];
    pain_store_cur=[];
    
    current_click=1;
    
    while current_click<=click_number
        scatter(ax2,wid/2,len/2);
        plot(ax2,[0 wid],[len/2, wid/2],'--');
        xlim(ax2,[0 wid]);
        ylim(ax2,[0 len]);
        title(ax2,join([num2str(trial_number-current_set+1),' trials left'],1))
        set(gca,'xtick',[]);
        set(gca,'ytick',[]);
        grid on;
        if current_click == click_number
            message="Final Decision";
        else
            message=join([num2str(click_number-current_click),' clicks left'],1);
        end
        text(wid/2,len*3/4,cellstr(message),'FontSize',12);
        pbaspect([1 1 1]);

        [x_click,~]=ginput(1);
        ts_click(end+1)=toc;
        flag=1;
        
        if current_click == click_number
            x_final(end+1)=x_click;

            x_var(end+1)=x_click-mu;
        else
            x_store_cur(end+1)=x_click;

        end
        
        pain=prob_cur_norm(round(x_click));
        pain_store_cur(end+1)=pain;
        
        if flag==1
            anim_face(pain,speed_factor,ax1,IM)
%             bar_anim(pain,speed_factor,ax1)
%             color_anim(pain,speed_factor,ax1)     
            flag = 0;
        end
        ts_show(end+1)=toc;
        if current_set >= 1 && current_click >=2
            ts_thinking(end+1)=ts_thinking(end)+(ts_click(end)-ts_show(end-1));
        else
            ts_thinking(end+1)=ts_click(end);
        end
        current_click=current_click+1;

    end
    
    % Training
    if show_training==1
        plot(ax3,x,prob_cur_norm,'k-','LineWidth',1);
        hold(ax3,'on')
        scatter(ax3,x_store_cur,pain_store_cur(1:end-1),'o','MarkerFaceColor','k','MarkerEdgeColor','k');
        scatter(ax3,x_click,pain,'o','MarkerFaceColor','r','MarkerEdgeColor','r')

        xlim(ax3,[0 wid])
        ylim(ax3,[0 100])
        hold(ax3,'off')
        title(ax3,cellstr('Previous Trial Result'))
    end
    
    x_store=[x_store;x_store_cur];
    pain_store=[pain_store;pain_store_cur];
    current_set=current_set+1;
end
title(ax2,"The End")
file_name=join(['F',num2str(sig)],1);
save(file_name)