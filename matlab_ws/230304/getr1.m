function r1=getr1(t,z,u,env,rbt,hmn,sns)
    
    % th_tlt=z(4,:)
    % r1_bottom=sns.h./tan(sns.pitch-th_tlt)
    % r1_upper=(hmn.h-sns.h)./tan(sns.pitch+th_tlt)
    % upper_bigger=r1_upper>r1_bottom
    % r1=r1_upper.*upper_bigger+r1_bottom.*(1-upper_bigger);    
    r1=sns.r1;

end