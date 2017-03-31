function [price]=p()

S0=250;
T=0.6;
r=log(1.0375);
nSds=8;
sigma0=0.17*exp(-0.004*S0);
N=100;
M=100;

x0 = log( S0 );
xMin = x0 - nSds*sqrt(T)*sigma0;
xMax = x0 + nSds*sqrt(T)*sigma0;
dt = T/N;
dx = (xMax-xMin)/M;
iMin = 1;
iMax = N+1;
jMin = 1;
jMax = M+1;
x = xMin:dx:xMax;
t = 0:dt:T;
sigmaT=0.17*exp(-0.004.*x).*exp(-1.6667.*T);

currW=exp(-(r*T)).*(exp((r-0.5*sigmaT.^2)*T+x)-225).^2;
for i=iMax:-1:iMin+1

    sigma=0.17*exp(-0.004.*x).*exp(-1.6667*i);
    lambda=0.5*(sigma.^2)*dt/(dx)^2;
    currW(jMin+1:jMax-1)=      lambda((jMin):(jMax-2)).*currW((jMin):(jMax-2)) ...
                        +(1-2*lambda((jMin+1):(jMax-1))).*currW((jMin+1):(jMax-1)) ...
                        +      lambda((jMin+2):(jMax)).*currW((jMin+2):(jMax));

    currW(jMin)=0;
    currW(jMax)=exp(-r*(T-t(i)))*(exp((r-0.5*sigma(jMax)^2)*(T-t(i))+x(jMax))-225).^2;
end
price = currW(iMin,jMin+M/2);
end
