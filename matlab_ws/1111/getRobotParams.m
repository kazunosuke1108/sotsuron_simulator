function rbt=getRobotParams()

rbt.x0=0;
% rbt.x0=8;
rbt.y0=1;
rbt.th0=0;
rbt.vx0=0;
rbt.vy0=0;
rbt.omg0=0;

rbt.vxmax=0.15;
rbt.vxmin=-rbt.vxmax;
rbt.vymax=0.15;
rbt.vymin=-rbt.vymax;
rbt.omgmax=pi/4;
rbt.omgmin=-rbt.omgmax;

rbt.xF=15;
rbt.yF=1;
rbt.thF=0;
rbt.vxF=0;
rbt.vyF=0;
rbt.omgF=0;

rbt.thFmin=-pi;
rbt.thFmax=pi;

rbt.axmax=0.15;
rbt.axmin=-rbt.axmax;
rbt.aymax=0.15;
rbt.aymin=-rbt.aymax;
rbt.aangmax=pi/4;
rbt.aangmin=-rbt.aangmax;

end