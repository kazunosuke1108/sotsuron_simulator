function J=objF_if(t,z,u,env,rbt,hmn,sns)

    % env.objF_if_edge_a_r は小さいほど傾斜がきつくなる

    hmn_path=getHumanPath(t,hmn);
    rbt_path=z;
    
    vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[rbt_path(1,:);rbt_path(2,:)];
    e=[cos(z(3,:));sin(z(3,:))];
    vec_HR=(vecnorm(vec_HR,length(vec_HR(1)),1)-hmn.sizer)./vecnorm(vec_HR,length(vec_HR(1)),1).*vec_HR;   
    norm_HR=vecnorm(vec_HR,length(vec_HR(1)),1);
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
    deg_compensate=deg_HR<0;
    deg_HR=deg_HR+pi*deg_compensate;
    deg_diff=deg_HR-z(3,:);
    
    r_11=norm_HR<sns.r1-env.objF_if_edge_a_r;
    r_1=r_11;
    r_21=norm_HR>=sns.r1-env.objF_if_edge_a_r;
    r_22=norm_HR<sns.r1+env.objF_if_edge_a_r;
    r_2=r_21.*r_22;
    r_31=norm_HR>=sns.r1+env.objF_if_edge_a_r;
    r_32=norm_HR<sns.r2-env.objF_if_edge_a_r;
    r_3=r_31.*r_32;
    r_41=norm_HR>=sns.r2-env.objF_if_edge_a_r;
    r_42=norm_HR<sns.r2+env.objF_if_edge_a_r;
    r_4=r_41.*r_42;
    
    r_1=-1*r_1;
    r_2=(1/env.objF_if_edge_a_r*norm_HR-sns.r1/env.objF_if_edge_a_r).*r_2;
    r_3=1*r_3;
    r_4=(-1/env.objF_if_edge_a_r*norm_HR+sns.r2/env.objF_if_edge_a_r).*r_4;
    r_ans=r_1+r_2+r_3+r_4;
    

    % p_11=deg_diff>=-sns.phi-env.objF_if_edge_a_phi;
    p_12=deg_diff<sns.phi-env.objF_if_edge_a_phi;
    p_1=p_12;
    p_21=deg_diff>=sns.phi-env.objF_if_edge_a_phi;
    p_22=deg_diff<sns.phi+env.objF_if_edge_a_phi;
    p_2=p_21.*p_22;
    p_31=deg_diff>=pi-sns.phi-env.objF_if_edge_a_phi;
    p_32=deg_diff<pi-sns.phi+env.objF_if_edge_a_phi;
    p_3=p_31.*p_32;
    p_41=deg_diff>=pi-sns.phi+env.objF_if_edge_a_phi;
    p_4=p_41;
    
    p_alpha=1/(2*env.objF_if_edge_a_phi);
    p_1=1*p_1;
    % p_1=((p_alpha*deg_diff)-p_alpha*(-sns.phi-env.objF_if_edge_a_phi)).*p_1;
    p_2=(-p_alpha.*deg_diff+(sns.phi+env.objF_if_edge_a_phi)/(2*env.objF_if_edge_a_phi)).*p_2;
    p_3=(p_alpha.*deg_diff+(sns.phi+env.objF_if_edge_a_phi-pi)/(2*env.objF_if_edge_a_phi)).*p_3;
    p_4=1*p_4;
    p_ans=p_1+p_2+p_3+p_4;
    
    J_kari=r_ans.*p_ans;
    J=(J_kari+env.objF_nonzero).^(-1);
    % J=-J_kari;
end