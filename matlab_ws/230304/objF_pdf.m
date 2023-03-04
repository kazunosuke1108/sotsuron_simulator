function J=objF_pdf(t,z,u,env,rbt,hmn,sns)

    % env.objF_if_edge_a_r は小さいほど傾斜がきつくなる

    %% 情報取得
    hmn_path=getHumanPath(t,hmn);

    vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[z(1,:);z(2,:)];
    e=[cos(z(3,:));sin(z(3,:))];
    norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
    vec_HR=(norm_HR-hmn.sizer)./norm_HR.*vec_HR;
    norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);

    naiseki=dot(e,vec_HR,1);

    e_vec_th=naiseki./norm_HR;
    deg_HR=atan(vec_HR(2,:)./vec_HR(1,:));
    deg_compensate1=vec_HR(1,:)<0 & vec_HR(2,:)>0;
    deg_compensate2=vec_HR(1,:)<0 & vec_HR(2,:)<0;
    deg_HR=deg_HR+pi*deg_compensate1-pi*deg_compensate2;
    deg_diff=deg_HR-z(3,:);

    pitch_diff=z(4,:)-atan((sns.h-hmn.h/2)./norm_HR);

    r1=getr1(t,z,u,env,rbt,hmn,sns);
    mu_r=(r1+sns.r2)/2;
    sgm_r=1/6*(sns.r2-r1);
    score_r=pdf('Normal',norm_HR,mu_r,sgm_r);

    %% phi normal_distribution
    mu_phi=0;
    sgm_phi=1/6*2*sns.phi;
    score_phi=pdf('Normal',deg_diff,mu_phi,sgm_phi);

    %% phi normal_distribution
    mu_th_tlt=atan((sns.h-hmn.h/2)./norm_HR);
    sgm_th_tlt=1/6*2*sns.pitch/4;
    score_pitch=pdf('Normal',pitch_diff,mu_th_tlt,sgm_th_tlt)
    size(score_pitch)

    J_kari=score_r.*score_phi.*score_pitch;
    J=-J_kari;

end