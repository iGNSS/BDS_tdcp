function [pos, El, PDOP, basic_obs,satv] = recpo_ls(obsi,sats,time,Eph)
% RECPO_LS Computation of receiver position from pseudoranges
%          using ordinary least-squares principle

% RECPO_LS ��α��۲�ֵ��С���˼�����ջ�λ�á�
%  obs  ����Ԫ�����ǹ۲�ֵ
%  sats obs��Ӧ�����ǵ�PRN��
%  time ��Ӧ������ʱ��
%  Eph ������Ϣ
%Kai Borre 31-10-2001
%Copyright (c) by Kai Borre
%$Revision: 1.1 $  $Date: 2002/07/10  $

v_light = 299792458;
dtr = pi/180;
m = size(obsi,1);  % number of svs  ���Ǹ���
el = zeros(m,1);
% identify ephemerides columns in Eph
for t = 1:m
    col_Eph(t) = find_eph(Eph,sats(t),time); %�����������У��������Ƕ�Ӧ���С�  
end
% preliminary guess for receiver position and receiver clock offset
% ���ջ�λ�úͽ��ջ��Ӳ�ĳ������
pos = zeros(4,1);
no_iterations = 6; %����6��
ps_corr = [];
sat_pos = [];
satv=[];
for iter = 1:no_iterations
    A = [];     %�������µ���ϵ����A�͹۲�ֵ�в�omc
    omc = []; % observed minus computed observation
    for i = 1:m        
        k = col_Eph(i);
        tx_RAW = time - obsi(i)/v_light;
        t0c = Eph(21,k);
        dt = check_t(tx_RAW-t0c); % GPSʱ�䳬�޻�������޸�
        tcorr = (Eph(2,k)*dt^2 + Eph(20,k))*dt + Eph(19,k); %�����Ӳ�
        tx_GPS = tx_RAW-tcorr;
        dt = check_t(tx_GPS-t0c); % GPSʱ�䳬�޻�������޸�
        tcorr = (Eph(2,k)*dt^2 + Eph(20,k))*dt + Eph(19,k); %�����Ӳ�
        tx_GPS = tx_RAW-tcorr;
        [X, satvi]= satpos(tx_GPS, Eph(:,k));% ��eph������������Ϣ,����tʱ�̵�m���ǵ�X��Y��Z����
        if iter == 1
            traveltime = 0.072;
            Rot_X = X;
            trop = 0;
        else
            rho2 = (X(1)-pos(1))^2+(X(2)-pos(2))^2+(X(3)-pos(3))^2;  %���ջ������Ǽ�ľ���
            traveltime = sqrt(rho2)/v_light;
            Rot_X = e_r_corr(traveltime,X);  % E_R_CORR�������ǵ�ECEF����ֵ�������źŴ���ʱ������ת��Ӱ��
            rho2 = (Rot_X(1)-pos(1))^2+(Rot_X(2)-pos(2))^2+(Rot_X(3)-pos(3))^2;          
            [az,el,dist] = topocent(pos(1:3,:),Rot_X-pos(1:3,:));  %topocent(X,dx)������dxת������XΪ����ԭ���վ�����ꡣ                                                         
                                                                   %������������3*1������
            if iter == no_iterations
                El(i) = el; 
            end
            trop = tropo(sin(el*dtr),0.0,1013.0,293.0,50.0,0.0,0.0,0.0);    
        end
        % subtraction of pos(4) corrects for receiver clock offset
        % pos(4) ���ջ��Ӳ����
        % v_light*tcorr is the satellite clock offset
        % v_light*tcorr �����Ӳ����
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
    x = A\omc;%i.e inv(A)*omc   A���Ƿ���ʱ��A\omc������inv(A'*A)*(A'*omc)
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
