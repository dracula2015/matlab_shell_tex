function UserInterface2_0
%UserInterface 此处显示有关此函数的摘要
%   此处显示详细说明
clc
clear all
global execFunctionHandle startFlag stopFlag pauseFlag execFunction initialAttitude comPortMotiveState theClient initFinished s AttitudeX AttitudeY AttitudeTheta;
initFinished = true;
comPortMotiveState = false;
initialAttitude=[0;0;0];
stopFlag = false;
pauseFlag = false;
startFlag = false;
UI=figure('name','OptiTrack NatNet Matlab Controller','NumberTitle','off','color','default');
execFunction = 'simulation';
if strcmp(execFunction,'experiment')
    execFunctionHandle = @expMainFunction;
elseif strcmp(execFunction,'simulation')
    execFunctionHandle = @simMainFunction;
end
if strcmp(execFunction,'experiment')
    comPortMotiveInitialization
end
uicontrol('style','text','fontsize',20,'string','X','Position',[20 350 150 60],'backgroundcolor','default')
uicontrol('style','text','fontsize',20,'string','Y','Position',[20 270 150 60],'backgroundcolor','default')
uicontrol('style','text','fontsize',20,'string','theta','Position',[20 190 150 60],'backgroundcolor','default')
AttitudeX = uicontrol('Style','edit','fontsize',20,'string',0,'Position',[205 350 150 60]);
AttitudeY = uicontrol('Style','edit','fontsize',20,'string',0,'Position',[205 270 150 60]);
AttitudeTheta = uicontrol('Style','edit','fontsize',20,'string',0,'Position',[205 190 150 60]);
RTX = uicontrol('style','text','fontsize',20,'string',0,'Position',[390 350 150 60],'backgroundcolor','default');
RTY = uicontrol('style','text','fontsize',20,'string',0,'Position',[390 270 150 60],'backgroundcolor','default');
RTTheta = uicontrol('style','text','fontsize',20,'string',0,'Position',[390 190 150 60],'backgroundcolor','default');

set(RTX,'string','0')
set(RTY,'string','0')
set(RTTheta,'string','0')

uicontrol('Style','popup','fontsize',20,'String',{'choose','simulation','experiment'},'Position',[20 80 160 80],'Callback',@switchFunction)
uicontrol('Style','pushbutton','fontsize',20,'String','Initialize','Position',[205 110 150 60],'Callback',@(source,eventdata)initialize(source,eventdata))
uicontrol('Style','pushbutton','fontsize',20,'String','Start','Position',[20 30 150 60],'Callback',@startFunction)
uicontrol('Style','pushbutton','fontsize',20,'String','Pause','Position',[205 30 150 60],'Callback',@pauseFunction)
uicontrol('Style','pushbutton','fontsize',20,'String','Stop','Position',[390 30 150 60],'Callback',@stopFunction)

uiwait(UI);
% while(1)
%     drawnow
% end
%% cleanup
if comPortMotiveState
    theClient.Uninitialize();
    fclose(s);
    delete(s);
    clear s;
end

end

function initialize( source, eventdata)
%InitialAttitude 此处显示有关此函数的摘要
%   此处显示详细说明
global initialAttitude initFinished P AttitudeX AttitudeY AttitudeTheta theClient s startFlag pauseFlag stopFlag ;
if ~startFlag
    clear P functions;
    stopFlag = false;
    pauseFlag = false;
    Parameters;
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
    initFinished = false;
    initialAttitude(1) = str2double(get(AttitudeX,'string'));
    initialAttitude(2) = str2double(get(AttitudeY,'string'));
    initialAttitude(3) = str2double(get(AttitudeTheta,'string'));
    tic;
    ls = addlistener(theClient,'OnFrameReady2',@(src,event)FrameReadyCallback(src,event));
    display('[NatNet] FrameReady Listener added.');
    % wait until figure is closed
    %             uiwait(F0);
    while ~stopFlag
        drawnow
    end;
    fwrite(s,'s');
    if(~isempty(ls))
        delete(ls);
    end
%     expDataAnalysis;
    initFinished = true;
end
end

function comPortMotiveInitialization
global comPortMotiveState;
%% COM Port Initialization
global s;
if strcmp('win64',computer('arch'))
    s = serial('COM11','BaudRate',57600,'DataBits',8,'Parity','none','StopBits',1,'FlowControl','none','ReadAsyncMode','continuous','ByteOrder','littleEndian');
