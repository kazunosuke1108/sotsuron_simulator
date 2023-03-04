function dz=dynamics(z,u,env,rbt,hmn,sns)

dx=z(5,:);
dy=z(6,:);
dth=z(7,:);
dth_tlt=z(8,:);
dvx=u(1,:);
dvy=u(2,:);
domg=u(3,:);
domg_tlt=z(4,:);
dz=[dx;dy;dth;dth_tlt;dvx;dvy;domg;domg_tlt];

end