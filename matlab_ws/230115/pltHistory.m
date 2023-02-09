function data = pltHistory(t,z,u,env,rbt,hmn,sns,soln,graph_title)

x=z(1,:);
y=z(2,:);
th=z(3,:);
vx=z(4,:);
vy=z(5,:);
omg=z(6,:);

accx=u(1,:);
accy=u(2,:);
acc_ang=u(3,:);


subplot(4,3,1);
plot(t,x,'k');
hold on
plot(t,env.roi.xmin*ones(size(t)),'r');
hold on
plot(t,env.roi.xmax*ones(size(t)),'r');
ylim([env.roi.xmin-1,env.roi.xmax+1]);
xlabel('t [s]');
ylabel('x [m]');

subplot(4,3,2);
plot(t,y,'k');
hold on
plot(t,env.roi.ymin*ones(size(t)),'r');
hold on
plot(t,env.roi.ymax*ones(size(t)),'r');
ylim([env.roi.ymin-0.5,env.roi.ymax+0.5]);
xlabel('t [s]');
ylabel('y [m]');

title(graph_title);

subplot(4,3,3);
plot(t,th,'k');
hold on
plot(t,rbt.thmin*ones(size(t)),'r');
hold on
plot(t,rbt.thmax*ones(size(t)),'r');
ylim([rbt.thmin-pi/10,rbt.thmax+pi/10]);
xlabel('t [s]');
ylabel('theta [rad]');

subplot(4,3,4);
plot(t,vx,'k');
hold on
plot(t,rbt.vxmin*ones(size(t)),'r');
hold on
plot(t,rbt.vxmax*ones(size(t)),'r');
ylim([rbt.vxmin-0.015,rbt.vxmax+0.015]);
xlabel('t [s]');
ylabel('velocity x [m/s]');

subplot(4,3,5);
plot(t,vy,'k');
hold on
plot(t,rbt.vymin*ones(size(t)),'r');
hold on
plot(t,rbt.vymax*ones(size(t)),'r');
ylim([rbt.vymin-0.015,rbt.vymax+0.015]);
xlabel('t [s]');
ylabel('velocity y [m/s]');

subplot(4,3,6);
plot(t,omg,'k');
hold on
plot(t,rbt.omgmin*ones(size(t)),'r');
hold on
plot(t,rbt.omgmax*ones(size(t)),'r');
ylim([rbt.omgmin-pi/40,rbt.omgmax+pi/40]);
xlabel('t [s]');
ylabel('omega [rad/s]');

subplot(4,3,7);
plot(t,accx,'k');
hold on
plot(t,rbt.axmin*ones(size(t)),'r');
hold on
plot(t,rbt.axmax*ones(size(t)),'r');
ylim([rbt.axmin-0.015,rbt.axmax+0.015]);
xlabel('t [s]');
ylabel('acceleration x [m/s^2]');

subplot(4,3,8);
plot(t,accy,'k');
hold on
plot(t,rbt.aymin*ones(size(t)),'r');
hold on
plot(t,rbt.aymax*ones(size(t)),'r');
ylim([rbt.aymin-0.015,rbt.aymax+0.015]);
xlabel('t [s]');
ylabel('acceleration y [m/s^2]');

subplot(4,3,9);
plot(t,acc_ang,'k');
hold on
plot(t,rbt.aangmin*ones(size(t)),'r');
hold on
plot(t,rbt.aangmax*ones(size(t)),'r');
ylim([rbt.aangmin-pi/40,rbt.aangmax+pi/40]);
xlabel('t [s]');
ylabel('angular acceleration [rad/s^2]');

subplot(4,3,10);
v=sqrt(z(4,:).^2+z(5,:).^2);
plot(t,v,'k');
hold on
plot(t,-rbt.vmax*ones(size(t)),'r');
hold on
plot(t,rbt.vmax*ones(size(t)),'r');
ylim([-rbt.vmax-0.05,rbt.vmax+0.05]);
xlabel('t [s]');
ylabel('velocity norm [m/s]');

subplot(4,3,11);
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