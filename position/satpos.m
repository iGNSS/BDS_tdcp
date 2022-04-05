function [satp, satv]= satpos(t,eph)
%SATPOS   Calculation of X,Y,Z coordinates at time t
%                   for given ephemeris eph


GM = 3.986005e14;             % earth's universal gravitational
% parameter m^3/s^2
Omegae_dot = 7.2921151467e-5; % earth rotation rate, rad/s

%  Units are either seconds, meters, or radians
%  Assigning the local variables to eph
svprn   =   eph(1);
af2     =   eph(2);
M0      =   eph(3);
roota   =   eph(4);
deltan  =   eph(5);
ecc     =   eph(6);
omega   =   eph(7);
cuc     =   eph(8);
cus     =   eph(9);
crc     =  eph(10);
crs     =  eph(11);
i0      =  eph(12);
idot    =  eph(13);
cic     =  eph(14);
cis     =  eph(15);
Omega0  =  eph(16);
Omegadot=  eph(17);
toe     =  eph(18);
af0     =  eph(19);
af1     =  eph(20);
toc     =  eph(21);

% Procedure for coordinate calculation
A = roota*roota;
tk = check_t(t-toe);
n0 = sqrt(GM/A^3);
n = n0+deltan; %���ǵ�ƽ��������
M = M0+n*tk;
M = rem(M+2*pi,2*pi);
E = M;
for i = 1:10
   E_old = E;
   E = M+ecc*sin(E);
   dE = rem(E-E_old,2*pi);
   if abs(dE) < 1.e-12
      break;
   end
end
E = rem(E+2*pi,2*pi);
v = atan2(sqrt(1-ecc^2)*sin(E), cos(E)-ecc);
phi = v+omega;
phi = rem(phi,2*pi);
u = phi              + cuc*cos(2*phi)+cus*sin(2*phi);
r = A*(1-ecc*cos(E)) + crc*cos(2*phi)+crs*sin(2*phi);
i = i0+idot*tk       + cic*cos(2*phi)+cis*sin(2*phi);
Omega = Omega0+(Omegadot-Omegae_dot)*tk-Omegae_dot*toe;
Omega = rem(Omega+2*pi,2*pi);
% ����������
x1 = cos(u)*r; 
y1 = sin(u)*r;
satp(1,1) = x1*cos(Omega)-y1*cos(i)*sin(Omega);
satp(2,1) = x1*sin(Omega)+y1*cos(i)*cos(Omega);
satp(3,1) = y1*sin(i);


% ��������ٶ�
n =  n0 + deltan; % Mkƽ����Ƕ�ʱ���һ�׵���
Ek = n/(1- ecc*cos(E));%ƫ����Ƕ�ʱ���һ�׵���
vk = sqrt(1-ecc*ecc)*Ek/(1-ecc*cos(E)); % �����ǵ�һ�׵���,
phik = vk;% ������Ǿ��һ�׵���
%�����㶯У�����һ�׵���
uk = phik             + 2*phik*(cus*cos(2*phi)-cuc*sin(2*phi));%�㶯У�����������Ǿ��һ�׵���
rk = A*ecc*Ek*sin(E)  + 2*phik*(crs*cos(2*phi)-crc*sin(2*phi));%�㶯У�����ʸ�����ȵ�һ�׵���
ik = idot             + 2*phik*(cis*cos(2*phi)-cic*sin(2*phi));%�㶯У����Ĺ����ǵ�һ�׵���
% ���������ڹ�����ϵ��ٶ�
xk = rk*cos(u) - rk*uk*sin(u);
yk = rk*sin(u) - rk*uk*cos(u);
Omegak = Omegadot-Omegae_dot;
% ����������ECEF�ϵ��ٶ�
vx = (xk-y1*Omegak*sin(i))*cos(Omega) - (x1*Omegak+yk*cos(i)-satp(3,1)*ik)*sin(Omega);
vy = (xk-y1*Omegak*sin(i))*sin(Omega) - (x1*Omegak+yk*cos(i)-satp(3,1)*ik)*cos(Omega);
vz = yk * sin(i) + y1 * ik *cos(i);
satv =[vx;vy;vz];



%%%%%%%%% end satpos.m %%%%%%%%%
