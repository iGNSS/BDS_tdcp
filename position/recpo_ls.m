function [pos, El, PDOP, basic_obs,satv] = recpo_ls(obsi,sats,time,Eph)
% RECPO_LS Computation of receiver position from pseudoranges
%          using ordinary least-squares principle

% RECPO_LS 用伪距观测值最小二乘计算接收机位置。
%  obs  该历元的卫星观测值
%  sats obs对应的卫星的PRN号
%  time 对应的卫星时刻
%  Eph 星历信息
%Kai Borre 31-10-2001
%Copyright (c) by Kai Borre
%$Revision: 1.1 $  $Date: 2002/07/10  $

v_light = 299792458;
dtr = pi/180;
m = size(obsi,1);  % number of svs  卫星个数
el = zeros(m,1);
% identify ephemerides columns in Eph
for t = 1:m
    col_Eph(t) = find_eph(Eph,sats(t),time); %在星历矩阵中，搜索卫星对应的列。  
end
% preliminary guess for receiver position and receiver clock offset
% 接收机位置和接收机钟差的初步求解
pos = zeros(4,1);
no_iterations = 6; %迭代6次
ps_corr = [];
sat_pos = [];
satv=[];
for iter = 1:no_iterations
    A = [];     %迭代更新的是系数阵A和观测值残差omc
    omc = []; % observed minus computed observation
    for i = 1:m        
        k = col_Eph(i);
        tx_RAW = time - obsi(i)/v_light;
        t0c = Eph(21,k);
        dt = check_t(tx_RAW-t0c); % GPS时间超限或下溢的修复
        tcorr = (Eph(2,k)*dt^2 + Eph(20,k))*dt + Eph(19,k); %修正钟差
        tx_GPS = tx_RAW-tcorr;
        dt = check_t(tx_GPS-t0c); % GPS时间超限或下溢的修复
        tcorr = (Eph(2,k)*dt^2 + Eph(20,k))*dt + Eph(19,k); %修正钟差
        tx_GPS = tx_RAW-tcorr;
        [X, satvi]= satpos(tx_GPS, Eph(:,k));% 用eph给定的星历信息,计算t时刻的m卫星的X，Y，Z坐标
        if iter == 1
            traveltime = 0.072;
            Rot_X = X;
            trop = 0;
        else
            rho2 = (X(1)-pos(1))^2+(X(2)-pos(2))^2+(X(3)-pos(3))^2;  %接收机与卫星间的距离
            traveltime = sqrt(rho2)/v_light;
            Rot_X = e_r_corr(traveltime,X);  % E_R_CORR返回卫星的ECEF坐标值，考虑信号传播时地球自转的影响
            rho2 = (Rot_X(1)-pos(1))^2+(Rot_X(2)-pos(2))^2+(Rot_X(3)-pos(3))^2;          
            [az,el,dist] = topocent(pos(1:3,:),Rot_X-pos(1:3,:));  %topocent(X,dx)将向量dx转换成以X为坐标原点的站心坐标。                                                         
                                                                   %两个参数都是3*1的向量
            if iter == no_iterations
                El(i) = el; 
            end
            trop = tropo(sin(el*dtr),0.0,1013.0,293.0,50.0,0.0,0.0,0.0);    
        end
        % subtraction of pos(4) corrects for receiver clock offset
        % pos(4) 接收机钟差改正
        % v_light*tcorr is the satellite clock offset
        % v_light*tcorr 卫星钟差改正
        if iter == no_iterations
            ps_corr = [ps_corr; obsi(i)+v_light*tcorr-trop];
            sat_pos = [sat_pos; Rot_X']; 
            satv = [satv;satvi'];
        end
        omc = [omc; obsi(i)-norm(Rot_X-pos(1:3),'fro')-pos(4)+v_light*tcorr-trop];
        A = [A; (-(Rot_X(1)-pos(1)))/obsi(i)...
                (-(Rot_X(2)-pos(2)))/obsi(i) ...
                (-(Rot_X(3)-pos(3)))/obsi(i) 1];
    end % satellite
    x = A\omc;%i.e inv(A)*omc   A不是方阵时，A\omc即等于inv(A'*A)*(A'*omc)
    if  isnan(x)==1
        a=1;
    end
    pos = pos+x;
    if iter == no_iterations, B = A'*A;
        B= B(1:3,1:3);PDOP = sqrt(trace(inv(B))); 
        % two lines that solve an exercise on computing tdop
        % invm = inv(A'*A);
        % tdop = sqrt(invm(4,4))
    end
end % iter
basic_obs = [sat_pos ps_corr];

%%%%%%%%%%%%%%%%%%%%%  recpo_ls.m  %%%%%%%%%%%%%%%%%%%%%