elseif strcmp('glnxa64',computer('arch'))
    s = serial('/dev/ttyUSB0','BaudRate',57600,'DataBits',8,'Parity','none','StopBits',1,'FlowControl','none','ReadAsyncMode','continuous','ByteOrder','littleEndian');
end
fopen(s);
%% Motive Initialization
global frameRate theClient;
% global initialFrameTime;
% global instantTime;
lastFrameTime = -1.0;
lastFrameID = -1.0;

% Add NatNet .NET assembly so that Matlab can access its methods, delegates, etc.
% Note : The NatNetML.DLL assembly depends on NatNet.dll, so make sure they
% are both in the same folder and/or path if you move them.
display('[NatNet] Creating Client.')
curDir = pwd;
dllPath = fullfile(curDir,'NatNetSDK','lib','x64','NatNetML.dll');
assemblyInfo = NET.addAssembly(dllPath);

% Create an instance of a NatNet client
theClient = NatNetML.NatNetClientML(0); % Input = iConnectionType: 0 = Multicast, 1 = Unicast
version = theClient.NatNetVersion();

fprintf( '[NatNet] Client Version : %d.%d.%d.%d\n', version(1), version(2), version(3), version(4) );

% Connect to an OptiTrack server (e.g. Motive)
display('[NatNet] Connecting to OptiTrack Server.')

% Connect to another computer's stream.
% LocalIP = char('10.0.1.1'); % Enter your local IP address
% ServerIP = char('10.0.1.200'); % Enter the server's IP address
% flg = theClient.Initialize(LocalIP, ServerIP); % Flg = returnCode: 0 = Success

% Connect to a local stream.
HostIP = char('127.0.0.1');
LocalIP = char('192.168.20.106');
ServerIP = char('192.168.20.102');
% flg = theClient.Initialize(HostIP, HostIP); % Flg = returnCode: 0 = Success
flg = theClient.Initialize(LocalIP, ServerIP); % Flg = returnCode: 0 = Success

if (flg == 0)
    display('[NatNet] Initialization Succeeded')
else
    display('[NatNet] Initialization Failed')
end

% print out a list of the active tracking Models in Motive
GetDataDescriptions(theClient)

% Test - send command/request to Motive
[byteArray, retCode] = theClient.SendMessageAndWait('FrameRate');
if(retCode ==0)
    byteArray = uint8(byteArray);
    frameRate = typecast(byteArray,'single');
end
comPortMotiveState = true;
end

function switchFunction(source,eventdata)
%switchFunction 此处显示有关此函数的摘要
%   此处显示详细说明
global execFunctionHandle execFunction stopFlag comPortMotiveState;
stopFlag = false;
if strcmp(source.String(source.Value),'simulation')
    execFunctionHandle = @simMainFunction;
    execFunction = 'simulation';
    disp('simulation')
elseif strcmp(source.String(source.Value),'experiment')
    if ~comPortMotiveState
        comPortMotiveInitialization
    end
    execFunctionHandle = @expMainFunction2_0;
    execFunction = 'experiment';
    disp('experiment')
else disp('choose to simulate or experiment')
end
drawnow
end

function startFunction(source,eventdata)
%startFunction 此处显示有关此函数的摘要
%   此处显示详细说明
global startFlag stopFlag pauseFlag execFunctionHandle initFinished;
if ~startFlag && initFinished
    clear P functions;
    startFlag = true;
    execFunctionHandle();
end
end

function stopFunction(source,eventdata)
%stopFunction 此处显示有关此函数的摘要
%   此处显示详细说明
global s execFunction startFlag stopFlag pauseFlag;
if ~startFlag
    fwrite(s,'s');
end
pauseFlag = false;
stopFlag = true;
if strcmp(execFunction,'simulation')
    disp('stop simulation');
elseif strcmp(execFunction,'experiment')
    disp('stop experiment');
end
end

function pauseFunction(source,eventdata)
%pauseFunction 此处显示有关此函数的摘要
%   此处显示详细说明
global s startFlag pauseFlag;
pauseFlag = ~pauseFlag;
if pauseFlag && ~startFlag
    fwrite(s,'s');
end
end