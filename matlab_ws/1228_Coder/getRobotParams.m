function rbt=getRobotParams(env)

rbt.sizer=0.3;

rbt.x0=0;
rbt.y0=-1;
rbt.th0=0;
rbt.vx0=0.15;
rbt.vy0=0;
rbt.omg0=0;

rbt.vmax=0.22;
rbt.vxmax=0.22;
rbt.vxmin=-0.22;
% rbt.vxmin=0;
rbt.vymax=0.22;
rbt.vymin=-0.22;
rbt.omgmax=pi/4;
rbt.omgmin=-pi/4;

rbt.xF=env.xmax;
rbt.yF=-1;
rbt.thF=0;
rbt.vxF=0;
rbt.vyF=0;
rbt.omgF=0;

rbt.thFmin=-pi/2;
rbt.thFmax=pi/2;

rbt.axmax=0.22;
rbt.axmin=-0.22;
rbt.aymax=0.22;
rbt.aymin=-0.22;
rbt.aangmax=pi/4;
rbt.aangmin=-pi/4;

end