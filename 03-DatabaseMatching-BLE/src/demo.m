% % 定义一个带有NaN值的矩阵
% matrix = [1, 2, NaN; NaN, 5, 6; 7, NaN, 9];
% % % 找出矩阵中的NaN值
% % nan_indices = isnan(matrix);
% % 
% % % 将NaN值替换为0
% % matrix(nan_indices) = 0;
% matrix(isnan(matrix))=0;
% % 显示替换后的矩阵
% disp('将NaN值替换为0后的矩阵：');
% disp(matrix);

% 
% % a=[database_with_ref.posID]
% 
% matrix = [3, 6, 9; 
%           2, 5, 8; 
%           1, 4, 7];
% 
% % 按照第一列元素从小到大进行排序
% sorted_matrix = sortrows(matrix, 1,'ascend');
% 
% % 显示排序后的矩阵
% disp('按第一列元素从小到大排序后的矩阵：');
% disp(sorted_matrix);
knn=30;
testlen=height(test1withref);
reflen=height(database_with_ref);
RSSnums=30;
iref_fingerprint=[];
prob_pos=[];
for i=1:reflen
    iref_fingerprint=[iref_fingerprint;database_with_ref(i).fingerprint];
end
for i=1:testlen
    disp(i)
    itest_fingerprint=table2array(test1withref(i,2:31));
    % d_fingerprint=abs(iref_fingerprint-itest_fingerprint);
    dscorefingerprint=abs(iref_fingerprint-itest_fingerprint);
    %--------------------------------------------------------------------------
    %可以对d_fingerprint加一个得分制，给每个可能的pos的30个RSS打分，sum(RSS_score)
    %就是每个可能的pos的得分，得分越高越可能匹配成功
    goodposnum=3;
    dscore=zeros(reflen,1);
    dscorefingerprint=[dscorefingerprint,[database_with_ref.posID]'];
    goodpos_score=[1.5,1,0.5]';
    for p=1:RSSnums
        row=sortrows(dscorefingerprint,p,"ascend");
        goodposlocs=row(1:goodposnum,RSSnums+1);
        dscore(goodposlocs)=dscore(goodposlocs)+goodpos_score;
    end
    dscore=[dscore,[database_with_ref.posID]'];
    %--------------------------------------------------------------------------
    % norm_fingerprint=[];
    % %将d_fingerprint按列归一化：2-范数
    % for n=1:RSSnums
    %     d_fingerprint(:,n)=normalize(d_fingerprint(:,n),'norm',2);
    % end
    % %将d_fingerprint按行求模：归一化距离
    % for j=1:reflen
    %     line=d_fingerprint(j,:);
    %     line(isnan(line))=0;
    %     norm_fingerprint=[norm_fingerprint;norm(line)];
    % end
    % norm_fingerprint=[norm_fingerprint,[database_with_ref.posID]'];
    % sorted_val=sortrows(norm_fingerprint,1,"ascend");
    % knn, k=3，求可能坐标值
    % k=knn;
    % neighbors=sorted_val(1:k,:);%[vals,locs]
    % weight=(1./neighbors(:,1))/sum(1./neighbors(:,1));
    % pos3=[];
    % for m=1:k
    %     pos3=[pos3;database_with_ref(neighbors(m,2)).enupos];
    % end
    % pos=weight'*pos3;
    % prob_pos=[prob_pos;pos];
end