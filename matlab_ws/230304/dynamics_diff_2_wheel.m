function dz=dynamics_diff_2_wheel(z,u,env,rbt,hmn,sns)

    dt=1/env.hz;

    x=z(1,:);
    y=z(2,:);
    th=z(3,:);
    vx=z(4,:);
    vy=z(5,:);
    omg=z(6,:);

    % v=sqrt(vx.^2+vy.^2);
    % a=sqrt(u(1,:).^2+u(2,:).^2);
    % dx=cos(th).*v;
    % dy=sin(th).*v;
    % dth=omg;
    % dvx=-v.*sin(th).*omg+cos(th).*a;
    % dvy=v.*cos(th).*omg+sin(th).*a;
    % domg=u(3,:);

    % 加速度制御省略
    v=sqrt(u(1,:).^2+u(2,:).^2);
    dx=v.*cos(th);
    dy=v.*sin(th);
    dth=u(3,:);
    dvx=ones(1,length(v));
    dvy=ones(1,length(v));
    domg=ones(1,length(v));

    % dx=z(4,:);
    % dy=z(5,:);
    % dth=z(6,:);
    % dvx=u(1,:);
    % dvy=u(2,:);
    % domg=u(3,:);

    dz=[dx;dy;dth;dvx;dvy;domg];

end