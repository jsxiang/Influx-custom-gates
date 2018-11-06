function plotnewgates(vertices)

d=load('data.mat');
data=d.data;

% %% find length ratio of the bounded gates
% l=[vEVEN(3).xcoord([1 4]);vODD(4).xcoord([1 4]);vEVEN(4).xcoord([1 4]);vODD(5).xcoord([1 4])];
% fracXAuto=(mean(l,2)-vEVEN(1).xcoord(1))/(4.0-vEVEN(1).xcoord(1));
% mu=mean([vEVEN(1).xcoord(1) 4.0]);


% find distribution
% plot an actual library data
% filenames={'1-1','2-1','3-1','4-1','5-1','6-1','7-1','8-1','9-1','10-1',...
%            '11-1','12-1','13-1','14-1','15-1','16-1','17-1','18-1','19-1'};
% %  
% filenames={'1-1','2-1','2-2','3-1','4-1','5-1'};
%  
% setfig('Carmen');clf
% for i=1:length(filenames)
% filepath=strcat('/Volumes/smolke-lab$/Joy/Carmen/20160314/',filenames{i},'.fcs');
% fcsdat = fca_readfcs(filepath);
% ssc=fcsdat(:,2);
% fsc=fcsdat(:,4);
% BFP=fcsdat(:,19);
% mCherry=fcsdat(:,21);
% GFP=fcsdat(:,10);
% data(i).ssc=ssc;
% data(i).fsc=fsc;
% data(i).BFP=BFP;
% data(i).mCherry=mCherry;
% data(i).GFP=GFP;
% 
% % there's some weird scaling for the data that comes out from the BD
% % software, because it never fits with the vertices
% iscalefactor=0.7e-4;
% oscalefactor=6.0;
% 
% hold on
% 
%     plot(data(i).BFP(1:8000)*6.0606e-05,data(i).mCherry(1:8000)*6.0606e-05,'.')
% end
% axis([-0.5 5 -0.5 5])
% set(gca,'color','none') % set background color to be transparent
% 
% save('data.mat','data')
thresh=vertices(1).xcoord(1);
    
%% 

n=5000;
bmat=zeros(5,n);
mCmat=zeros(5,n);
fmat=zeros(4,1);
estcdf=fmat;
bAll=[];
mCAll=[];
for i=1:5
    
    b=data(i).BFP*6.0606e-05;
    mC=data(i).mCherry*6.0606e-05;
    transduced=b>thresh;
    tb=b(transduced);
    tmC=mC(transduced);
    bmat(i,:)=tb(1:n);
    mCmat(i,:)=tmC(1:n);
    
    bAll=[bAll b];
    mCAll=[mCAll mC];
    
    
end

bsum=mean(bmat);
mCsum=mean(mCmat);


    
%% rescale the bincounts with the ksdensity distribution

bmatAll=[bmat(1,:)';bmat(2,:)';bmat(3,:)';bmat(4,:)';bmat(5,:)'];
mCmatAll=[mCmat(1,:)';mCmat(2,:)';mCmat(3,:)';mCmat(4,:)';mCmat(5,:)'];

mumatAll=mCmatAll./bmatAll;

    
%% get the range of gradients aka mCherry/BFP from each bin

bmatAll=bAll(bAll>min(vertices(1).xcoord));
mCmatAll=mCAll(bAll>min(vertices(1).xcoord));

mbounds=[];
for i=2:3
    bin=[vertices(i).xcoord([1 2])' vertices(i).ycoord([1 2])'];
    [m,c]=polyfit(bin(:,1),bin(:,2),1);
    mbounds(end+1)=m(2);
end

mbound_diff=mbounds(1)-mbounds(2);
for i=1:7
    mbounds(end+1)=mbounds(end)-mbound_diff;
end

%%

carmendata=struct;
i=1;
y=bmatAll+mbounds(i);
carmendata(1).ind=mCmatAll>y;
for i=2:length(mbounds)
    y=bmatAll+mbounds(i);
    y_1=bmatAll+mbounds(i-1);
    carmendata(end+1).ind=(mCmatAll>y).*(mCmatAll<y_1).* (mCmatAll > min(vertices(5).ycoord));    
end


carmendata(end+1).ind=(mCmatAll<y) | (mCmatAll < min(vertices(5).ycoord));


binfreq=[];
for i=1:length(carmendata)
    binfreq(end+1)=sum(carmendata(i).ind);
end

setfig('bin carmen data');clf
plot(bAll,mCAll,'.','MarkerSize',6,'Color',[0.7 0.7 0.7])

cmap=colormap(cool);
cmap=cmap(end:-1:1,:);
cmapinterv=floor(length(cmap(:,1))/length(binfreq));
cint=1.0/length(binfreq);

for i=1:length(vertices)
    hold on
    plot(bmatAll(find(carmendata(i).ind)),mCmatAll(find(carmendata(i).ind)),'.',...
         'Color',[1-cint*i 0 cint*i],'MarkerSize',5);
     
    xcoord=vertices(i).xcoord;
    ycoord=vertices(i).ycoord;
    plot([xcoord xcoord(1)],[ycoord ycoord(1)],'-','color',[1-cint*i 0 cint*i],'LineWidth',2)

end

axis([0 4 0 4])
set(gca,'Color','none')
set(gca,'linewidth',1.5)
set(gca,'FontSize',14)
xlabel('BFP')
ylabel('mCherry')




end