function hmn_path=getHumanPath(t,hmn)

    hmn_x=hmn.x0+(hmn.vx+hmn.e_vx)*t;
    hmn_y=(hmn.y0+hmn.e_y0)+hmn.vy*t;
    hmn_th=hmn.th0+hmn.omg*t;
    hmn_vx=(hmn.vx+hmn.e_vx)*ones(1,length(t));
    hmn_vy=hmn.vy*ones(1,length(t));
    hmn_omg=hmn.omg*ones(1,length(t));

    hmn_path=[hmn_x;hmn_y;hmn_th;hmn_vx;hmn_vy;hmn_omg];

end