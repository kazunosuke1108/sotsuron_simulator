function dz = f(z,u)

% x=z(1,:);
% y=z(2,:);
th=z(3,:);
v=u(1,:);
omg=u(2,:);

size(v);
size(th);
dx=v.*cos(th);
dy=v.*sin(th);
dth=omg;

dz=[dx; dy; dth];

end