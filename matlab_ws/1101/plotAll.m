function data = plotAll(t,z,u)

x=z(1,:);
y=z(2,:);
th=z(3,:);

v=u(1,:);
omg=u(2,:);

subplot(3, 2, 1);
plot(t, x)
ylabel('x')

subplot(3, 2, 2);
plot(t, y)
ylabel('y')

subplot(3, 2, 3);
plot(t, th)
ylabel('theta')

subplot(3, 2, 4);
plot(t, v)
ylabel('u (v)')

subplot(3, 2, 5);
plot(t, omg)
ylabel('u (omega)')


end