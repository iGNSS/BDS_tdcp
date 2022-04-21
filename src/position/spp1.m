function [rPos, sPos,obs,sVel] = spp1(obs,Eph,sec_of_week)
%SPP 标准单点定位（未考虑卫星高度角）
%   此处显示详细说明

%initialization
f1 = goGNSS.FL1*1e+06; f2 = goGNSS.FL2*1e+06;
lambda1 = goGNSS.V_LIGHT/f1; % wavelength on L1: .19029367  m
% lambda2 = goGNSS.V_LIGHT/f2; % wavelength on L2: .244210213 m
rPos = [];sPos = struct;sVel = struct;
eoph = size(obs.p1,1); obs.elv =zeros(eoph,135);
for i = 1:eoph 
    sats =[];P1=[];satnum = 0;%P=[];P2=[];
    for j = 94:135 %1:32 %
        if isnan(obs.p1(i,j))==0%&&isnan(obs.p2(i,j))==0
            satnum = satnum+1;
            sats(1,satnum) = j;
            P1(satnum,1) = obs.p1(i,j);
%             P2(satnum,1) = obs.p2(i,j);
%             P(satnum,1) = (P1(satnum,1)*f1*f1-P2(satnum,1)*f2*f2)/(f1*f1-f2*f2);%
        end
    end
    [rpos, El, PDOP, spos,satv] = recpo_ls(P1,sats, obs.ep(i)+sec_of_week, Eph);
    e2 = 0;for e_1=sats,e2=e2+1;obs.elv(i,e_1) = El(e2);end
%     rPos = [rPos, rpos];
    for pos =1:length(rpos),rPos(pos,i)=rpos(pos); end
    rPos(5,i) = PDOP;
   j = 1;
   for k = sats
       sPos.(['G' num2str(k)])(i,:)= spos(j,:);
       j = j+1;
   end
   j = 1;
   for k = sats
       sVel.(['G' num2str(k)])(i,:)= satv(j,:);
       j = j+1;
   end
end 
end

