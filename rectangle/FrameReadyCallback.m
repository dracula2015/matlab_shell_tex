function FrameReadyCallback(src, event)
%FRAMEREADYCALLBACK     Process data in a NatNet FrameReady Event listener callback
%   �˴���ʾ��ϸ˵��
frameOfData = event.data;
% UpdateInstruction( frameOfData );
UpdateInstruction_KalmanFilter( frameOfData );
end
