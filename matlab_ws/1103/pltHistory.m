function data = pltHistory(t,z,u)

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
plot(t,x)
ylabel('x')

subplot(3,3,2);
plot(t,y)
ylabel('y')

subplot(3,3,3);
plot(t,th)
ylabel('th')

subplot(3,3,4);
plot(t,vx)
ylabel('vel x')

subplot(3,3,5);
plot(t,vy)
ylabel('vel y')

subplot(3,3,6);
plot(t,omg)
ylabel('omega')

subplot(3,3,7);
plot(t,accx)
ylabel('acc x')

subplot(3,3,8);
plot(t,accy)
ylabel('acc y')

subplot(3,3,9);
plot(t,acc_ang)
ylabel('angular acc')

end