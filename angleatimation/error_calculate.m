function [err_head,err_pitch,rmse_head,rmse_pitch,max_head_error,max_pitch_error]=error_calculate(HEAD,PITCH,HEAD1_reference,PITCH1_reference)
% Calculate errors of pitch and heading
% Inputs : HEAD: the heading
%         PITCH: the pitch
%         HEAD1_reference: the reference value of the heading
%         PITCH1_reference: the reference value of the pitch
% Outputs: err_head: the heading error matrix
%         err_pitch: the pitch error matrix
%         rmse_head: the RMSE of heading
%         rmse_pitch: the RMSE of pitch
%         max_head_error: the maximum heading error
%         max_pitch_error: the maximum pitch error
%----------------------------------------------------------------------------------------------
%                           iTAG_VAD v1.0
%
% Copyright (C) Rui Sun, Qi Cheng and Junhui Wang(2020)
%
% 
%----------------------------------------------------------------------------------------------
for m=1:length(HEAD)
    if isnan(HEAD(m))
        err_head(m)=NaN;
        err_pitch(m)=NaN;
    else
        err_head(m)=HEAD(m)-HEAD1_reference(m);
        err_pitch(m)=PITCH(m)-PITCH1_reference(m);
    end
end
rmse_head=sqrt(nanmean(err_head.^2));
rmse_pitch=sqrt(nanmean(err_pitch.^2));
max_head_error=max(max(err_head),-1*min(err_head));
max_pitch_error=max(max(err_pitch),-1*min(err_pitch));