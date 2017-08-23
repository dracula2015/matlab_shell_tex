function expMainFunction2_0(source,eventdata)
%% ===== Initial parameters
global startFlag stopFlag pauseFlag s theClient P;
stopFlag = false;
pauseFlag = false;
Parameters;
style={'k-','b--','g-.','r:','m:'};

P.dt=[];
P.instantTime=[];
P.speed=0.1;
P.rectLength=1;

P.iaeExp=[];
P.iaeSim=[];

P.gp=0;
P.lambdan=[5,10,100];
P.lambda=100;
P.NPIDKP=[0;0;0];
P.BASCIKP=[0;0;0];
P.ctrlVolt=[0;0;0];

P.QD=[0;0;0];
P.DQD=[0;0;0];
P.DDQD=[0;0;0];
P.QN=[0;0;0];
P.DQN=[0;0;0];
P.DDQN=[0;0;0];
P.NZ1=[0;0;0];
P.NZ2=[0;0;0];
P.NZ3=[0;0;0];
P.U=[0;0;0];
P.NU=[0;0;0];
P.F=[0;0;0];
P.T=0;
P.K=[0;0;0];
P.STATEST=[0;0;0;0;0;0];
P.time=[];

%% Initialize Figure
set(0, 'defaultfigurecolor', 'w')
%% Add event listener
usePollingLoop = false;         % approach 1 : poll for mocap data in a tight loop using GetLastFrameOfData
usePollingTimer = false;        % approach 2 : poll using a Matlab timer callback ( better for UI based apps )
useFrameReadyEvent = true;      % approach 3 : use event callback from NatNet (no polling)
% F0=figure('name','OptiTrack NatNet Matlab Controller','NumberTitle','off');
try  
    %experiment initial time
    %     frameOfData=theClient.GetLastFrameOfData();
    %     initialFrameTime=frameOfData.fLatency;
    
    % get the mocap data
    if(usePollingTimer)
        % approach 2 : poll using a Matlab timer callback ( better for UI based apps )
        framePerSecond = 200;   % timer frequency
        TimerData = timer('TimerFcn', {@TimerCallback,theClient},'Period',1/framePerSecond,'ExecutionMode','fixedRate','BusyMode','drop');
        start(TimerData);
        % wait until figure is closed
        uiwait(F0);
    else
        if(usePollingLoop)
            % approach 1 : get data by polling - just grab 5 secs worth of data in a tight loop
            for idx = 1 : 1000
                % Note: sleep() accepts [mSecs] duration, but does not process any events.
                % pause() processes events, but resolution on windows can be at worst 15 msecs
                java.lang.Thread.sleep(5);
                
                % Poll for latest frame instead of using event callback
                data = theClient.GetLastFrameOfData();
                frameTime = data.fLatency;
                frameID = data.iFrame;
                if(frameTime ~= lastFrameTime)
                    fprintf('FrameTime: %0.3f\tFrameID: %5d\n',frameTime, frameID);
                    lastFrameTime = frameTime;
                    lastFrameID = frameID;
                else
                    display('Duplicate frame');
                end
            end
        else
            % approach 3 : get data by event handler (no polling)
            % Add NatNet FrameReady event handler
            tic;
            ls = addlistener(theClient,'OnFrameReady2',@(src,event)FrameReadyCallback(src,event));
            display('[NatNet] FrameReady Listener added.');
            % wait until figure is closed
%             uiwait(F0);
            while ~stopFlag 
                drawnow
            end;
            fwrite(s,'s');
                       
        end
    end
    
catch err
    display(err);
end

%% cleanup
if(usePollingTimer)
    stop(TimerData);
    delete(TimerData);
end
if(useFrameReadyEvent)
    if(~isempty(ls))
        delete(ls);
    end
end

