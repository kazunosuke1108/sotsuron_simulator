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


subplot(3,3,1);
plot(t,x,'k');
hold on
plot(t,env.roi.xmin*ones(size(t)),'r');
hold on
plot(t,env.roi.xmax*ones(size(t)),'r');
ylim([env.roi.xmin-1,env.roi.xmax+1]);
ylabel('x');

subplot(3,3,2);
plot(t,y,'k');
hold on
plot(t,env.roi.ymin*ones(size(t)),'r');
hold on
plot(t,env.roi.ymax*ones(size(t)),'r');
ylim([env.roi.ymin-0.5,env.roi.ymax+0.5]);
ylabel('y');

title(graph_title);

subplot(3,3,3);
plot(t,th,'k');
hold on
plot(t,rbt.thmin*ones(size(t)),'r');
hold on
plot(t,rbt.thmax*ones(size(t)),'r');
ylim([rbt.thmin-pi/10,rbt.thmax+pi/10]);
ylabel('th');

subplot(3,3,4);
plot(t,vx,'k');
hold on
plot(t,rbt.vxmin*ones(size(t)),'r');
hold on
plot(t,rbt.vxmax*ones(size(t)),'r');
ylim([rbt.vxmin-0.015,rbt.vxmax+0.015]);
ylabel('vel x');

subplot(3,3,5);
plot(t,vy,'k');
hold on
plot(t,rbt.vymin*ones(size(t)),'r');
hold on
plot(t,rbt.vymax*ones(size(t)),'r');
ylim([rbt.vymin-0.015,rbt.vymax+0.015]);
ylabel('vel y');

subplot(3,3,6);
plot(t,omg,'k');
hold on
plot(t,rbt.omgmin*ones(size(t)),'r');
hold on
plot(t,rbt.omgmax*ones(size(t)),'r');
ylim([rbt.omgmin-pi/40,rbt.omgmax+pi/40]);
ylabel('omega');

subplot(3,3,7);
plot(t,accx,'k');
hold on
plot(t,rbt.axmin*ones(size(t)),'r');
hold on
plot(t,rbt.axmax*ones(size(t)),'r');
ylim([rbt.axmin-0.015,rbt.axmax+0.015]);
ylabel('acc x');

subplot(3,3,8);
plot(t,accy,'k');
hold on
plot(t,rbt.aymin*ones(size(t)),'r');
hold on
plot(t,rbt.aymax*ones(size(t)),'r');
ylim([rbt.aymin-0.015,rbt.aymax+0.015]);
ylabel('acc y');

subplot(3,3,9);
plot(t,acc_ang,'k');
hold on
plot(t,rbt.aangmin*ones(size(t)),'r');
hold on
plot(t,rbt.aangmax*ones(size(t)),'r');
ylim([rbt.aangmin-pi/40,rbt.aangmax+pi/40]);
ylabel('angular acc');

end