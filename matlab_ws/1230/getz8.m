function z8=getz8(z)
    z8=zeros(8,length(z));
    z8([1:2],:)=z([1:2],:);
    z8([5:6],:)=z([4:5],:);
    % th=z(3,:);
    % omega=z(6,:);
    % ph=(th.*(1-morethan90deg)+pi/2*morethan90deg);
    % th=0.*(1-morethan90deg)+(th-pi/2).*morethan90deg;
    theta=z(3,:);
    omega=z(6,:);
    morethan90deg=theta>pi/2;
    morethan_m_90deg=theta<-pi/2;
    % morethan90deg=th>pi/2;
    % morethan_m_90deg=th<-pi/2;
    % ph=(th.*(1-morethan90deg)+pi/2*morethan90deg);
    % th=0.*(1-morethan90deg)+(th-pi/2).*morethan90deg; 
    % 首だけ
    ph=theta.*(1-morethan90deg).*(1-morethan_m_90deg)+pi/2.*morethan90deg-pi/2.*morethan_m_90deg;
    th=0.*(1-morethan90deg).*(1-morethan_m_90deg)+(theta-pi/2).*morethan90deg+(theta+pi/2).*morethan_m_90deg;
    ph_d=omega.*(1-morethan90deg).*(1-morethan_m_90deg)+0.*morethan90deg+0.*morethan_m_90deg;
    omega=0.*(1-morethan90deg).*(1-morethan_m_90deg)+omega.*morethan90deg+omega.*morethan_m_90deg;;
    
    z8(3,:)=th;
    z8(4,:)=ph;
    z8(7,:)=omega;
    z8(8,:)=ph_d;

end