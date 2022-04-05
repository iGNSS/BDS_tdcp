function create_figure_wang(X1, YMatrix1, YMatrix2, YMatrix3, YMatrix4)
%  X1:  vector of x data
%  YMatrix1:  matrix of y data (top-left panel, the heading)
%  YMatrix2:  matrix of y data (top-right panel, the pitch)
%  YMatrix3:  matrix of y data (bottom-left panel, heading error)
%  YMatrix4:  matrix of y data (bottom-left panel, pitch error)
%----------------------------------------------------------------------------------------------
%                           iTAG_VAD v1.0
%
% Copyright (C) Rui Sun, Qi Cheng and Junhui Wang(2020)
%
% 
%----------------------------------------------------------------------------------------------


figure;
axes1 = axes('Position',...
    [0.0933786078098472 0.589141253461895 0.370949584924259 0.363140904214453]);
hold(axes1,'on');

plot1 = plot(X1,YMatrix1,'LineWidth',1);
set(plot1(1),'DisplayName','Reference','Color',[0 0 0]);
set(plot1(2),'DisplayName','TDCP based','Color',[1 0 0]);% 
set(plot1(3),'DisplayName','TDCP2 based',...
    'Color',[0 0.447058823529412 0.741176470588235]);

xlabel('Epochs');
ylabel('Heading (degree)');

box(axes1,'on');

legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.233384444757415 0.606551620347913 0.223506739431264 0.139650869027635],...
    'FontSize',10,...
    'EdgeColor',[1 1 1]);

axes2 = axes('Position',...
    [0.570340909090909 0.589141253461892 0.377456807059173 0.361066215417776]);
hold(axes2,'on');

plot2 = plot(X1,YMatrix2,'LineWidth',1);
set(plot2(1),'DisplayName','Reference','Color',[0 0 0]);
set(plot2(2),'DisplayName','TDCP based','Color',[1 0 0]);%
set(plot2(3),'DisplayName','TDCP2 based',...
    'Color',[0 0.447058823529412 0.741176470588235]);

xlabel('Epochs');
ylabel('Pitch (degree)');

box(axes2,'on');

legend2 = legend(axes2,'show');
set(legend2,...
    'Position',[0.715795751139383 0.804602291636828 0.229702965870942 0.139650869027635],...
    'FontSize',10,...
    'EdgeColor',[1 1 1]);

axes3 = axes('Position',...
    [0.0916808149405772 0.118257261410788 0.372647377793529 0.363070539419087]);
hold(axes3,'on');

plot3 = plot(X1,YMatrix3,'LineWidth',1);
set(plot3(1),'DisplayName','TDCP based','Color',[1 0 0]);%
set(plot3(2),'DisplayName','TDCP2 based',...
    'Color',[0 0.447058823529412 0.741176470588235]);

xlabel('Epochs');
ylabel('Heading Error (degree)');

box(axes3,'on');

legend3 = legend(axes3,'show');
set(legend3,...
    'Position',[0.238918485986228 0.139163412377362 0.223506739431264 0.0960099725354639],...
    'FontSize',10,...
    'EdgeColor',[1 1 1]);

axes4 = axes('Position',...
    [0.570340909090909 0.11 0.377027511961723 0.373402489626556]);
hold(axes4,'on');

plot4 = plot(X1,YMatrix4,'LineWidth',1);
 set(plot4(1),'DisplayName','TDCP based','Color',[1 0 0]);%change
set(plot4(2),'DisplayName','TDCP2 based',...
    'Color',[0 0.447058823529412 0.741176470588235]);

xlabel('Epochs');
ylabel('Pitch Error (degree)');

box(axes4,'on');

legend4 = legend(axes4,'show');
set(legend4,...
    'Position',[0.716824731128637 0.380152997420904 0.223506739431264 0.096009972535464],...
    'FontSize',10,...
    'EdgeColor',[1 1 1]);

