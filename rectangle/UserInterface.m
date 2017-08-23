function UserInterface
%UserInterface �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
clc
clear all
global execFunctionHandle startFlag stopFlag pauseFlag execFunction initialAttitude;
initialAttitude=[0;0;0];
stopFlag = false;
pauseFlag = false;
startFlag = false;
UI=figure('name','OptiTrack NatNet Matlab Controller','NumberTitle','off','color','default');
execFunctionHandle = @expMainFunction;
uicontrol('style','text','fontsize',20,'string','X','Position',[20 350 150 60],'backgroundcolor','default')
uicontrol('style','text','fontsize',20,'string','Y','Position',[20 270 150 60],'backgroundcolor','default')
uicontrol('style','text','fontsize',20,'string','theta','Position',[20 190 150 60],'backgroundcolor','default')
AttitudeX = uicontrol('Style','edit','fontsize',20,'string',0,'Position',[205 350 150 60]);
AttitudeY = uicontrol('Style','edit','fontsize',20,'string',0,'Position',[205 270 150 60]);
AttitudeTheta = uicontrol('Style','edit','fontsize',20,'string',0,'Position',[205 190 150 60]);

uicontrol('Style','popup','fontsize',20,'String',{'choose','simulation','experiment'},'Position',[20 80 160 80],'Callback',@switchFunction)
uicontrol('Style','pushbutton','fontsize',20,'String','Initialize','Position',[205 110 150 60],'Callback',@(source,eventdata)initialize(source,eventdata))
uicontrol('Style','pushbutton','fontsize',20,'String','Start','Position',[20 30 150 60],'Callback',@startFunction)
uicontrol('Style','pushbutton','fontsize',20,'String','Pause','Position',[205 30 150 60],'Callback',@pauseFunction)
uicontrol('Style','pushbutton','fontsize',20,'String','Stop','Position',[390 30 150 60],'Callback',@stopFunction)
% uiwait(UI);
%%Subfunction
function ready = initialize( source, eventdata, currentAttitude, execTime )
%InitialAttitude �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
initialAttitude(1) = str2double(get(AttitudeX,'string'));
initialAttitude(2) = str2double(get(AttitudeY,'string'));
initialAttitude(3) = str2double(get(AttitudeTheta,'string'));

end

end

function switchFunction(source,eventdata)
%switchFunction �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
global execFunctionHandle execFunction stopFlag;
stopFlag = false;
if strcmp(source.String(source.Value),'simulation')
    execFunctionHandle = @simMainFunction;
    execFunction = 'simulation';
    disp('simulation')
elseif strcmp(source.String(source.Value),'experiment')
    execFunctionHandle = @expMainFunction;
    execFunction = 'experiment';
    disp('experiment')
else disp('choose to simulate or experiment')
end
drawnow
end

function startFunction(source,eventdata)
%startFunction �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
global startFlag stopFlag pauseFlag execFunctionHandle;
clear P functions;
if ~startFlag
    startFlag = true;
    execFunctionHandle();
end
end

function stopFunction(source,eventdata)
%stopFunction �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
global s execFunction startFlag stopFlag pauseFlag;
% if startFlag
%     fwrite(s,'s');
% end
pauseFlag = false;
stopFlag = true;
if strcmp(execFunction,'simulation')
    disp('stop simulation');
elseif strcmp(execFunction,'experiment')
    disp('stop experiment');
end
end

function pauseFunction(source,eventdata)
%pauseFunction �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
global s startFlag pauseFlag;
pauseFlag = ~pauseFlag;
% if pauseFlag && startFlag
%     fwrite(s,'s');
% end
end

function initialAttitudeX(source,eventdata)
%initialAttitudeX �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
global s startFlag pauseFlag initialAttitude;
pauseFlag = ~pauseFlag;
% if pauseFlag && startFlag
%     fwrite(s,'s');
% end
end

function initialAttitudeY(source,eventdata)
%initialAttitudeY �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
global s startFlag pauseFlag initialAttitude;
pauseFlag = ~pauseFlag;
% if pauseFlag && startFlag
%     fwrite(s,'s');
% end
end

function initialAttitudeTheta(source,eventdata)
%initialAttitudeTheta �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
global s startFlag pauseFlag initialAttitude;
pauseFlag = ~pauseFlag;
% if pauseFlag && startFlag
%     fwrite(s,'s');
% end
end