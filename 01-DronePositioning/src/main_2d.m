% created by Hengzhen Liu, Sept. 21st, 2023
%% load data and prepare matrix
load ..\dataset\data_default.mat;
outfile='../tempfiles/output2d_LS.txt';
fop=fopen(outfile,'w+');
% 2D perspective
NUM_baseOBS=4;
Dimension=2;
% MODEL: v= B*x-l, B=[vecbN,vecbE]
vecbN=zeros(NUM_baseOBS,1);
vecbE=zeros(NUM_baseOBS,1);
% vecbU=zeros(NUM_baseOBS,1);
l=zeros(NUM_baseOBS,1);
d0=zeros(NUM_baseOBS,1);
d=zeros(NUM_baseOBS,1);
% default:  P=Q=I (NUM_baseOBS*NUM_baseOBS)
% we do not know the variance INFO
P=eye(NUM_baseOBS);
Q=inv(P);
% corr
x=zeros(Dimension,1);
MAXCorr=1;
% params
X=zeros(Dimension,1);
allX=[];
allVal=[];
bounded_data=[];
B=zeros(NUM_baseOBS,Dimension);
Q_dop=zeros(Dimension,Dimension);
% set the initial info
% X0=[mean(base_E(:,2));mean(base_N(:,3))];
X0=[mean(matbasestat(:,2));mean(matbasestat(:,3))];
statE=matbasestat(:,2);  %base_E
statN=matbasestat(:,3);  %base_N
%% Calculation
maxepoch=height(rangedata);
for nepoch=1:maxepoch
    %% LS-single epoch: Iterations
    n=1;
    MAXCorr=1;
    while abs(MAXCorr)>1e-8&&n<10
        for i=1:NUM_baseOBS
            d0(i)=sqrt((statN(i)-X0(1))^2+(statE(i)-X0(2))^2);
            vecbN(i)=-(statN(i)-X0(1))/d0(i);
            vecbE(i)=-(statE(i)-X0(2))/d0(i);
        end
        d=[base1D(nepoch);base2D(nepoch);base3D(nepoch);base4D(nepoch)];
        l=d-d0;
        B=[vecbN,vecbE];
        x=inv(B'*P*B)*B'*P*l;
        X0=X0+x;
        MAXCorr=max(x);
        n=n+1;
    end
    v=B*x-l;
    X=X0';

    Q_dop=inv(B'*P*B);
    N_dop=Q_dop(1,1);
    E_dop=Q_dop(2,2);
    m0=sqrt(v'*P*v/(NUM_baseOBS-Dimension));
    Dxx=m0*m0*Q_dop;
    % we set the prior mean square error as the unit weight mean square error
    % and P=Q=I 
    Val=v'*v;
    iter=n-1;
    allX=[allX;X];
    allVal=[allVal;Val];
    disp("Epoch "+string(nepoch)+" : iteration times = "+string(iter));
    disp("MAXCorr = "+string(MAXCorr));
    % save data
    fprintf(fop,'%s','>');
    fprintf(fop,'%13s %14s %14s\r\n','E(m)','N(m)','Time(s)');
    fprintf(fop,'%14.4f %14.4f %14.4f\r\n',X(1),X(2),sec(nepoch));
    fprintf(fop,"Posterior Unit Weight Error(m):%13.8f\r\n",m0);
    fprintf(fop,"Posterior Estimated Variance(m^2):\r\n");
    fprintf(fop,'%14.4f %14.4f\r\n',Dxx(1,:));
    fprintf(fop,'%14.4f %14.4f\r\n',Dxx(2,:));
    fprintf(fop,"N_dop:%10.4f       E_dop:%10.4f\r\n",N_dop,E_dop);
%     % give the initialized INFO for the static kalman filtering
%     if nepoch==1
%         KX0=X0;
%         KQ_dop=Q_dop;
%         Kx0=x;
%         Km0=m0;
%         KDxx=Dxx;
%     end
end
% eliminate the outliers: Chi-Square Distribution test
% Attention! it has changed the sec, allX, Up (delete outliers' lines)
bounded_data=[sec,allVal,allX,Up];
[sec,allX,Up,bounded_data]=eliminate_outliers(bounded_data,0.15,NUM_baseOBS-Dimension,Dimension);
fclose(fop);
%% Visualization
visualization(sec,allX,Up,matbasestat);
animated(sec,allX,Up,matbasestat);











