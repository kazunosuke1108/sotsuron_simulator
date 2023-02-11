function J=objF_line(t,z,u,env,rbt,hmn,sns)

    % env.objF_if_edge_a_r は小さいほど傾斜がきつくなる

    %% 情報取得
    hmn_path=getHumanPath(t,hmn);
    rbt_path=z;
    
    vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[rbt_path(1,:);rbt_path(2,:)];
    e=[cos(z(3,:));sin(z(3,:))];
    norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
    vec_HR=(norm_HR-hmn.sizer)./norm_HR.*vec_HR;
    norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);

    naiseki=dot(e,vec_HR,1);

    e_vec_th=naiseki./norm_HR;
    deg_HR=atan(vec_HR(2,:)./vec_HR(1,:));
    deg_compensate=vec_HR(1,:)<0;
    deg_HR=deg_HR+pi*deg_compensate;
    deg_diff=deg_HR-z(3,:);

    %% r positive
    % 上り
    r_11=norm_HR>=sns.r1;
    r_12=norm_HR<sns.r1+2*hmn.sizer;
    r_1=r_11.*r_12;
    score_r1=1/(2*hmn.sizer)*(norm_HR-sns.r1).*r_1;

    % 頂上
    r_21=norm_HR>=sns.r1+2*hmn.sizer;
    r_22=norm_HR<sns.r2-2*hmn.sizer;
    r_2=r_21.*r_22;
    score_r2=1.*r_2;

    % 下り
    r_31=norm_HR>=sns.r2-2*hmn.sizer;
    r_32=norm_HR<sns.r2;
    r_3=r_31.*r_32;
    score_r3=-1/(2*hmn.sizer)*(norm_HR-sns.r2).*r_3;

    % まとめ
    score_r=score_r1+score_r2+score_r3;

    %% phi positive
    % 上り
    p_11=deg_diff>=-sns.phi;
    p_12=deg_diff<-sns.phi+hmn.sizep;
    p_1=p_11.*p_12;

    score_p1=1/hmn.sizep*(deg_diff+sns.phi).*p_1;

    % 頂上
    p_21=deg_diff>=-sns.phi+hmn.sizep;
    p_22=deg_diff<sns.phi-hmn.sizep;
    p_2=p_21.*p_22;

    score_p2=1.*p_2;

    % 下り
    p_31=deg_diff>=sns.phi-hmn.sizep;
    p_32=deg_diff<sns.phi;
    p_3=p_31.*p_32;

    score_p3=-1/hmn.sizep*(deg_diff-sns.phi).*p_3;

    % まとめ
    score_p=score_p1+score_p2+score_p3;

    %% penalty
    % 底辺
    pe_11=norm_HR>=0;
    pe_12=norm_HR<sns.r1;
    pe_1=pe_11.*pe_12;

    score_pe1=-1.*pe_1;

    % 上り
    pe_21=norm_HR>=sns.r1;
    pe_22=norm_HR<sns.r1+2*hmn.sizer;
    pe_2=pe_21.*pe_22;

    score_pe2=1/(2*hmn.sizer)*(norm_HR-(sns.r1+2*hmn.sizer)).*pe_2;

    % まとめ
    score_pe=score_pe1+score_pe2+score_r;

    %% 計測領域外のスコアをゼロとする．（ペナルティを0にすることはしない）
    area_11=hmn_path(1,:)>=env.roi.xmin;
    area_12=hmn_path(1,:)<=env.roi.xmax;
    score_area=area_11.*area_12;

    %% J
    J_kari=score_area.*score_r.*score_p+score_pe;

    J=-J_kari;


end