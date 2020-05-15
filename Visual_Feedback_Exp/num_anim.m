function num_anim(f,t,axes)
n=round(t*f);

% for i=1:n:f
%     scatter(axes,50,50,'.')
%     text(axes,50,50,cellstr(num2str(f)),'FontSize', 24)
%     pause(0.01)
% end
% 
% for i=f:-n:1
%     scatter(axes,50,50,'.')
%     text(axes,50,50,cellstr(num2str(f)),'FontSize', 24)
%     pause(0.01)
% end
    scatter(axes,50,50,'.')
    text(axes,50,50,cellstr(num2str(f)),'FontSize', 24)
end