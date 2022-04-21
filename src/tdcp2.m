function delt_x = tdcp2(sats,obs,sPos,rPos,epht)
%  使用双频无电离层组合
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
% lambda1 = goGNSS.V_LIGHT/f1; % wavelength on L1: .19029367  m
% lambda2 = goGNSS.V_LIGHT/f2; % wavelength on L2: .244210213 m
rs1=[];rs2=[];et1=[];et2=[];
for s= 1:length(sats)
    prn =['G' num2str(sats(s))];
    pha_t2 = obs.l1(epht+1,sats(s));
    pha_t1 = obs.l1(epht,sats(s));
    delta_pha(s,1)= pha_t2 - pha_t1;
    rpos = (rPos(1:3,epht))';
    %两个卫星位置矢量
    rs1(:,1:3) = sPos.(prn)(epht,1:3); rs2(:,1:3) = sPos.(prn)(epht+1,1:3);
    % 两个单位向量
    es1 = sPos.(prn)(epht,1:3)- (rPos(1:3,epht))';
    et1(s,:) = es1/norm(es1);
    es2 = sPos.(prn)(epht+1,1:3)- (rPos(1:3,epht+1))';
    et2(s,:) = es2/norm(es2);
    doppler(s,1) = sum(et2(s,:).*rs2(:,1:3)) -sum(et1(s,:) .* rs1(:,1:3));
    geo(s,1) = sum(et2(s,:).* rpos) - sum(et1(s,:).* rpos);
end
delta_pha2 = delta_pha - doppler + geo;
% Q = diag(1./sin(el*pi/180).^2);
Q = eye(length(sats));Q1 = 0.003*Q; Q2 = 0.003*Q;
Q = Q1 + Q2;
H = [et2 ones(size(et2,1),1)];
y = -delta_pha2;
F = (H'/Q * H)\H'/Q;
% delt_x = (H'*Q* H)\H'*Q * y;
delt_x = F * y;

end

