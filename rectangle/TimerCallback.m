function TimerCallback( obj, event, theClient )
%TIMERCALLBACK      Process data in a Matlab Timer callback
%   �˴���ʾ��ϸ˵��
frameOfData = theClient.GetLastFrameOfData();
UpdateInstruction( frameOfData );
end