%% save data
%datetime('today');
time=clock;
%dataTime=[num2str(time(1),'%02d'),num2str(time(2),'%02d'),num2str(time(3),'%02d'),num2str(time(4),'%02d'),num2str(time(5),'%02d'),num2str(int64(time(6)),'%02d')];
dataTime=[num2str(time(1),'%02d'),num2str(time(2),'%02d'),num2str(time(3),'%02d'),num2str(time(4),'%02d'),num2str(time(5),'%02d')];
currentDir=pwd;
mkdir(fullfile(currentDir,'experimentData',['OMRS_Experiment_',dataTime]));
dataDir=fullfile(currentDir,'experimentData',['OMRS_Experiment_',dataTime]);
filePath=fullfile(dataDir,['NPID_lambda=',num2str(P.lambda)]);
save(filePath,'P')

expDataAnalysis;
if 0
    %% paper graphics
    %% x-y plane
    F2=figure('name','x-y plane','position',[50 70 570 450]);
    plot(P.QD(1,:),P.QD(2,:),'b.-',P.QN(1,:),P.QN(2,:),'r.--')
    %rectangle
    axis([-0.2 1.2 -0.1 1.3])
    %lemniscate
    %axis([-2 2 -2 2])
    xlabel('x(m)')
    ylabel('y(m)')
    L1=legend('Reference','Response(NPID)');
    set(L1,'Location','northeast')
    hold on
    
    %% theta plane
    F3=figure('name','\theta plane','position',[60 80 570 450]);
    plot(P.T,P.QD(3,:),'b.-',P.T,P.QN(3,:),'r.--');
    axis([0 P.instantTime -3 10])
    xlabel('t(s)')
    ylabel('\theta(rad)')
    L2=legend('Reference','Response(NPID)');
    set(L2,'Location','SouthEast')
    hold on
    
    %% error
    F4=figure('name','error','position',[70 90 570 450]);
    % X error
    subplot(311);
    plot(P.T,P.QN(1,:)-P.QD(1,:),'r.--');
    axis([0 P.instantTime -0.5 0.5])
    ylabel('e_x(m)')
    hold on
    % Y error
    subplot(312)
    plot(P.T,P.QN(2,:)-P.QD(2,:),'r.--');
    axis([0 P.instantTime -0.5 0.5])
    ylabel('e_y(m)')
    L3=legend('NPID');
    set(L3,'Location','NorthWest','FontSize',6)
    hold on
    % theta error
    subplot(313);
    plot(P.T,P.QN(3,:)-P.QD(3,:),'r.--');
    axis([0 P.instantTime -0.5 0.5])
    xlabel('t(s)')
    ylabel('e_\theta(rad)')
    hold on
    
    %% output
    F5=figure('name','output','position',[80 100 570 450]);
    % u1 output
    subplot(311);
    plot(P.T,P.NU(1,:),'r.--');
    axis([0 P.instantTime -40 40])
    ylabel('u_1(V)')
    hold on
    % u2 output
    subplot(312)
    plot(P.T,P.NU(2,:),'r.--');
    axis([0 P.instantTime -40 40])
    ylabel('u_2(V)')
    L4=legend('NPID');
    set(L4,'Location','NorthWest','FontSize',6)
    hold on
    % u3 output
    subplot(313);
    plot(P.T,P.NU(3,:),'r.--')
    axis([0 P.instantTime -40 40])
    %xlabel('t(s)','fontname','times new roman','fontweight','bold')
    xlabel('t(s)')
    ylabel('u_3(V)')
    hold on
    %% New Format Conversion
    figure(F2)
    saveas(gcf,fullfile(dataDir,'xy_plane_exp.eps'),'epsc')
    figure(F3)
    saveas(gcf,fullfile(dataDir,'theta_plane_exp.eps'),'epsc')
    figure(F4)
    saveas(gcf,fullfile(dataDir,'error_exp.eps'),'epsc')
    figure(F5)
    saveas(gcf,fullfile(dataDir,'output_exp.eps'),'epsc')
end
clear P functions;
startFlag = false;
end