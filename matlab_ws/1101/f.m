function dz = f(z,u)

% x=z(1,:);
% y=z(2,:);
th=z(3,:);
v=u(1,:);
omg=u(2,:);

[dx; dy; dth] = autoGen_f(omg,th,v);

dz=[dx; dy; dth];

end