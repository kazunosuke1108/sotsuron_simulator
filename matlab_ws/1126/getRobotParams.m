function rbt=getRobotParams()

rbt.sizer=0.3;

rbt.x0=-5;
rbt.y0=1;
rbt.th0=0;
rbt.vx0=0.15;
rbt.vy0=0;
rbt.omg0=0;

rbt.vxmax=0.15;
% rbt.vxmin=-rbt.vxmax;
rbt.vxmin=0;
rbt.vymax=0.15;
rbt.vymin=-rbt.vymax;
rbt.omgmax=pi/4;
rbt.omgmin=-rbt.omgmax;

rbt.xF=25;
rbt.yF=1;
rbt.thF=0;
rbt.vxF=0;
rbt.vyF=0;
rbt.omgF=0;

rbt.thFmin=-pi;
rbt.thFmax=pi;

rbt.axmax=rbt.vxmax;
rbt.axmin=-rbt.axmax;
rbt.aymax=rbt.vymax;
rbt.aymin=-rbt.aymax;
rbt.aangmax=rbt.omgmax;
rbt.aangmin=-rbt.aangmax;

end