% 可以读取rinex3的多普勒值
clear all
clc
% prn 1-32 GPS; 33-58 GLOMASS; 59-87 GALILEO; 88- BDS
%% TDCP model material
addpath(genpath(pwd));
load options.mat;
fig=1;
% load inf0871.mat;load obs0871.mat;load eph0871.mat;load iono0871.mat
% load data_sanhuan.mat
files.rinex='abpo3350.21o';
[obs,inf] = read_obsf(files,options);
% [Eph, iono] = RINEX_get_nav('brdm3510.21p');brdm3350
[Eph, iono] = RINEX_get_nav('brdm3350.21p');

% compute GPStime（s)
[week,sec_of_week] = gps_time(julday(inf.time.first(1),inf.time.first(2),...
    inf.time.first(3),0));
inf.time.week = week;inf.time.sow = sec_of_week;
clear week sec_of_week
for i = 1:length(obs.ep)
    obs.epgps(i,1) = obs.ep(i)+ inf.time.sow+inf.time.week*7*24*3600;
end;clear i

% 未考虑高度角
[rPos, sPos, obs,sVel] = spp1(obs,Eph,inf.time.sow);
% obs = cs_detect(obs, inf, options);
% 考虑高度角
% [rPos, ~] = spp2(obs, Eph, inf.time.sow, obs.elv);
rPos = rPos(:,1:size(rPos,2));
% figure(fig);plotspp(rPos);fig =fig+1;
% figure(fig);plot(rPos(5,:));fig =fig+1;% 绘图PDOP

% obs = cs_detect(obs, inf, options);

delt_x=[];%Qh=cell(1,size(rPos,2));Rh=cell(1,size(rPos,2));

for i=1:size(rPos,2)-1
    sats =[];satnum = 0;
    for j = 1:32
        if isnan(obs.l1(i,j))==0&&isnan(obs.l1(i+1,j))==0&&obs.elv(i,j)~=0&&obs.elv(i,j)>=10
            satnum = satnum+1;
            sats(1,satnum) = j;
        end
    end
%     el_i=[];eli=0;
%     for a=sats,eli=eli+1;el_i(eli,1)=obs.elv(i,a);el_i(eli,2)=obs.elv(i+1,a);end
%     [x, Qhi, Rhi] = tdcp(sats,obs,2,sPos,rPos,i,el_i);
     x = tdcp2(sats,obs,sPos,rPos,i);%,el_i
    delt_x = [delt_x x];
end;clear x a j

denu=[];
for i = 1:size(delt_x,2)
    delt_x(5,i) = norm(delt_x(1:3,i));
    enu = vector_xyz2enu(delt_x(1:3,i),rPos(1:3,i));
    denu = [denu enu];
end 
 %% 
t=1182;
figure(fig);fig =fig+1;
subplot(4,1,1)
h = scatter(1:t,delt_x(1,1:t)',1);
ylim([-100 100]);
legend('x')
subplot(4,1,2)
h = scatter(1:t,delt_x(2,1:t)',1);
ylim([-100 100]);
legend('y')
subplot(4,1,3)
h = scatter(1:t,delt_x(3,1:t)',1);
ylim([-100 100]);
legend('z')
subplot(4,1,4)
h = scatter(1:t,delt_x(5,1:t)',1);
ylim([-100 100]);
legend('p')

figure(fig);fig =fig+1;
subplot(4,1,1)
h = scatter(1:t,denu(1,1:t)',1);
legend('e')
subplot(4,1,2)
h = scatter(1:t,denu(2,1:t)',1);
legend('n')
subplot(4,1,3)
h = scatter(1:t,denu(3,1:t)',1);
legend('u')


%%
[HEAD,PITCH] = attitude_from_deltaX(rPos(1:3,:)',delt_x(1:4,:));
[HEAD1,PITCH1] = kalman_smooth(HEAD,PITCH,30,20,30);

% figure(fig);fig=fig+1;
% subplot(2,1,1);plot(HEAD1);
% subplot(2,1,2);plot(PITCH1);


%%
% mean(denu(1,:))
% mean(denu(2,:))
% mean(denu(3,:))
% sqrt(mean(denu(1,:).^2))
% sqrt(mean(denu(2,:).^2))
% sqrt(mean(denu(2,:).^2))

% save eph0871.mat Eph;save obs0871.mat obs;save iono0871.mat iono; save inf0871.mat inf




