function plotspp(rPos)
%SPP 单点定位坐标差绘图
%   此处显示详细说明
me = mean(rPos,2);
fprintf('\nMean Position as Computed From all Epochs:')
fprintf('\n\nX: %12.3f  Y: %12.3f  Z: %12.3f', me(1,1), me(2,1), me(3,1))
plot((rPos(1:3,:)-rPos(1:3,1))','linewidth',2)
title('Positions Over Time','fontsize',16)
legend('X','Y','Z')
xlabel('Epochs [1 s interval]','fontsize',16)
ylabel('Relative Variation to the First Epoch [m]','fontsize',16)
set(gca,'fontsize',12)

end

