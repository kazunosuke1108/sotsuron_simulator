function footprint=getFootprint(t,z,u,env,rbt,hmn,sns,soln)
    % 各離散時刻において，人が扇の中に入っていれば1,そうでなければ0を返す．これを[1,n]のリストで与える．

    hmn_path=getHumanPath(t,hmn);
    rbt_path=z;
    
    vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[rbt_path(1,:);rbt_path(2,:)];
    norm_HR=vecnorm(vec_HR,length(vec_HR(1)),1);
    norm_HR=norm_HR-(hmn.sizer);

    e=[cos(z(3,:));sin(z(3,:))];
    naiseki=dot(e,vec_HR,1);

    e_vec_th=naiseki./norm_HR;
    valid_checker=e_vec_th<=1;
    compensate=1-valid_checker;
    e_vec_th=e_vec_th.*valid_checker+compensate;
    valid_checker=e_vec_th>=-1;
    compensate=valid_checker-1;
    e_vec_th=e_vec_th.*valid_checker+compensate;
    e_vec_th=acos(e_vec_th);
    e_vec_th=rem(e_vec_th,2*pi);

    footprint=ones(1,length(t));
    norm_checker1=norm_HR>=sns.r1;
    norm_checker2=norm_HR<sns.r2;
    deg_checker1=e_vec_th<=sns.phi;
    % deg_checker2=e_vec_th>2*pi-sns.phi;
    deg_checker2=e_vec_th>-sns.phi;

    % footprint=footprint.*(norm_checker1.*norm_checker2.*(deg_checker1+deg_checker2));
    footprint=footprint.*(norm_checker1.*norm_checker2+(deg_checker1.*deg_checker2));
end