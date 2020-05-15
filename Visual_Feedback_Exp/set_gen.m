function [mu_set,sigma_set]=set_gen(mu_range,sigma_range,n)
mu_set=randi(mu_range,1,n);
sigma_set=randi(sigma_range,1,n);
end