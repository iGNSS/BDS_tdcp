function plottdcp(sum)
%PLOTTDCP 此处显示有关此函数的摘要
plot(sum','linewidth',2);
title('Acumulation of TDCP Error Over Time','fontsize',16)
legend('X','Y','Z','C*Tr')
xlabel('Epochs [1 s interval]','fontsize',16)
ylabel('Acumulation Error [m]','fontsize',16)
set(gca,'fontsize',12)
end

