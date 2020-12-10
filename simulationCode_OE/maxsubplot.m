function maxsubplot(rows,cols,i,fac)

%Create subplots that are much larger than that produced by the standard subplot command,

%Good for plots with no axis labels, tick labels or titles.

if nargin<4, fac=0.05; end



%*NOTE*, unlike subplot new axes are drawn on top of old ones; use clf first

%if you don't want this to happen.



%*NOTE*, unlike subplot the first axes are drawn at the bottom-left of the

%window.



%axes('Position',[fix((i-1)/rows)/cols,rem(i-1,rows)/rows,0.95/cols,0.95/rows]); 

axes('Position',[(fac/2)/cols+(cols-1-rem(i-1,cols))/cols,(fac/2)/rows+fix((i-1)/cols)/rows,(1-fac)/cols,(1-fac)/rows]); 



%  axis('equal','tight'); set(gca,'XTick',[],'YTick',[]); colormap('gray');

