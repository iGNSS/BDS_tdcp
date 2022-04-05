function eph = r_rinexe_p(ephemerisfile, sys)
%RINEXE Reads a RINEX Navigation Message file and
%	     reformats the data into a matrix with 21
%	     rows and a column for each satellite.
%	     The matrix is stored in outputfile
% RINEXE.m 读取RINEX 混合导航信息P文件，将信息以矩阵
%          的格式写入文件。矩阵中有21行，每一列储存
%          一颗卫星的信息。
%
%Typical call: rinexe('pta.96n','pta.nav')

%Kai Borre 04-18-96
%Copyright (c) by Kai Borre
%$Revision: 1.0 $  $Date: 1997/09/24  $

% Units are either seconds, meters, or radians
fide = fopen(ephemerisfile);
head_lines = 0;
while 1  % We skip header
   head_lines = head_lines+1;  
   line = fgetl(fide);
   answer = findstr(line,'END OF HEADER');
   if ~isempty(answer), break;	end
end
head_lines;%
noeph = -1;nbds=0;   allsys_eph_n=0;
while 1
   noeph = noeph+1;
   line = fgetl(fide);
   if line(1)==sys ,nbds=nbds+1;end
   if line(1) ~= ' ' ,allsys_eph_n  = allsys_eph_n+1;end
   if line == -1, break;  end
end
noeph = noeph/8;
frewind(fide);
line = fgetl(fide);   %systemname=string(line(41:46));
for i = 2:head_lines, line = fgetl(fide); end

% Set aside memory for the input
svprn	 = zeros(1,nbds);
weekno	 = zeros(1,nbds);
%t0c	 = zeros(1,noeph);
toc	 = zeros(1,nbds);   %自己加的；
tgd	 = zeros(1,nbds);
aodc	 = zeros(1,nbds);
toe	 = zeros(1,nbds);
af2	 = zeros(1,nbds);
af1	 = zeros(1,nbds);
af0	 = zeros(1,nbds);
aode	 = zeros(1,nbds);
deltan	 = zeros(1,nbds);
M0	 = zeros(1,nbds);
ecc	 = zeros(1,nbds);
roota	 = zeros(1,nbds);
toe	 = zeros(1,nbds);
cic	 = zeros(1,nbds);
crc	 = zeros(1,nbds);
cis	 = zeros(1,nbds);
crs	 = zeros(1,nbds);
cuc	 = zeros(1,nbds);
cus	 = zeros(1,nbds);
Omega0	 = zeros(1,nbds);
omega	 = zeros(1,nbds);
i0	 = zeros(1,nbds);
Omegadot = zeros(1,nbds);
idot	 = zeros(1,nbds);
accuracy = zeros(1,nbds);
health	 = zeros(1,nbds);
fit	 = zeros(1,nbds);
    
bds_xu=0; line_num=0;
for i = 1 : allsys_eph_n%allsys_eph_n表示混合星历文件中包含所有卫星系统的所有记录的个数
%    if 39576-line_num<9
%        d=1;
%    end
   line = fgetl(fide);	 %find1=strfind(line,'C'); find2=strfind(line,'G');find3=strfind(line,'E');find4=strfind(line,'R');find5=strfind(line,'I'); find6=strfind(line,'S');finds=[];
