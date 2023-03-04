function [z10,u5]=getz10(z,u,LRF_mode)
    z10=zeros(10,length(z));
    u5=zeros(5,length(u));
    z10([1:2],:)=z([1:2],:);
    z10([6:7],:)=z([5:6],:);
    u5([1:2],:)=u([1:2],:);
    % th=z(3,:);
    % omega=z(6,:);
    % ph=(th.*(1-morethan90deg)+pi/2*morethan90deg);
    % th=0.*(1-morethan90deg)+(th-pi/2).*morethan90deg;
    theta=z(3,:);
    theta_tlt=z(4,:);
    omega=z(7,:);
    omega_tlt=z(8,:);
    acc_th=u(3,:);
    acc_th_tlt=u(4,:);
    morethan90deg=theta>pi/2;
    morethan_m_90deg=theta<-pi/2;
    % morethan90deg=th>pi/2;
    % morethan_m_90deg=th<-pi/2;
    % ph=(th.*(1-morethan90deg)+pi/2*morethan90deg);
    % th=0.*(1-morethan90deg)+(th-pi/2).*morethan90deg; 
    % 首だけ
    if LRF_mode
        th=theta;
        ph=zeros(1,length(th));
        omega=omega;
        ph_d=zeros(1,length(omega));
        acc_th=acc_th;
        acc_ph=zeros(1,length(acc_th));
    else
        ph=theta.*(1-morethan90deg).*(1-morethan_m_90deg)+pi/2.*morethan90deg-pi/2.*morethan_m_90deg;
        th=0.*(1-morethan90deg).*(1-morethan_m_90deg)+(theta-pi/2).*morethan90deg+(theta+pi/2).*morethan_m_90deg;
        ph_d=omega.*(1-morethan90deg).*(1-morethan_m_90deg)+0.*morethan90deg+0.*morethan_m_90deg;
        omega=0.*(1-morethan90deg).*(1-morethan_m_90deg)+omega.*morethan90deg+omega.*morethan_m_90deg;
        acc_ph=acc_th.*(1-morethan90deg).*(1-morethan_m_90deg)+0.*morethan90deg+0.*morethan_m_90deg;
        acc_th=0.*(1-morethan90deg).*(1-morethan_m_90deg)+acc_th.*morethan90deg+acc_th.*morethan_m_90deg;;
    end    
    z10(3,:)=th; % 台車
    z10(4,:)=ph; % 首
    z10(5,:)=theta_tlt;
    z10(8,:)=omega;
    z10(9,:)=ph_d;
    z10(10,:)=omega_tlt;
    u5(3,:)=acc_th;
    u5(4,:)=acc_ph;
    u5(5,:)=acc_th_tlt;

end