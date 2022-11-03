filename_map_mp4 = string("results\"+datestr(now,'yymmdd_hhMMss')+"_map.mp4");
fig3 = figure(3); clf;
frames3(length(x_plot)) = struct('cdata', [], 'colormap', []);
map_x=linspace(xmin,xmax);
map_y=linspace(ymin,ymax);
[X,Y]=meshgrid(map_x, map_y);

Z=objF_nd_Plot(x_plot(1),y_plot(1),th_plot(1),X,Y,c);
func_map=contourf(X,Y,Z,10);

xlim([xmin,xmax]);
ylim([ymin,ymax]);
daspect([1,1,1]);

for i = 1:length(x_plot)
    Z=objF_nd_Plot(x_plot(i),y_plot(i),th_plot(i),X,Y,c);
    func_map=contourf(X,Y,Z,10);
    daspect([1,1,1]);
    drawnow;
    frames3(i)=getframe(fig3);
end
video3=VideoWriter(filename_map_mp4,'MPEG-4');
open(video3)
writeVideo(video3, frames3);
close(video3)