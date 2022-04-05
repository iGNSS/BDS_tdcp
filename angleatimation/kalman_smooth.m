function [HEAD1,PITCH1] = kalman_smooth(HEAD,PITCH,P,Q,R)
% Adopt kalman filter to smooth the heading and pitch
%Inputs : HEAD: the heading
%         PITCH: the pitch
%         P: state covariance matrix
%         Q: process noise covariance matrix
%         R: measurement noise covariance matrix 
%Outputs: HEAD1: the heading after kalman filter smooth
%         PITCH1: the pitch after kalman filter smooth
%----------------------------------------------------------------------------------------------
%                           iTAG_VAD v1.0
%
% Copyright (C) Rui Sun, Qi Cheng and Junhui Wang(2020)
%
% 
%----------------------------------------------------------------------------------------------
I = eye(1);
P0 = P; % ��ʼƽ��ֵ��Э������ 
X_est(1) = HEAD(1);
for k=2:length(HEAD)
    X_pre=X_est(k-1); % Ԥ��ֵ
    Z = HEAD(k); % �۲�ֵ
    Z_pre = X_pre;
    P_pre = P0 + Q; % Ԥ��ֵЭ�������
    Kg = P_pre/(P_pre+R); % KF ����
    e = Z-Z_pre;
    X_est(k) = X_pre+ Kg*e; % �˲�֮���ֵ
    P0 = (I-Kg)*P_pre; % ����ƽ��ֵ��Э������
end
HEAD1=X_est;
I=eye(1);
P0=P;
X_est1(1)=PITCH(1);
for k=2:length(PITCH)
    X_pre=X_est1(k-1);
    Z=PITCH(k);
    Z_pre=X_pre;
    P_pre=P0+Q;
    Kg=P_pre/(P_pre+R);
    e=Z-Z_pre;
    X_est1(k)=X_pre+Kg*e;
    P0=(I-Kg)*P_pre;
end
PITCH1=X_est1;

