function dz = dynamics(t,z,u)
% dz = dynamics(t,z,u)
%
%
%
%
% INPUTS:
%   z = [3,n] = first-order state = [x,y,th];
%   u = [2, 1] = input torque vector
%   p = parameter struct

x=z(1,:);
y=z(2,:);
th=z(3,:);

v=u(1,:);
omg=u(2,:);

dx=v*cos(th);
dy=v*sin(th);
dth=omg;

dz=[dx;dy;dth];

end