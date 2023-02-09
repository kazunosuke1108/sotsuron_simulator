function sns=getSensorParams()

    sns.h=0.9;
    
    sns.phi=86;
    % sns.phi=58;
    sns.pitch=57;
    % sns.pitch=86;
    % sns.pitch=45;
    sns.r0=6.0;
    sns.r2=6.0;
    
    sns.phi=deg2rad(86)/2;
    sns.pitch=deg2rad(57)/2;
    sns.r1=0.9/tan(deg2rad(57)/2);

end