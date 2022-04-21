function [delt_x,rpos] = tdcp_taylor(sats,obs,sPos,rpos,epht)
%  使用的单频信号
%  output ：delt_x: 一个时间间隔卫星移动和接收机钟差影响4*1
%  input  : sats 卫星序列号
%           obs 观测值结构体
%           l 使用的波段号 1或者2 
%           sPOS 卫星坐标结构体
%           rPos 接收机位置矩阵
%           epht 本历元序列号
%   此处显示详细说明
%initialization
% f1= goGNSS.FL1*1e+06; f2= goGNSS.FL2*1e+06;
% lambda1 = goGNSS.V_LIGHT/(goGNSS.FL1*1e+06); % wavelength on L1: .19029367  m
% lambda2 = goGNSS.V_LIGHT/(goGNSS.FL2*1e+06); % wavelength on L2: .244210213 m
% lambda =[lambda1, lambda2];
rs1=[];rs2=[];et1=[];et2=[];
for s= 1:length(sats)
%     pha = ['l' num2str(l)];
    prn =['G' num2str(sats(s))];
    
    pha_t2 = obs.l1(epht+1,sats(s));
    pha_t1 = obs.l1(epht,sats(s));
    delta_pha(s,1)= pha_t2 - pha_t1;
    
%     delta_pha(s,1)= obs.(pha)(epht+1,sats(s))- obs.(pha)(epht,sats(s));
%     rpos = (rPos(1:3,epht))';
    %两个卫星位置矢量
    rs1(:,1:3) = sPos.(prn)(epht,1:3); rs2(:,1:3) = sPos.(prn)(epht+1,1:3);
    % 两个单位向量
    es1 = sPos.(prn)(epht,1:3)- rpos;
    et1(s,:) = es1/norm(es1);
    es2 = sPos.(prn)(epht+1,1:3)- rpos;
    et2(s,:) = es2/norm(es2);
    doppler(s,1) = sum(et2(s,:).*rs2(:,1:3)) -sum(et1(s,:) .* rs1(:,1:3));
    geo(s,1) = sum(et2(s,:).* rpos) - sum(et1(s,:).* rpos);
end
delta_pha = delta_pha - doppler + geo;
% el1 = el(:,1);el2 = el(:,2); % el1是前一时刻高度角
% Q1 = diag(0.003+(0.003./sin(el1*pi/180)).^2);
% Q2 = diag(0.003+(0.003./sin(el2*pi/180)).^2);
% Q = diag(1./sin(el*pi/180).^2);
Q = eye(length(sats));Q1 = 0.003*Q; Q2 = 0.003*Q;
Q = Q1 + Q2;
H = [et2 ones(size(et2,1),1)];
y = -delta_pha;
F = (H'/Q * H)\H'/Q;
delt_x = F * y;
%返回新的接收机位置
rpos = rpos + delt_x(1:3)';
end

