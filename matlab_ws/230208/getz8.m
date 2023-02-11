function [z8,u4]=getz8(z,u,LRF_mode)
    z8=zeros(8,length(z));
    u4=zeros(4,length(u));
    z8([1:2],:)=z([1:2],:);
    z8([5:6],:)=z([4:5],:);
    u4([1:2],:)=u([1:2],:);
    % th=z(3,:);
    % omega=z(6,:);
    % ph=(th.*(1-morethan90deg)+pi/2*morethan90deg);
    % th=0.*(1-morethan90deg)+(th-pi/2).*morethan90deg;
    theta=z(3,:);
    omega=z(6,:);
    acc_angle=u(3,:);
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
        acc_th=acc_angle;
        acc_ph=zeros(1,length(acc_th));
    else
        ph=theta.*(1-morethan90deg).*(1-morethan_m_90deg)+pi/2.*morethan90deg-pi/2.*morethan_m_90deg;
        th=0.*(1-morethan90deg).*(1-morethan_m_90deg)+(theta-pi/2).*morethan90deg+(theta+pi/2).*morethan_m_90deg;
        ph_d=omega.*(1-morethan90deg).*(1-morethan_m_90deg)+0.*morethan90deg+0.*morethan_m_90deg;
        omega=0.*(1-morethan90deg).*(1-morethan_m_90deg)+omega.*morethan90deg+omega.*morethan_m_90deg;
        acc_ph=acc_th.*(1-morethan90deg).*(1-morethan_m_90deg)+0.*morethan90deg+0.*morethan_m_90deg;
        acc_th=0.*(1-morethan90deg).*(1-morethan_m_90deg)+acc_th.*morethan90deg+acc_th.*morethan_m_90deg;;
    end    
    z8(3,:)=th; % 台車
    z8(4,:)=ph; % 首
    z8(7,:)=omega;
    z8(8,:)=ph_d;
    u4(3,:)=acc_th;
    u4(4,:)=acc_ph;

end