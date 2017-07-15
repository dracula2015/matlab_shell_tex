function TimerCallback( obj, event, theClient )
%TIMERCALLBACK      Process data in a Matlab Timer callback
%   此处显示详细说明
frameOfData = theClient.GetLastFrameOfData();
UpdateInstruction( frameOfData );
end