function [HEAD,PITCH] = attitude_from_deltaX(positionreceiver,X)
% Calculate heading and pitch from the delta position of vehicle in ECEF

% Inputs:positionreceiver:approximate position of receiver in ECEF
%        X=[deltaX deltaY deltaZ delta_clock_of_receiver] in ECEF in m 
%       where [deltaX deltaY deltaZ] is the change of vehicle in position between two epochs
%       delta_clock_of_receiver is receiver clock error by difference two epochs
% Outputs:HEAD:the heading calculated from delta position  
%         PITCH:the pitch calculated from delta position  
%----------------------------------------------------------------------------------------------
%                           iTAG_VAD v1.0
%
% Copyright (C) Rui Sun, Qi Cheng and Junhui Wang(2020)
%
% 
%----------------------------------------------------------------------------------------------


HEAD=[];
PITCH=[];
deltaX=[];
for i=1:length(X)
    if isnan(X(1,i))
        head=NaN;
        pitch=NaN;
        HEAD=[HEAD head];
        PITCH=[PITCH pitch];
        continue
    end
    deltaX(i,:)=vector_xyz2enu(X(1:3,i),positionreceiver(1,:));
    if deltaX(i,1)>0
        cost=deltaX(i,2)/sqrt(deltaX(i,1)^2+deltaX(i,2)^2);
        head=acos(cost)*180/pi;
        tant=deltaX(i,3)/sqrt(deltaX(i,1)^2+deltaX(i,2)^2);
        pitch=atan(tant)*180/pi;
    elseif deltaX(i,1)<0
        cost=deltaX(i,2)/sqrt(deltaX(i,1)^2+deltaX(i,2)^2);
        head=-acos(cost)*180/pi;
        tant=deltaX(i,3)/sqrt(deltaX(i,1)^2+deltaX(i,2)^2);
        pitch=atan(tant)*180/pi;
    else
        head=head;
        pitch=pitch;
    end
    if head<0
        head=head+360;
    end
    HEAD=[HEAD head];
    PITCH=[PITCH pitch];
end