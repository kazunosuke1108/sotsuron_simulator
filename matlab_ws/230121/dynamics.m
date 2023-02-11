function dz=dynamics(z,u,env,rbt,hmn,sns)

dx=z(4,:);
dy=z(5,:);
dth=z(6,:);
dvx=u(1,:);
dvy=u(2,:);
domg=u(3,:);

dz=[dx;dy;dth;dvx;dvy;domg];

end