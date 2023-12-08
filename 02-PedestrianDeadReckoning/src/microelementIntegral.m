function [out] = microelementIntegral(samplingRate,f,init_val)
%Integration by microelement method
delta=1/samplingRate;
out=zeros(length(f),1);
out(1)=init_val;
for i=2:length(f)
    out(i)=mod(out(i-1)+f(i)*delta+pi,2*pi)-pi;
    %out(i)=out(i-1)+f(i)*delta;
    %out(i)=mod(out(i-1)+f(i)*delta,2*pi);
end
end

