function [smtdata] = vecsmooth(rawdata,width)
len=length(rawdata);
smtdata=zeros(len,1);
half=floor(width/2);
for i=1:len
    if i<=half
        smtdata(i)=mean(rawdata(1:2*i));
    elseif i>=len-half
        smtdata(i)=mean(rawdata(len-2*(len-i):len));
    else
        smtdata(i)=mean(rawdata(i-half:i+half));
    end
end
end

