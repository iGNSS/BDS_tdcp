function enu = vector_xyz2enu(xyz,orgxyz)
% Convert a vector from WGS-84 ECEF cartesian coordinates to 
% rectangular local-level-tangent ('East'-'North'-Up) coordinates.
% Inputs: xyz(1) = ECEF x-coordinate in meters
%	      xyz(2) = ECEF y-coordinate in meters
%	      xyz(3) = ECEF z-coordinate in meters
%	      orgxyz(1) = ECEF x-coordinate of local origin in meters
%	      orgxyz(2) = ECEF y-coordinate of local origin in meters
%	      orgxyz(3) = ECEF z-coordinate of local origin in meters
% Outputs: enu:  Column vector
%		   enu(1,1) = 'East'-coordinate relative to local origin (meters)
%		   enu(2,1) = 'North'-coordinate relative to local origin (meters)
%		   enu(3,1) = Up-coordinate relative to local origin (meters)
%----------------------------------------------------------------------------------------------
%                           iTAG_VAD v1.0
%
% Copyright (C) Rui Sun, Qi Cheng and Junhui Wang(2020)
%
% 
%----------------------------------------------------------------------------------------------
if nargin<2,error('insufficient number of input arguments'),end
orgllh = xyz2llh(orgxyz);
phi = orgllh(1);
lam = orgllh(2);
sinphi = sin(phi);
cosphi = cos(phi);
sinlam = sin(lam);
coslam = cos(lam);
R = [ -sinlam          coslam         0     ; ...
      -sinphi*coslam  -sinphi*sinlam  cosphi; ...
       cosphi*coslam   cosphi*sinlam  sinphi];
enu = R*xyz;
