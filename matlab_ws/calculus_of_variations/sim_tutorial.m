syms g y(x)
assume(g,'positive')
f = sqrt((1 + diff(y)^2)/(2*g*y));
eqn = functionalDerivative(f,y) == 0;
eqn = simplify(eqn)
sols = dsolve(eqn,'Implicit',true)