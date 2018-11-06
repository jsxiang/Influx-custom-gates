clear
% basic plan is to import the .xml file as a text
% find the gate p3 (after selecting for viable and singlets)
% get the vertices and just replace vertices
% input .xml file should have all the gates already created

% what's the name of the gate for getting vertices from and repalcing vertices with,
% followed by the names of the other gates to replace their vertices
namegates={'P3','P4','P5','P6','P7','P8'};
numgates=length(namegates)+1;

fid=fopen('configuration.xml','r');
g=fgets(fid); % get the next line from file
gate{1}=g;

% get every line from .xml file into a character array
while 1
    g=fgets(fid);
    if g==-1
        break
    end
    gate{end+1}=g;
end

fclose(fid);
%% get vertices from the starting gate P3

[gatetofollow,gatetostart]=getvertices(gate,namegates);
%% Generate new vertices
vertices=drawgates(gatetostart.x,gatetostart.y,numgates);


%% replace vertices

clear newgate;
newgate=struct;

for i=1:length(namegates)
    % Copy from gate
    if i==1
        for j=1:13
            newgate(end+1).line=gate{gatetostart.index(1)+j-1};        
        end
    else
        for j=1:13
            newgate(end+1).line=gate{gatetofollow.index(i,1)+j-1};   
        end
    end
    % replace vertices
    for k=1:length(vertices(i).xcoord)
        newgate(end+1).line=sprintf('%s\r\n','                <Vertex>');
        newgate(end+1).line=sprintf('                  <X>%0.4f</X>\r\n',vertices(i).xcoord(k));
        newgate(end+1).line=sprintf('                  <Y>%0.4f</Y>\r\n',vertices(i).ycoord(k));
        newgate(end+1).line=sprintf('%s\r\n','                </Vertex>');
    end
    newgate(end+1).line=gate(gatetostart.index(2));
end


%% create a new xml with the newly generated gates
fid=fopen('newGate.xml','w');

for i=1:gatetostart.index(1)-1
    fprintf(fid,'%s',gate{i});
end

for i=1:length(newgate)
    fprintf(fid,'%s',char(newgate(i).line));
end

for i=(gatetofollow.index(end,2)+1):length(gate)
    gate{i};
    fprintf(fid,'%s',gate{i});
end
        
fclose(fid);

%% visualize
plotnewgates(vertices)

%% 
%% END











