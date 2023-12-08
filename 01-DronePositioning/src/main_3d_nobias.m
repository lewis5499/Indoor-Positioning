% created by Hengzhen Liu, Sept. 22st, 2023
%% load data and prepare matrix
load ..\dataset\data_default.mat;
outfile='../tempfiles/output3d_nobias_LS.txt';
fop=fopen(outfile,'w+');
% 3D perspective (+1d: ELEVATION CONSTRANT, as 4d)
NUM_baseOBS=4+1;%elevation constraint
Dimension=2+1;
% MODEL: v= B*x-l, B=[vecbN,vecbE,vecbH]
vecbN=zeros(NUM_baseOBS,1);
vecbE=zeros(NUM_baseOBS,1);
vecbH=zeros(NUM_baseOBS,1);

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
X0=[mean(matbasestat(:,2));mean(matbasestat(:,3));mean(matbasestat(:,6))];
statE=matbasestat(:,2);  %base_E
statN=matbasestat(:,3);  %base_N
statH=matbasestat(:,6);  %base_U
%% Calculation
maxepoch=height(rangedata);
for nepoch=1:maxepoch
    %% LS-single epoch: Iterations
    n=1;
    MAXCorr=1;
    while abs(MAXCorr)>1e-8&&n<10
        for i=1:NUM_baseOBS-1
            d0(i)=sqrt((statN(i)-X0(1))^2+(statE(i)-X0(2))^2+(statH(i)-X0(3))^2);
            vecbN(i)=-(statN(i)-X0(1))/d0(i);
            vecbE(i)=-(statE(i)-X0(2))/d0(i);
            vecbH(i)=-(statH(i)-X0(3))/d0(i);
        end
        % elevation constraint
        d0(5)=X0(3);%The last calculated elevation value serves as the initial value for this position
        vecbN(5)=0;
        vecbE(5)=0;
        vecbH(5)=1;
        % The last item is the observed elevation value for this time
        d=[base1D(nepoch);base2D(nepoch);base3D(nepoch);base4D(nepoch);Up(nepoch)];
        %l=d-d0;
        l=d-d0;
        B=[vecbN,vecbE,vecbH];
        x=inv(B'*P*B)*B'*P*l;
        X0=X0+x;
        MAXCorr=max(x);
        n=n+1;
    end
    v=B*x-l;
    X=X0';

    Q_dop=inv(B'*P*B);
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
    fprintf(fop,'%9s %10s %10s %10s\r\n','Time(s)','N(m)','E(m)','H(m)');
    fprintf(fop,'%10.4f %10.4f %10.4f %10.4f\r\n',sec(nepoch),X(1),X(2),X(3));
    fprintf(fop,"Posterior Unit Weight Error(m):%13.8f\r\n",m0);
    fprintf(fop,"Posterior Estimated Variance(m^2):\r\n");
    fprintf(fop,'%10.5f %10.5f %10.5f\r\n',Dxx(1,:));
    fprintf(fop,'%10.5f %10.5f %10.5f\r\n',Dxx(2,:));
    fprintf(fop,'%10.5f %10.5f %10.5f\r\n',Dxx(3,:));
    fprintf(fop,"Q_DOP matrix:\r\n");
    fprintf(fop,'%10.5f %10.5f %10.5f\r\n',Q_dop(1,:));
    fprintf(fop,'%10.5f %10.5f %10.5f\r\n',Q_dop(2,:));
    fprintf(fop,'%10.5f %10.5f %10.5f\r\n',Q_dop(3,:));
    fprintf(fop,'%s %10.5f\r\n','N_dop:',Q_dop(1,1));
    fprintf(fop,'%s %10.5f\r\n','E_dop:',Q_dop(2,2));
    fprintf(fop,'%s %10.5f\r\n','H_dop:',Q_dop(3,3));
end
% eliminate the outliers: Chi-Square Distribution test
% Attention! it has changed the sec, allX, Up (delete outliers' lines)
bounded_data=[sec,allVal,allX,Up];
[Asec,AallX,AUp,Abounded_data]=eliminate_outliers(bounded_data,0.15,NUM_baseOBS-Dimension,Dimension);
fclose(fop);
%% Visualization
visualization(Asec,AallX,AUp,matbasestat);
%animated(sec,allX,Up,matbasestat);











