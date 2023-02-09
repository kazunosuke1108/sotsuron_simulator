function Color = getDefaultPlotColors()
% Color = getDefaultPlotColors()
%
% Returns a matrix where each row is one of the Matlab's default plotting
% colors
%
% OUTPUTS:
%   Color = [7,3] = [color1; color2; ... colorN] = [R,G,B] 
%
% NOTES:
%   Works by plotting 7 dummy lines and then reading the color of each line
%   into the matrix.
%

n = 7;  %Number of unique colors in matlab's default line color pallet

Color = zeros(n,3);
hFig = figure('visible','off'); 
hold on;

for i=1:n
   hLine = plot(rand(1,2),rand(1,2));
   Color(i,:) = get(hLine,'Color');
end

close(hFig);

end