%    if find1==1 
%        finds=1;
%    elseif find2==1
%        finds=1;
%    elseif find3==1
%        finds=1;
%    elseif find4==1
%        finds=1;
%    elseif find5==1
%        finds=1;
%    elseif find6==1
%        finds=1;
%    end  
  if   line(1)== sys  %||  systemname==string('BEIDOU') %isempty(finds)
   bds_xu=bds_xu+1;
   svprn(bds_xu) = str2num(line(2:3));   %卫星的PRN号
   year = line(7:8);
   month = line(10:11);
   day = line(13:14);
   hour = line(16:17);
   minute = line(19:20);
   second = line(22:23);      
   
   %自己修改的，TOC：卫星钟的参考时刻
   h = str2num(hour)+str2num(minute)/60+str2num(second)/3600;
      jd = julday(str2num(year)+2000, str2num(month), str2num(day), h);
      [week, sec_of_week] = gps_time(jd); % 将儒略日时间转换成GPS时间 %week GPS时的周数 %sec_of_week 一周内的秒数（TOW）
      jd;
      toc(bds_xu) = sec_of_week;
    %
    
   af0(bds_xu) = str2num(line(24:42));     % 卫星钟的偏差（s)
   af1(bds_xu) = str2num(line(43:61));     % 卫星钟的漂移(s/s)
   af2(bds_xu) = str2num(line(62:80));     % 卫星钟的漂移速度(s/s/s)
   line = fgetl(fide);	  %
   IODE = line(5:23);                 % 星历发布的时间 
   crs(bds_xu) = str2num(line(24:42));     % 轨道半径的正弦调和项改正的振幅(m) 
   deltan(bds_xu) = str2num(line(43:61));  % 由精密星历计算得到的卫星平均角速度与按给定参数计算所得的平均角速度差(弧度)
   M0(bds_xu) = str2num(line(62:80));      % 按参考历元TOE计算的平近点角（弧度）
   line = fgetl(fide);	  %
   cuc(bds_xu) = str2num(line(5:23));      % 纬度幅角的余弦调和项改正的振幅（弧度）
   ecc(bds_xu) = str2num(line(24:42));     % 轨道偏心率
   cus(bds_xu) = str2num(line(43:61));     % 纬度幅角的正弦调和项改正的振幅（弧度）
   roota(bds_xu) = str2num(line(62:80));   % 轨道长半径的平方根（0.5m)
   line=fgetl(fide);
   toe(bds_xu) = str2num(line(5:23));      % 星历的参考时刻TOE(s)
   cic(bds_xu) = str2num(line(24:42));     % 轨道倾角的余弦调和项改正的振幅(弧度)
   Omega0(bds_xu) = str2num(line(43:61));  % 按参考历元TOE计算的升交点赤经（弧度）
   cis(bds_xu) = str2num(line(62:80));     % 轨道倾角的余弦调和项改正的振幅(弧度)
   line = fgetl(fide);	    %
   i0(bds_xu) =  str2num(line(5:23));      % 按参考历元TOE计算的轨道倾角（弧度）
   crc(bds_xu) = str2num(line(24:42));     % 轨道半径的余弦调和项改正的振幅(m) 
   omega(bds_xu) = str2num(line(43:61));   % 近地点角距（弧度）
   Omegadot(bds_xu) = str2num(line(62:80));% 升交点赤经的变化率（弧度/秒）
   line = fgetl(fide);	    %
   idot(bds_xu) = str2num(line(5:23));     % 轨道倾角变化率（弧度/秒）
   codes = str2num(line(24:42));      % L2上的码
   weekno = str2num(line(43:61));     % GPS周数（与TOE一同表示时间）
   L2flag = str2num(line(62:80));     % L2 P码数据标记
   line = fgetl(fide);	    % 
   svaccur = str2num(line(5:23));     % 卫星精度（m）
   svhealth = str2num(line(24:42));   % 卫星健康状态
   tgd(bds_xu) = str2num(line(43:61));     % 载波L1、L2的电离层时延差（s)
   iodc = line(62:80);                % 星钟的数据期龄
   line = fgetl(fide);	    %
   %toc(i) = str2num(line(4:22));     % 这个是电文发送时刻，不是TOC
   spare = line(24:42);               % 拟合区间（未知则为零）
   spare = line(43:61);
   spare = line(62:80);
   elseif  line(1)=='R'
     for k=1:3,line = fgetl(fide); end;  line_num=line_num+4;
  elseif  line(1)=='S'
     for k=1:3,line = fgetl(fide); end;  line_num=line_num+4;  
%      elseif  isempty(finds)
%      for k=1:3,line = fgetl(fide); end;
  else   
     for k=1:7,line = fgetl(fide); end;  line_num=line_num+8;
 end
end
status = fclose(fide);

%  Description of variable eph.
eph(1,:)  = svprn;
eph(2,:)  = af2;
eph(3,:)  = M0;
eph(4,:)  = roota;
eph(5,:)  = deltan;
eph(6,:)  = ecc;
eph(7,:)  = omega;
eph(8,:)  = cuc;
eph(9,:)  = cus;
eph(10,:) = crc;
eph(11,:) = crs;
eph(12,:) = i0;
eph(13,:) = idot;
eph(14,:) = cic;
eph(15,:) = cis;
eph(16,:) = Omega0;
eph(17,:) = Omegadot;
eph(18,:) = toe;
eph(19,:) = af0;
eph(20,:) = af1;
eph(21,:) = toc;
%eph           %查看内容
%size(eph)     %查看大小


