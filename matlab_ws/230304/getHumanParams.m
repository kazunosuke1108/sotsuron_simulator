function hmn=getHumanParams(env,sns)

hmn.sizer=0.3;
hmn.sizep=atan(hmn.sizer/(sns.r1+hmn.sizer));
hmn.h=1.7
hmn.personal_r=1.2;

hmn.x0=env.xmax;
hmn.y0=2.5;
hmn.th0=pi;
hmn.vx0=0;
hmn.vy0=0;
hmn.omg0=0;

hmn.vx=-0.6; % 0.3m/s = 1km/h
hmn.vx_err=0.1;
hmn.vy=0;
hmn.omg=0;

hmn.e_y0=0;
hmn.e_vx=0;

% hmn.xF=0;
% hmn.yF=1;
% hmn.thF=pi;
% hmn.vxF=0;
% hmn.vyF=0;
% hmn.omgF=0;

end