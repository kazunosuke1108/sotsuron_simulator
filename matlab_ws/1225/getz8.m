function z8=getz8(z)
    z8=zeros(8,length(z));
    z8([1:2],:)=z([1:2],:);
    z8([5:6],:)=z([4:5],:);
    th=z(3,:);
    omg=z(6,:);
    morethan90deg=th>pi/2;
    ph=th.*(1-morethan90deg)+pi/2*morethan90deg;
    th=0.*(1-morethan90deg)+(th-pi/2).*morethan90deg;
    ph_d=omg.*(1-morethan90deg);
    omg=omg.*morethan90deg;
    z8(3,:)=th;
    z8(4,:)=ph;
    z8(7,:)=omg;
    z8(8,:)=ph_d;

end