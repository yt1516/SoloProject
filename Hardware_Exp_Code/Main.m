% Initialise NI
clear;clc;close all;

devices = daq.getDevices;

s = daq.createSession('ni');
channel1 = addAnalogInputChannel(s,'Dev1','ai0','Voltage');
channel1.Range = [-0.200000 0.200000];

channel2 = addAnalogInputChannel(s,'Dev1','ai1','Voltage');
channel2.Range = [-0.200000 0.200000];

channel3 = addAnalogInputChannel(s,'Dev1','ai2','Voltage');
channel3.Range = [-0.200000 0.200000];

channel4 = addAnalogInputChannel(s,'Dev1','ai3','Voltage');
channel4.Range = [-0.200000 0.200000];

sample_rate=1000;

s.Rate = sample_rate;

%% this should be placed in the top (initilization) 

X_f=0;
x_k_apriori_X = 0;   		%initial state
P_k_apriori_X = 1;  	 	%keep this as 1
Q_k_X = 0.05; 			%noise variance (change this !!!!)
R_k_X = 1.5; 			%process variance (if only neccesary change this !!) 
K_k_X=0;
P_k_X=0;


Y_f=0;
x_k_apriori_Y = 0;   		%initial state
P_k_apriori_Y = 1;  	 	%keep this as 1
Q_k_Y = 0.05; 			%noise variance (change this !!!!)
R_k_Y = 1.5; 			%process variance (if only neccesary change this !!) 
K_k_Y=0;
P_k_Y=0;

%% Sensitivity Matrix
%IM=load_img();

wid=400; % platform width
len=400; % platform length
ridge=200; % centre position of the ridge (from left-most (x=0) edge)

% sigma
ridge_d=50; % side length of the nodule, assuming circular

mu = ridge;
sigma = ridge_d;
x1 = 0:wid;
x2 = 0:len;
[X1,X2] = meshgrid(x1,x2);
X = [X1(:) X2(:)];
y= normpdf(x1,mu,sigma);

ys=100/max(y)*y;

B=repmat(ys,len+1,1);

%% Force Field Plot
close all
figure(1)
ax1=axes;
scatter(200,200)
xlim([0 400])
ylim([0 400])

% movAvg = dsp.MovingAverage(10);
% movAvg1 = dsp.MovingAverage(10);
%
figure(2)
ax2=axes;
ylim([0 100])
ani1=animatedline(ax2,'Color','r');
%
figure(3)
ax3=axes;
f=0;
ss=1;
pain_face(f,IM,ss)

%
figure(4)
ax4=axes;
%% Minimum Calibration, no weight
mV_to_N_factor=[9584.28997117874,10399.6607653981,9689.36737616672,10220.3469292077];
s.DurationInSeconds = 2;

[data,~] = s.startForeground;

    Load_cell_F1 =  data(:,1)*mV_to_N_factor(:,4);  %in N
    Load_cell_F2 =  data(:,2)*mV_to_N_factor(:,1);  %in N
    Load_cell_F3 =  data(:,3)*mV_to_N_factor(:,3);  %in N
    Load_cell_F4 =  data(:,4)*mV_to_N_factor(:,2);  %in N


ref_l=[mean(Load_cell_F1),mean(Load_cell_F2),mean(Load_cell_F3),mean(Load_cell_F4)];

%% Weight Calibration

s.DurationInSeconds = 2;

[data,~] = s.startForeground;

    Load_cell_F1 =  data(:,1)*mV_to_N_factor(:,4);  %in N
    Load_cell_F2 =  data(:,2)*mV_to_N_factor(:,1);  %in N
    Load_cell_F3 =  data(:,3)*mV_to_N_factor(:,3);  %in N
    Load_cell_F4 =  data(:,4)*mV_to_N_factor(:,2);  %in N


base_force = Load_cell_F1-ref_l(1) + Load_cell_F2-ref_l(2) + Load_cell_F3-ref_l(3) + Load_cell_F4-ref_l(4); %in N

ref_w=mean(base_force);

%%
calibration_factor=1;

