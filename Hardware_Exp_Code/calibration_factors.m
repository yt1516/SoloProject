capacity = 20; %(kg)
sensitivity = [2.0471 1.8866 2.0249 1.9197]; % 2mV/V
% sensitivity = [2.6 2.6 2.6 2.6]; % 2mV/V
excitation = 10; %V (or use the sensing value from "ai4")
g = 9.81;
%temp = reading*capacity;  % (V.kg) // 0.52
for f= 1:4
mV_to_N_factor(:,f) = (capacity*g)/(sensitivity(:,f)*excitation*0.001);
end