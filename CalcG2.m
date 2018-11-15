function [gR, gG, gB] = CalcG2(mean_RF,mean_GF,mean_BF, T,verbose)
    fun = @(x,T)x(1)*T.^(1/x(2));
    x0 = [1600,1.5];
    r = lsqcurvefit(fun,x0,T,mean_RF);
    gR = r(2);
    g = lsqcurvefit(fun,x0,T,mean_GF);
    gG = g(2);
    b = lsqcurvefit(fun,x0,T,mean_BF);
    gB = b(2);
    if verbose
    figure('Name','Camera Compression Data Linearized');
    plot(T,(mean_RF.^gR)/(255^gR/255),'r--x')
    hold on
    plot(T,(mean_BF.^gG)/(255^gG/255), 'b--x')
    plot(T,(mean_GF.^gB)/(255^gB/255), 'g--x')
    hold off
    title('Camera Compression Data Linearized (B^g) and scaled')
    xlabel('Exposure time [sec]')
    ylabel('Brightness [au]')
    legend('Red','Blue','Green')
    end
end
