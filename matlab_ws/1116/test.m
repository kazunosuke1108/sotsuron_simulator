test_x=[0 0 1 0 0.1]
test_y=[1 0 1 1 1]
for i = 1:length(test_x)
    if not(test_x(i)==0 & test_y(i)==0)
        disp(test_x(i)+" "+test_y(i))
    end
end