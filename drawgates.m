function [vertices]=drawgates(x,y,numgates)
slCharacterEncoding('UTF-8');
% landscape=1;
xbounds=[0 4];
ybounds=[0 4.2];
signalhigh=1;


%% generate and plot vertices
% if given four verteces, divide into 12 or numgates bins

plot(x,y,'o','MarkerSize',30)

x1=max(x);
x0=min(x);
y1=max(y);
y0=min(y);

c=y0-x0;

if signalhigh
    ysorted=sort(y);
    yleftbound=ysorted(end-2); % assuming the second highest y value
    
    cmax=yleftbound-x0;
    xleftbound= y0-cmax;    % x extended from yleftbound vertex
    xint=(x1-xleftbound)/(numgates-2);
    xt0=([x0 x0 y1-cmax]); % top left triangular gate
    yt0=([yleftbound y1 y1]);
    
else
    xleftbound=x0;
    cmax=c;
    xint=(x1-x0)/(numgates-2);
    xt0=([x0 x0 y1-c]); % top left triangular gate
    yt0=([y0 y1 y1]);
end

if isempty(xbounds)
    xt1=([x1 y1-c+numgates*xint y1-c+numgates*xint ]); % bottom right triangular gate
    yt1=([y0 y1 y0]);
elseif max(xbounds)<(y1-c+numgates*xint)
    yt1=([y0 y0+(y1-y0)/(y1-c-x0)*(max(xbounds)-x1) y0]);
    xt1=([x1 max(xbounds) max(xbounds) ]); % bottom right triangular gate
end
lboundx=([xleftbound y1-cmax y1-cmax+xint xleftbound+xint]);
lboundy=([y0 y1 y1 y0]);

for i=1:numgates

    if mod(i,2) >0
        cl=[0.8 0.8 0.8];
    else
        cl='k';
    end
    
    xcoord=[];
    ycoord=[];
    
    if i==1
        xcoord=xt0;
        ycoord=yt0;
    elseif i==numgates
        xs=xt1;
        ys=yt1;
        ycoord=[ys min(ybounds) min(ybounds) y0];
        xcoord=[xs xs(end) x0 x0];
    else
        if isempty(xbounds)
            ycoord=lboundy;
            xcoord=lboundx+xint*(i-2);
        else
            xs=lboundx+xint*(i-2);
            ys=lboundy;
            if abs(sum(xs<x0)-1)<1e-3 && abs(sum(xs>max(xbounds))-1)<1e-3
                ys(xs<x0)=x0+cmax-xint*(i-2);
                xs(xs<x0)=x0;
                ys(xs>max(xbounds))=max(xbounds)+cmax-xint*(i-1);
                xs(xs>max(xbounds))=max(xbounds);
                ycoord=[y0 ys(1:2) y1 ys(end-1:end)];
                xcoord=[x0 xs(1:2) max(xbounds) xs(end-1:end)];
            elseif abs(sum(xs<x0)-2)<1e-3 && abs(sum(xs>max(xbounds))-2)<1e-3
                ys(xs<x0)=[x0+cmax-xint*(i-2) x0+cmax-xint*(i-1)];
                xs(xs<x0)=x0;
                ys(xs>max(xbounds))=[max(xbounds)+cmax-xint*(i-2)...
                                     max(xbounds)+cmax-xint*(i-1)];
                xs(xs>max(xbounds))=max(xbounds);
                ycoord=ys;
                xcoord=xs;
            elseif abs(sum(xs<x0)-1)<1e-3 && abs(sum(xs>max(xbounds))-2)<1e-3
                ys(xs<x0)=x0+cmax-xint*(i-2);
                xs(xs<x0)=x0;
                ys(xs>max(xbounds))=[max(xbounds)+cmax-xint*(i-2)...
                                     max(xbounds)+cmax-xint*(i-1)];
                xs(xs>max(xbounds))=max(xbounds);
                ycoord=[y0 ys(1:2) ys(end-1:end)];
                xcoord=[x0 xs(1:2) xs(end-1:end)];
            elseif abs(sum(xs<x0)-2)<1e-3 && abs(sum(xs>max(xbounds))-1)<1e-3
                ys(xs<x0)=[x0+cmax-xint*(i-2) x0+cmax-xint*(i-1)];
                xs(xs<x0)=x0;
                ys(xs>max(xbounds))=max(xbounds)+cmax-xint*(i-1);
                xs(xs>max(xbounds))=max(xbounds);
                ycoord=[ys(1:2) y1 ys(end-1:end)];
                xcoord=[xs(1:2) max(xbounds) xs(end-1:end)];
            elseif abs(sum(xs<x0)-1)<1e-3
                ys(xs<x0)=x0+cmax-xint*(i-2);
                xs(xs<x0)=x0;
                ycoord=[y0 ys];
                xcoord=[x0 xs];
            elseif abs(sum(xs>max(xbounds))-1)<1e-3
                ys(xs>max(xbounds))=max(xbounds)+cmax-xint*(i-1);
                xs(xs>max(xbounds))=max(xbounds);
                ycoord=[ys(1:2) y1 ys(end-1:end)];
                xcoord=[xs(1:2) max(xbounds) xs(end-1:end)];
            elseif abs(sum(xs<x0)-2)<1e-3
                ys(xs<x0)=[x0+cmax-xint*(i-2) x0+cmax-xint*(i-1)];
                xs(xs<x0)=x0;
                ycoord=ys;
                xcoord=xs;
            elseif abs(sum(xs>max(xbounds))-2)<1e-3
                ys(xs>max(xbounds))=[max(xbounds)+cmax-xint*(i-2)...
                                     max(xbounds)+cmax-xint*(i-1)];
                xs(xs>max(xbounds))=max(xbounds);
                ycoord=ys;
                xcoord=xs;
            else
                ycoord=ys;
                xcoord=xs;
            end
            
            
        end
    end
    
    plot([xcoord xcoord(1)],[ycoord ycoord(1)],'color',cl,'LineWidth',2)
    vertices(i).xcoord=xcoord;
    vertices(i).ycoord=ycoord;
  

end

hold off
xlabel('log10(BFP) with scaling')
ylabel('log10(mCherry) with scaling')
set(gca,'FontSize',16)
set(gca,'LineWidth',2)

axis([0 5 0 4.5])
end



