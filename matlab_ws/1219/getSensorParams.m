function sns=getSensorParams()

    sns.phi=86;
    sns.phi=deg2rad(sns.phi)/2;
    
    sns.h=1.0;
    sns.r0=6.0;
    sns.r1=sns.h/tan(sns.phi);
    sns.r2=6.0;

end