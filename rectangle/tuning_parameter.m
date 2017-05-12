global P;
set(0,'defaultfigurecolor','w')
FF=figure;
lineWidth=2;
E=[-0.2];
k0=P.wc^2;
lambda=P.lambda;
gp=P.gp;
KP=[k0*(1+gp*0.2^2)];
for e=-0.2:0.0001:0.2
% if (lambda*e)^2>=1
% kp=k0+gp*(lambda*e)^2;
% else kp=k0+gp*sqrt(abs(lambda*e));
% end
if (lambda*e)^2>=1
kp=k0*(1+gp*e^2);
else kp=k0*(1+gp*sqrt(abs(e)));
end

if e==-0.2
    E=E;
    KP=KP;
else
    E=[E e];
    KP=[KP kp];
end
end
plot(E,KP,'b-','linewidth', 2)
axis([-0.2 0.2 k0-20 k0*(1+gp*(1/lambda)^0.5)+50])
line([-1/lambda -1/lambda], [k0-20 k0*(1+gp*(1/lambda)^0.5)+50], 'color', 'g', 'linewidth', 1)
line([1/lambda 1/lambda], [k0-20 k0*(1+gp*(1/lambda)^0.5)+50], 'color', 'k', 'linewidth', 1)
line([-0.2 0.2], [k0 k0], 'color', 'r', 'linewidth', 1)
xlabel('e')
ylabel('k_p')
L1=legend('k_p(e)','e=-1/\lambda', 'e=1/\lambda', 'k_p=k_0');
%legend('boxoff');
%set(L1,'position',[0.45,0.7,0.1357,0.1893],'box','off')
set(L1,'position',[0.7,0.7,0.1357,0.1893],'box','off')
%set(L1,'location','northeast','box','off')
kp_frame=getframe(FF);
kp_image=frame2im(kp_frame);
if 0
    if strcmp('win64',computer('arch'))
        imwrite(kp_image,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\kp.bmp','bmp')
    elseif strcmp('glnxa64',computer('arch'))
        imwrite(kp_image,'~/Desktop/paper/latex/ieeeconf/kp.bmp','bmp')
        unix('cd ~/Desktop/paper/latex/ieeeconf; convert kp.bmp kp.eps')
    end
end
%% New Format Conversion
if strcmp('win64',computer('arch'))
    saveas(gcf,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\kp.eps','epsc')
elseif strcmp('glnxa64',computer('arch'))
    saveas(gcf,'~/Desktop/paper/latex/ieeeconf/kp.eps','epsc')
end
