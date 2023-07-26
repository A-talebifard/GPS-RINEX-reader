function    data=GPSfileread(file_path)
% This is a MATLAB function called GPSfileread that reads a RINEX file and extracts the GPS data from it.
% The function uses a while loop to read the file line by line,
% and stores the relevant data in variables such as NOsatellite, SATELLITE_NAME, and OBSERVATION.
% After reading and processing the data, the function creates a table called data that contains the time,
% satellite name, and observation data. The table has the following columns: L1, L2, C1, P2, P1, S1, and S2.
% Overall, this function appears to be a useful tool for extracting GPS data from RINEX files in MATLAB.
%% written by A-Talebifard.
time='';
ii=0;
STEP_IF=0;
NOsatellite=[];
SATELLITE_NAME=[];
OBSERVATION=[];
TIME='';
BsTIME='';
fid=fopen(file_path,'r');
while true
    ll=fgetl(fid);
    if ll==' '
        break
    end
    L=[ll '                    '];
    switch STEP_IF
        case 0
            if strcmp(L(61:63),'# /')==1
                detailsOFobservation=L(6:48);
                NofOBserv=str2num(detailsOFobservation(1));
                Oservs=split(detailsOFobservation(6:43),"    ")';
                nlo=ceil(NofOBserv/5);
                STEP_IF=1;
            end
        case 1 %%date
            if strcmp(L(33),'G')==1
                nn=str2double(L(31:32));
                NOsatellite=[NOsatellite;nn];
                t=L(2:26);
                time=[time;t];
                ss=split(replace(L(34:end),' ',''),"G");
                SATELLITE_NAME=[SATELLITE_NAME;ss];
                STEP_IF=2;
                ii=1;
            end
        case 2
            switch rem(ii,2)
                case 0 %% zoj
                    switch size(str2num(L),2)
                        case 0
                            o(1,6:7)=[0 0];
                            OBSERVATION=[OBSERVATION;o];
                        case 1
                            switch size(str2num(L(2:14)),2)
                                case 0
                                    o(1,6:7)=[0 str2num(L(18:30))];
                                    OBSERVATION=[OBSERVATION;o];
                                case 1
                                    o(1,6:7)=[str2num(L(2:14)) 0];
                                    OBSERVATION=[OBSERVATION;o];
                            end
                        case 2
                            o(1,6:7)=[str2num(L(2:14)) str2num(L(18:30))];
                            OBSERVATION=[OBSERVATION;o];
                    end
                otherwise
                    o(1,1:5)=[str2num(L(2:14)) str2num(L(18:30)) str2num(L(35:46)) str2num(L(51:62)) str2num(L(67:78))];
            end
            ii=ii+1;
            if ii==nlo*NOsatellite(end)+1
                STEP_IF=1;
            end
    end
end
%%
for i=1:size(SATELLITE_NAME,1)
    Gmat(i,1)='G';
end
SATELLITE_NAME=[Gmat char(SATELLITE_NAME)];
%% L1    L2    C1    P2    P1    S1    S2
Oservs=char(Oservs);
for i=1:size(time,1)
    for j=1:NOsatellite(i);
        BsTIME=time(i,:);
        TIME=[TIME;BsTIME];
    end
end
data=[table(TIME) table(SATELLITE_NAME) table(OBSERVATION(:,1),OBSERVATION(:,2),OBSERVATION(:,3),OBSERVATION(:,4),OBSERVATION(:,5),OBSERVATION(:,6),OBSERVATION(:,7),'VariableNames',{Oservs(1,1:2),Oservs(2,1:2),Oservs(3,1:2),Oservs(4,1:2),Oservs(5,1:2),Oservs(6,1:2),Oservs(7,1:2)})];
end
