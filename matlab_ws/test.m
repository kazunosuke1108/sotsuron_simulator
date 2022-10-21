syms u v x y z
F = @(x,y,z) log (x.^2-2.*y) - z;
x = @(u,v)u+v;
y = @(v)exp(v);
F = subs(F)
Error using symengine
Arithmetical expression expected.
Error in sym/subs>mupadsubs (line 160)
G = mupadmex('symobj::fullsubs',F.s,X2,Y2);
Error in sym/subs (line 145)
    G = mupadsubs(F,X,Y);
Error in subs (line 68)
    r_unique_name = subs(sym(f_unique_name),varargin{:});