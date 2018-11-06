function [gatetofollow,gatetostart]=getvertices(gate,namegates)
gatesstart=[];
gatesend=[];
for i=1:length(gate)-1
    tline=gate{i};
    if ~isempty(regexp(tline,'<Gates Version="1">','ONCE'))
        gatesstart(end+1)=i;
    end
    if ~isempty(regexp(tline,'</Gates>','ONCE'))
        gatesend(end+1)=i;
        break
    end
end
gatestart=[];
gateend=[];
for i=gatesstart:gatesend
    tline=gate{i};
    if ~isempty(regexp(tline,'<Gate>','ONCE'))
        gatestart(end+1)=i;
    end
    if ~isempty(regexp(tline,'</Gate>','ONCE'))
        gateend(end+1)=i;
        
    end
end

gfollowindex=[0 0];
for i=1:length(gatestart)
    for j=gatestart(i):gateend(i)
        if ~isempty(regexp(gate{j},sprintf('<Name>%s</Name>',namegates{1})))
            gatewantedindex=[gatestart(i) gateend(i)];
        end
        for k=2:length(namegates)
            if ~isempty(regexp(gate{j},sprintf('<Name>%s</Name>',namegates{k})))
            gfollowindex(end+1,:)=[gatestart(i) gateend(i)];
            end
        end
    end
end

x=[];
y=[];
vxindex=[];
vyindex=[];
for i=gatewantedindex(1):gatewantedindex(2)
    if ~isempty(regexp(gate{i},'<X>-?[0-9]\.[0-9]+</X>'))
        indstart=regexp(gate{i},'-?[0-9]\.');
        indend=regexp(gate{i},'</X>')-1;
        x(end+1)=str2num(gate{i}(indstart:indend));
        vxindex(end+1)=i;
    end
    if ~isempty(regexp(gate{i},'<Y>-?[0-9]\.[0-9]+</Y>'))
        indstart=regexp(gate{i},'-?[0-9]\.');
        indend=regexp(gate{i},'</Y>')-1;
        y(end+1)=str2num(gate{i}(indstart:indend));
        vyindex(end+1)=i;
    end
    
end

% y(2)=y(2)-0.5;
% y(1)=y(1)-0.4;
x(1)=x(1)+0.8;
x(4)=x(4)+0.8;

gatetostart.index=gatewantedindex;
gatetostart.x=x;
gatetostart.y=y;
gatetostart.vxindex=vxindex;
gatetostart.vyindex=vyindex;
gatetofollow.index=gfollowindex;

end