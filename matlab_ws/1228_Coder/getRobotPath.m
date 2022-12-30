function rbt_path=getRobotPath(t,rbt)

rbt_x=rbt.x0+rbt.vx0*t;
rbt_y=rbt.y0+rbt.vy0*t;
rbt_th=rbt.th0+rbt.omg0*t;
rbt_vx=rbt.vx0*ones(1,length(t));
rbt_vy=rbt.vy0*ones(1,length(t));
rbt_omg=rbt.omg0*ones(1,length(t));

rbt_path=[rbt_x;rbt_y;rbt_th;rbt_vx;rbt_vy;rbt_omg];

end