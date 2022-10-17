from sympy import *

# sympyの有効性（特に変分まわり）を検証するため、最速降下問題を実装する

init_printing()

x=Symbol('x')
g=Symbol('g')
h=Symbol('h')

u=x**2

F=sqrt((1+diff(u,x)**2)/(2*g*u))

print(diff(F,u))