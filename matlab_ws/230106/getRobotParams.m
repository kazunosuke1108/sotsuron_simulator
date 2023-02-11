function rbt=getRobotParams(env)

rbt.sizer=0.3;

rbt.x0=0;
rbt.y0=-1;
rbt.th0=0;
rbt.vx0=0.15;
rbt.vy0=0;
rbt.omg0=0;

rbt.thmin=-pi;
rbt.thmax=pi;

rbt.vmax=0.22
rbt.vxmax=rbt.vmax;
rbt.vxmin=-rbt.vxmax;
% rbt.vxmin=0;
rbt.vymax=rbt.vmax;
rbt.vymin=-rbt.vymax;
rbt.omgmax=pi/4;
rbt.omgmin=-rbt.omgmax;

rbt.xF=env.xmax;
rbt.yF=-1;
rbt.thF=0;
rbt.vxF=0;
rbt.vyF=0;
rbt.omgF=0;

rbt.thFmin=0;
rbt.thFmax=0;

ax_scale=0.5;
rbt.axmax=ax_scale*rbt.vxmax;
rbt.axmin=-rbt.axmax;
rbt.aymax=ax_scale*rbt.vymax;
rbt.aymin=-rbt.aymax;
rbt.aangmax=ax_scale*rbt.omgmax;
rbt.aangmin=-rbt.aangmax;

end