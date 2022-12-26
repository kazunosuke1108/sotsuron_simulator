function sns=getSensorParams()

    sns.h=1.0;
    
    sns.phi=86;
    % sns.phi=58;
    sns.pitch=57;
    % sns.pitch=45;
    sns.r0=6.0;
    sns.r2=6.0;
    
    sns.phi=deg2rad(sns.phi)/2;
    sns.pitch=deg2rad(sns.pitch)/2;
    sns.r1=sns.h/tan(sns.pitch);

end