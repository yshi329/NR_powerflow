%% This is the GUI that help user input the data and calcultate the
% admitance matrix

%% Ask User the number of bus
%input:user input
%output:busnumber, linenumber
clear
prompt = {'Enter bus number:','Enter transmissionline number:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'4','4'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans)
input=str2num(char(answer))
busnumber = input(1)
linenumber = input(2)

        
%% Ask User to input linedata
%input: linenumber, userinput
%output: linedata(matrix)
arr_size = [linenumber,6];

if arr_size(2) < 2
    fig_dim = [arr_size(1)*25+60, 120];
else  
    fig_dim = [arr_size(1)*25+60, arr_size(2)*60+15]; %[y,x]
end
arr_fig = figure('unit','pixels','NumberTitle','off','Menubar','none','resize','on','position', [75 75 fig_dim(2) fig_dim(1)]);

ok_but = uicontrol('Style','pushbutton','unit','pixels','String','OK','position',[5 15 20 20],...
    'callback','uiresume','tag','ok');
cancel_but = uicontrol('Style','pushbutton','unit','pixels','String','Cancel','position',[35 15 40 20],...
    'callback','uiresume','tag','cancel');
bd_size = 5; %border size
posx = bd_size;
posx2 = posx;
posy = fig_dim(1)-20-bd_size;
bus_from=uicontrol('Style','text','unit','pixels','String','From bus','position', [posx posy 50 20]);
posx = posx+50+bd_size;
bus_to=uicontrol('Style','text','unit','pixels','String','To bus','position', [posx posy 50 20]);
posx = posx+50+bd_size;
R =uicontrol('Style','text','unit','pixels','String','R','position', [posx posy 50 20]);
posx = posx+50+bd_size;
X =uicontrol('Style','text','unit','pixels','String','X','position', [posx posy 50 20]);
posx = posx+50+bd_size;
B =uicontrol('Style','text','unit','pixels','String','B/2','position', [posx posy 50 20]);
posx = posx+50+bd_size;
B =uicontrol('Style','text','unit','pixels','String','tap','position', [posx posy 50 20]);
posx = bd_size;

posy = posy-20-bd_size;

for i = 1:arr_size(1)
    for j = 1:arr_size(2)
        a(i,j)=uicontrol('Style','edit','unit','pixels','position', [posx posy 50 20]);
        posx = posx+50+bd_size;
    end
    posx = posx2;
    posy = posy-20-bd_size;
end
uiwait;
but = gco;

if strcmp(get(but,'tag'),'ok')
    for i = 1:arr_size(1)
        for j = 1:arr_size(2)
            linedata(i,j) = str2num(get(a(i,j),'string'));
        end
    end
    close;    
else 
    close;
end
%linedata

%% Ask User to input Bus data
%input: bus number, user input
%output: busdata(matrix)
arr_size = [busnumber,5];

if arr_size(2) < 2
    fig_dim = [arr_size(1)*25+60, 120];
else  
    fig_dim = [arr_size(1)*25+60, arr_size(2)*60+15]; %[y,x]
end
arr_fig = figure('unit','pixels','NumberTitle','off','Menubar','none','resize','on','position', [75 75 fig_dim(2) fig_dim(1)]);

ok_but = uicontrol('Style','pushbutton','unit','pixels','String','OK','position',[5 15 20 20],...
    'callback','uiresume','tag','ok');
cancel_but = uicontrol('Style','pushbutton','unit','pixels','String','Cancel','position',[35 15 40 20],...
    'callback','uiresume','tag','cancel');
bd_size = 5; %border size
posx = bd_size;
posx2 = posx;
posy = fig_dim(1)-20-bd_size;
bus_to=uicontrol('Style','text','unit','pixels','String','Bus Type','position', [posx posy 50 20]);
posx = posx+50+bd_size;
bus_from=uicontrol('Style','text','unit','pixels','String','Bus_No','position', [posx posy 50 20]);
posx = posx+50+bd_size;
R =uicontrol('Style','text','unit','pixels','String','Voltage','position', [posx posy 50 20]);
posx = posx+50+bd_size;
X =uicontrol('Style','text','unit','pixels','String','P','position', [posx posy 50 20]);
posx = posx+50+bd_size;
B =uicontrol('Style','text','unit','pixels','String','Q','position', [posx posy 50 20]);
posx = bd_size;

posy = posy-20-bd_size;

for i = 1:arr_size(1)
    for j = 1:arr_size(2)
        if j ==1
            a(i,j)=uicontrol('Style','popup','unit','pixels','String',{'slack','PV','PQ'},'position', [posx posy 50 20]);
        elseif j==2
            a(i,j)=uicontrol('Style','text','unit','pixels','String',i,'position', [posx posy 50 20]); 
        else
            a(i,j)=uicontrol('Style','edit','unit','pixels','position', [posx posy 50 20]);
        end
        posx = posx+50+bd_size;
    end
    posx = posx2;
    posy = posy-20-bd_size;
end
uiwait;
but = gco;

if strcmp(get(but,'tag'),'ok')
    for i = 1:arr_size(1)
        for j = 1:arr_size(2)
            if j==1
                busdata(i,j)= get(a(i,j),'value'); %slak bus =1, PV bus =2, PQ bus = 3
            elseif j==2
                busdata(i,j)= i;
            else
                busdata(i,j) = str2num(get(a(i,j),'string'));
            end
        end
    end
    close;    
else 
    close;
end
%busdata
%% Classify Bus data
%input: busdata = [bus_type bus_number V P Q]
%output: slack PV_bus, PQ_bus

[m,n]=size(busdata);
% h =1;
% f =1;
% g=1;

nslack = 0;
npv = 0;
npq = 0;

for i = 1:m
    if busdata(i,1) == 1
        nslack = nslack+1;
        for j = 1:n
            slack(nslack,j) = busdata(i,j);
        end
    end
    
    if busdata(i,1) == 2
        npv = npv+1;
        for j = 1:n
            PV_bus(npv,j) = busdata(i,j);
        end
    end
    
    if busdata(i,1) == 3
        npq = npq+1;
        for j = 1:n
            PQ_bus(npq,j) = busdata(i,j);
        end
    end
end

slacktemp = 0;
pvtemp = 0;
pqtemp = 0;
for i = 1:m
    if busdata(i,1) == 1
        slacktemp = slacktemp+1;
        mapping(i) = slacktemp;
        invmapping(slacktemp) = i
    end
    if busdata(i,1) == 2
        pvtemp = pvtemp+1;
        mapping(i) = nslack+pvtemp;
        invmapping(nslack+pvtemp) = i;
    end
    if busdata(i,1) == 3
        pqtemp = pqtemp+1;
        mapping(i) = nslack+npv+pqtemp;
        invmapping(nslack+npv+pqtemp) = i;
    end
end

%new indexing linedata
linedata1 = linedata;
for i = 1:linenumber
    linedata(i,1) = mapping(linedata(i,1)); 
    linedata(i,2) = mapping(linedata(i,2));
end


% for i = 1:m
%     for j = 1:n
%         if busdata(i,1) ==1
%             slack(f,j) =busdata(i,j); 
%         elseif busdata(i,1) ==2
%             PV_bus(g,j)=busdata(i,j);
%             npv = npv+1;
%         else
%             PQ_bus(h,j)=busdata(i,j);
%             npq = npq+1;
%         end
%     end
%     if busdata(i,1) ==1
%         f=f+1;
%     elseif busdata(i,1) ==2
%         g=g+1;
%     else
%         h=h+1;
%         end
% end

nbus = npv+npq+1;

% 
% busdata=[3   1    1.0    -0.3   -0.18 
%          3   2    1.0       -0.55  -0.13 
%          2   3    1.1      0.5   0.0  
%          1   4    1.0       0.0   0.0    ];
%% Calculate admittance matrix
YBUStest
Ybus

% Ybus = [0.9346 - 4.2616i 0.0000 + 0.0000i -0.4539 + 1.8911i -0.4808 + 2.4038i
%  0.0000 + 0.0000i 0.0000 - 3.3333i 0.0000 + 3.6667i 0.0000 + 0.0000i
%  -0.4539 + 1.8911i 0.0000 + 3.6667i 1.0421 - 8.2429i -0.5882 + 2.3529i
%  -0.4808 + 2.4038i 0.0000 + 0.0000i -0.5882 + 2.3529i 1.0690 - 4.7274i];
% slack = [1.0000 4.0000 1.0500 0 0];
% PV_bus = [2.0000 3.0000 1.1000 0.5000 0];
% PQ_bus = [3.0000 1.0000 1.0000 -0.3000 -0.1800
%  3.0000 2.0000 1.0000 -0.5500 -0.1300];



%% NR
NRtest1


%% Output
output




