function footprint=getFootprint(t,z,u,env,rbt,hmn,sns,soln)
    % 各離散時刻において，人が扇の中に入っていれば1,そうでなければ0を返す．これを[1,n]のリストで与える．

    hmn_path=getHumanPath(t,hmn);
    rbt_path=z;
    
    vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[rbt_path(1,:);rbt_path(2,:)];
    e=[cos(z(3,:));sin(z(3,:))];
    % norm_HR=vecnorm(vec_HR,length(vec_HR(1)),1);
    norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
    vec_HR=(norm_HR-hmn.sizer)./norm_HR.*vec_HR;
    norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
    % norm_HR=norm_HR-(hmn.sizer);

    naiseki=dot(e,vec_HR,1);

    e_vec_th=naiseki./norm_HR;
    % valid_checker=e_vec_th<=1;
    % compensate=1-valid_checker;
    % e_vec_th=e_vec_th.*valid_checker+compensate;
    % valid_checker=e_vec_th>=-1;
    % compensate=valid_checker-1;
    % e_vec_th=e_vec_th.*valid_checker+compensate;
    
    % deg_diff=acos(e_vec_th) % 入力:-1~1, 出力:0~pi
    deg_HR=atan(vec_HR(2,:)./vec_HR(1,:));
    % deg_compensate=deg_HR<0;
    % deg_HR=deg_HR+pi*deg_compensate;
    deg_compensate=vec_HR(1,:)<0;
    deg_HR=deg_HR+pi*deg_compensate;
    deg_diff=deg_HR-z(3,:);
    % deg_diff=rem(deg_diff,2*pi)
    % e_vec_th=rem(e_vec_th,2*pi);

    norm_checker11=norm_HR>=sns.r1;
    norm_checker12=norm_HR<sns.r2;
    norm_checker1=norm_checker11.*norm_checker12;
    deg_checker11=deg_diff>=-sns.phi;
    deg_checker12=deg_diff<=sns.phi;
    deg_checker1=deg_checker11.*deg_checker12;
    roi_checker11=hmn_path(1,:)>=env.roi.xmin;
    roi_checker12=hmn_path(1,:)<=env.roi.xmax;
    roi_checker1=roi_checker11.*roi_checker12;
    % deg_checker21=deg_diff>=pi-sns.phi;
    % deg_checker22=deg_diff<pi;%+sns.phi;
    % deg_checker2=deg_checker21.*deg_checker22;

    footprint=roi_checker1.*norm_checker1.*deg_checker1;
    % footprint=footprint.*(norm_checker1.*norm_checker2.*(deg_checker1+deg_checker2));
end