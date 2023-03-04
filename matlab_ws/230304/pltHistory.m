function data = pltHistory(t,z,u,env,rbt,hmn,sns,soln,graph_title)

x=z(1,:);
y=z(2,:);
th=z(3,:);
th_tlt=z(4,:);
vx=z(5,:);
vy=z(6,:);
omg=z(7,:);
omg_tlt=z(8,:);

accx=u(1,:);
accy=u(2,:);
acc_ang=u(3,:);
acc_ang_tlt=u(4,:);

subplot(4,4,1);
plot(t,x,'k');
hold on
plot(t,env.roi.xmin*ones(size(t)),'r');
hold on
plot(t,env.roi.xmax*ones(size(t)),'r');
ylim([env.roi.xmin-1,env.roi.xmax+1]);
xlabel('t [s]');
ylabel('x [m]');

subplot(4,4,2);
plot(t,y,'k');
hold on
plot(t,env.roi.ymin*ones(size(t)),'r');
hold on
plot(t,env.roi.ymax*ones(size(t)),'r');
ylim([env.roi.ymin-0.5,env.roi.ymax+0.5]);
xlabel('t [s]');
ylabel('y [m]');

title(graph_title);
subplot(4,4,3);
% vx_check=hmn.vx==-1.0 || hmn.vx==-1.1;
% y0_check=hmn.y0==1.5 || hmn.y0==3.5;

% if vx_check && y0_check
%     plot(t,th,'m','LineWidth',2);
% else
    plot(t,th,'k');
% end
hold on
plot(t,rbt.thmin*ones(size(t)),'r');
hold on
plot(t,rbt.thmax*ones(size(t)),'r');
ylim([rbt.thmin-pi/10,rbt.thmax+pi/10]);
xlabel('t [s]');
ylabel('theta [rad]');

subplot(4,4,4);
plot(t,th_tlt,'k');
hold on
plot(t,rbt.th_tlt_min*ones(size(t)),'r');
hold on
plot(t,rbt.th_tlt_max*ones(size(t)),'r');
ylim([rbt.th_tlt_min-pi/10,rbt.th_tlt_min+pi/10]);
xlabel('t [s]');
ylabel('theta tilt [rad]');


subplot(4,4,5);
plot(t,vx,'k');
hold on
plot(t,rbt.vxmin*ones(size(t)),'r');
hold on
plot(t,rbt.vxmax*ones(size(t)),'r');
ylim([rbt.vxmin-0.015,rbt.vxmax+0.015]);
xlabel('t [s]');
ylabel('velocity x [m/s]');

subplot(4,4,6);
plot(t,vy,'k');
hold on
plot(t,rbt.vymin*ones(size(t)),'r');
hold on
plot(t,rbt.vymax*ones(size(t)),'r');
ylim([rbt.vymin-0.015,rbt.vymax+0.015]);
xlabel('t [s]');
ylabel('velocity y [m/s]');

subplot(4,4,7);
plot(t,omg,'k');
hold on
plot(t,rbt.omgmin*ones(size(t)),'r');
hold on
plot(t,rbt.omgmax*ones(size(t)),'r');
ylim([rbt.omgmin-pi/40,rbt.omgmax+pi/40]);
xlabel('t [s]');
ylabel('omega [rad/s]');

subplot(4,4,8);
plot(t,omg_tlt,'k');
hold on
plot(t,rbt.omg_tlt_min*ones(size(t)),'r');
hold on
plot(t,rbt.omg_tlt_max*ones(size(t)),'r');
ylim([rbt.omg_tlt_min-pi/40,rbt.omg_tlt_max+pi/40]);
xlabel('t [s]');
ylabel('omega tilt [rad/s]');

subplot(4,4,9);
plot(t,accx,'k');
hold on
plot(t,rbt.axmin*ones(size(t)),'r');
hold on
plot(t,rbt.axmax*ones(size(t)),'r');
ylim([rbt.axmin-0.015,rbt.axmax+0.015]);
xlabel('t [s]');
ylabel('acceleration x [m/s^2]');

subplot(4,4,10);
plot(t,accy,'k');
hold on
plot(t,rbt.aymin*ones(size(t)),'r');
hold on
plot(t,rbt.aymax*ones(size(t)),'r');
ylim([rbt.aymin-0.015,rbt.aymax+0.015]);
xlabel('t [s]');
ylabel('acceleration y [m/s^2]');

subplot(4,4,11);
plot(t,acc_ang,'k');
hold on
plot(t,rbt.aangmin*ones(size(t)),'r');
hold on
plot(t,rbt.aangmax*ones(size(t)),'r');
ylim([rbt.aangmin-pi/40,rbt.aangmax+pi/40]);
xlabel('t [s]');
ylabel('angular acceleration [rad/s^2]');

subplot(4,4,12);
plot(t,acc_ang_tlt,'k');
hold on
plot(t,rbt.aang_tlt_min*ones(size(t)),'r');
hold on
plot(t,rbt.aang_tlt_max*ones(size(t)),'r');
ylim([rbt.aang_tlt_min-pi/40,rbt.aang_tlt_max+pi/40]);
xlabel('t [s]');
ylabel('angular acceleration tilt [rad/s^2]');

subplot(4,4,13);
v=sqrt(z(4,:).^2+z(5,:).^2);
plot(t,v,'k');
hold on
plot(t,-rbt.vmax*ones(size(t)),'r');
hold on
plot(t,rbt.vmax*ones(size(t)),'r');
ylim([-rbt.vmax-0.05,rbt.vmax+0.05]);
xlabel('t [s]');
ylabel('velocity norm [m/s]');

subplot(4,4,14);
rbt_path=z;
hmn_path=getHumanPath(t,hmn);
vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[rbt_path(1,:);rbt_path(2,:)];
norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
vec_HR=(norm_HR-hmn.sizer)./norm_HR.*vec_HR;
norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
plot(t,norm_HR,'k');
hold on
plot(t,0*ones(size(t)),'r');
hold on
plot(t,hmn.personal_r*ones(size(t)),'r');
ylim([hmn.personal_r-0.2,2]);
xlabel('t [s]');
ylabel('distance [m]');
end