for k = 1:10001
    data = s.inputSingleScan;
    
    Load_cell_F1 =  data(:,1)*mV_to_N_factor(:,4)-ref_l(1);  %in N
    Load_cell_F2 =  data(:,2)*mV_to_N_factor(:,1)-ref_l(2);  %in N
    Load_cell_F3 =  data(:,3)*mV_to_N_factor(:,3)-ref_l(3);  %in N
    Load_cell_F4 =  data(:,4)*mV_to_N_factor(:,2)-ref_l(4);  %in N
  
%     total_force_before_calibration(:,1) = [Load_cell_F1,Load_cell_F2,Load_cell_F3,Load_cell_F4]; %in N
%     total_force_after_calibration = round(calibration_factor*(sum(total_force_before_calibration)),1);
%     f=round(100*total_force_after_calibration/40);
%     f=total_force_before_calibration;
%     F=[f(4),f(1),f(3),f(2)];
%     
%     F_x=sum(F);
%     
%     x=(F(2)+F(3))*400/F_x;
%     y=(F(3)+F(4))*400/F_x;


    total_force_before_calibration(:,1) = [Load_cell_F1,Load_cell_F2,Load_cell_F3,Load_cell_F4]; %in N
    total_force_after_calibration = round(calibration_factor*(sum(total_force_before_calibration)),2);

    
    x= (((Load_cell_F1) + (Load_cell_F3))*400)/(total_force_after_calibration);
    y= (((Load_cell_F1) + (Load_cell_F4))*400)/(total_force_after_calibration);
    
    %s=B(x,y);
   % trigger_force = (1+s)*F_x;
   
    if total_force_after_calibration > 2 
        
    X_f = x ; % assign to real-time X raw signal 
  	
	z_k_X = X_f;
   	K_k_X = P_k_apriori_X/(P_k_apriori_X + R_k_X);
   	x_k_X = x_k_apriori_X + K_k_X*(z_k_X - x_k_apriori_X);
   	P_k_X = (1 - K_k_X)*P_k_apriori_X;

   	x_k_apriori_X = x_k_X;
   	P_k_apriori_X = (P_k_X + Q_k_X);
   	X_f = x_k_X ;

    X_filterd = X_f;     %final filterd signal
    
    
    Y_f = y ; % assign to real-time Y raw signal 
  	
	z_k_Y = Y_f;
   	K_k_Y = P_k_apriori_Y/(P_k_apriori_Y + R_k_Y);
   	x_k_Y = x_k_apriori_Y + K_k_Y*(z_k_Y - x_k_apriori_Y);
   	P_k_Y = (1 - K_k_Y)*P_k_apriori_Y;

   	x_k_apriori_Y = x_k_Y;
   	P_k_apriori_Y = (P_k_Y + Q_k_Y);
   	Y_f = x_k_Y ;

    Y_filterd = Y_f;     %final filterd signal
    
    x_stored(:,k) = X_filterd;
    y_stored(:,k) = Y_filterd;
    
    x_coord=X_filterd;
    y_coord=Y_filterd;
    
%     if x_coord>=400
%         x_coord=400;
% %     else
% %         x_coord=round(movAvg(x));
%     end
%     
%     if x_coord<=0
%        x_coord=1;
% %     else
% %        x_coord=round(movAvg(x));
%     end 
%     
%     if y_coord>=400
%         y_coord=400;
% %     else
% %         y_coord=round(movAvg(y));
%     end
%     
%     if y_coord<=0
%        y_coord=1;
% %     else
% %        y_coord=round(movAvg(y));
%     end 

    scatter(ax1,x_coord,y_coord);
    xlim(ax1,[0 400])
    ylim(ax1,[0 400])
    
  
%     end
    f=round(total_force_after_calibration*B(round(x_coord),round(y_coord))/100);
    bar_anim(total_force_after_calibration,20,30,ax4)
    if f >=99
        f=99;
    end
    if f<=0
        f=0;
    end
    addpoints(ani1,k,f);
    imshow(IM{f+1},'Parent',ax3)
    
    end
    drawnow limitrate
end



%%

scatter(x_stored,y_stored);
xlabel('X Position (mm)');
ylabel('Y Position (mm)');
title('X and Y positions with time');
xlim([0 400]);
ylim([0 400]);
grid on;
pbaspect([1 1 1]);