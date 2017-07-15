function FrameReadyCallback(src, event)
%FRAMEREADYCALLBACK     Process data in a NatNet FrameReady Event listener callback
%   此处显示详细说明
frameOfData = event.data;
UpdateInstruction( frameOfData );
end
