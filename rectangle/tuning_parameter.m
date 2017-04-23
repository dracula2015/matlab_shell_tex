global P;
FF=figure
%lambda=15;
E=[-0.2];
KP=[180];
k0=P.wc^2;
lambda=P.lambda
gp=P.gp
for e=-0.2:0.0001:0.2
if (lambda*e)^2>=1
kp=k0+gp*(lambda*e)^2;
else kp=k0+gp*sqrt(abs(lambda*e));
end
E=[E e];
KP=[KP kp];
end
plot(E,KP,'b.-.')
axis([-0.2 0.2 80 180])
line([-1/lambda -1/lambda], [80 180], 'color', 'g', 'linewidth', 2)
line([1/lambda 1/lambda], [80 180], 'color', 'k', 'linewidth', 2)
line([-0.2 0.2], [k0 k0], 'color', 'r', 'linewidth', 2)
xlabel('e')
ylabel('k_p')
L1=legend('k_p(e)','e=-1/\lambda', 'e=1/\lambda', 'k_p=k_0')
set(L1,'location','north')
kp_frame=getframe(FF)
kp_image=frame2im(kp_frame);
if strcmp('win64',computer('arch'))
    imwrite(kp_image,'D:\OMRS_Projection\OMRS\PID+NPID\rectangle\kp.bmp','bmp')
elseif strcmp('glnxa64',computer('arch'))
    imwrite(kp_image,'~/Desktop/paper/latex/ieeeconf/kp.bmp','bmp')
    unix('cd ~/Desktop/paper/latex/ieeeconf; convert kp.bmp kp.eps')
end