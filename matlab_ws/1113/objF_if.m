function J=objF_if(t,z,u,env,rbt,hmn,sns,objF_if_edge_a)

    % objF_if_edge_a は小さいほど傾斜がきつくなる

    phi_powerup=1/5;
    
    hmn_path=getHumanPath(t,hmn);
    rbt_path=z;
    
    vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[rbt_path(1,:);rbt_path(2,:)];
    norm_HR=vecnorm(vec_HR,length(vec_HR(1)),1);
    
    e=[cos(z(3,:));sin(z(3,:))];
    naiseki=dot(e,vec_HR,1);
    
    e_vec_th=acos(naiseki./norm_HR);
    e_vec_th=rem(e_vec_th,2*pi);
    
    r_11=norm_HR<sns.r1-objF_if_edge_a;
    r_1=r_11;
    r_21=norm_HR>=sns.r1-objF_if_edge_a;
    r_22=norm_HR<sns.r1+objF_if_edge_a;
    r_2=r_21.*r_22;
    r_31=norm_HR>=sns.r1+objF_if_edge_a;
    r_32=norm_HR<sns.r2-objF_if_edge_a;
    r_3=r_31.*r_32;
    r_41=norm_HR>=sns.r2-objF_if_edge_a;
    r_42=norm_HR<sns.r2+objF_if_edge_a;
    r_4=r_41.*r_42;
    
    r_1=-1*r_1;
    r_2=(1/objF_if_edge_a*norm_HR-sns.r1/objF_if_edge_a).*r_2;
    r_3=1*r_3;
    r_4=(-1/objF_if_edge_a*norm_HR+sns.r2/objF_if_edge_a).*r_4;
    r_ans=r_1+r_2+r_3+r_4;
    
    
    p_11=e_vec_th>=-sns.phi-objF_if_edge_a/phi_powerup;
    p_12=e_vec_th<-sns.phi+objF_if_edge_a/phi_powerup;
    p_1=p_11.*p_12;
    p_21=e_vec_th>=-sns.phi+objF_if_edge_a/phi_powerup;
    p_22=e_vec_th<sns.phi-objF_if_edge_a/phi_powerup;
    p_2=p_21.*p_22;
    p_31=e_vec_th>=sns.phi-objF_if_edge_a/phi_powerup;
    p_32=e_vec_th<sns.phi+objF_if_edge_a/phi_powerup;
    p_3=p_31.*p_32;
    
    p_alpha=0.5*phi_powerup/objF_if_edge_a;
    p_1=((p_alpha*e_vec_th)-p_alpha*(-sns.phi-objF_if_edge_a/phi_powerup)).*p_1;
    p_2=1*p_2;
    p_3=(-(p_alpha*e_vec_th)-p_alpha*(sns.phi+objF_if_edge_a/phi_powerup)).*p_3;
    p_ans=p_1+p_2+p_3;

    p_11=e_vec_th>=2*pi-sns.phi-objF_if_edge_a/phi_powerup;
    p_12=e_vec_th<2*pi-sns.phi+objF_if_edge_a/phi_powerup;
    p_1=p_11.*p_12;
    p_21=e_vec_th>=2*pi-sns.phi+objF_if_edge_a/phi_powerup;
    p_22=e_vec_th<2*pi+sns.phi-objF_if_edge_a/phi_powerup;
    p_2=p_21.*p_22;
    p_31=e_vec_th>=2*pi+sns.phi-objF_if_edge_a/phi_powerup;
    p_32=e_vec_th<2*pi+sns.phi+objF_if_edge_a/phi_powerup;
    p_3=p_31.*p_32;
    p_ans=p_ans+p_1+p_2+p_3;
    
    J_kari=r_ans.*p_ans;
    J=(J_kari+env.objF_nonzero).^(-1);
    % J=-J_kari;
end