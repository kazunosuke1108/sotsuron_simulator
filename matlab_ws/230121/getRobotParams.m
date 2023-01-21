function rbt=getRobotParams(env)

rbt.sizer=0.3;

rbt.x0=0;
rbt.y0=2.5;
rbt.th0=0;
rbt.vx0=0.15;
rbt.vy0=0;
rbt.omg0=0;

rbt.thmin=-pi;
rbt.thmax=pi;

rbt.vmax=0.22
rbt.vxmax=rbt.vmax;
rbt.vxmin=-rbt.vxmax;
rbt.vymax=rbt.vmax;
rbt.vymin=-rbt.vymax;
rbt.omgmax=pi/8;
rbt.omgmin=-rbt.omgmax;

rbt.vmax_actual=rbt.vmax%-0.05;
rbt.vxmax_actual=rbt.vmax%-0.05;
% rbt.vxmax_actual=rbt.vmax-0.07;
rbt.vxmin_actual=-rbt.vxmax_actual;
% rbt.vxmin_actual=0;
rbt.vymax_actual=rbt.vmax%-0.05;
% rbt.vymax_actual=rbt.vmax-0.07;
rbt.vymin_actual=-rbt.vymax_actual;
% rbt.vxmin=0;
rbt.omgmax_actual=rbt.omgmax%-0.1;
% rbt.omgmax_actual=rbt.omgmax-0.17;
rbt.omgmin_actual=-rbt.omgmax_actual;

rbt.xF=env.xmax;
rbt.yF=2.5;
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
% rbt.aangmax=ax_scale*rbt.omgmax;
rbt.aangmax=rbt.omgmax;
rbt.aangmin=-rbt.aangmax;

rbt.axmax_actual=rbt.axmax%-0.03;
rbt.axmin_actual=-rbt.axmax_actual;
rbt.aymax_actual=rbt.aymax%-0.03;
rbt.aymin_actual=-rbt.aymax_actual;
rbt.aangmax_actual=rbt.aangmax%-0.1;
rbt.aangmin_actual=-rbt.aangmax_actual;


end