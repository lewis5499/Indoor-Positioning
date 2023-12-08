function [prob_pos] = getprob(test1withref,database_with_ref,knn)
testlen=height(test1withref);
reflen=height(database_with_ref);
RSSnums=30;
iref_fingerprint=[];
prob_pos=[];
for i=1:reflen
    iref_fingerprint=[iref_fingerprint;database_with_ref(i).fingerprint];
end
for i=1:testlen
    itest_fingerprint=table2array(test1withref(i,2:31));
    %d_fingerprint=abs(iref_fingerprint-itest_fingerprint);
    d_fingerprint=abs(iref_fingerprint-itest_fingerprint);
    norm_fingerprint=[];
    %---1---将d_fingerprint按列归一化：2-范数
    %---2---将d_fingerprint按列规范化：mean=abs(min(nor)), sigma=1
    %---3---将d_fingerprint按列规范化：按sigma缩放，做线性变换使最小的值为0
    %---4---将d_fingerprint按列归一化：range
    for n=1:RSSnums
        %---1---
        % d_fingerprint(:,n)=normalize(d_fingerprint(:,n),'norm',2);
        %---2---
        % nor=normalize(d_fingerprint(:,n),'zscore');
        % d_fingerprint(:,n)=nor-min(nor);
        % disp(min(nor));
        %---3---
        %nor=normalize(d_fingerprint(:,n),'scale');
        %d_fingerprint(:,n)=nor-min(nor);
        %disp(min(nor));
        %---4---
        d_fingerprint(:,n)=normalize(d_fingerprint(:,n),"range");
    end
    %method-1-1-%将d_fingerprint按行求模：归一化距离
    %method-1-2-%将d_fingerprint按行求和：归一化同量纲d维距离和
    scale=1;
    for j=1:reflen
        line=d_fingerprint(j,:);
        line(isnan(line))=0;
        nonZeroCount = nnz(line);
        scale=RSSnums/nonZeroCount;
        %1-1
        %norm_fingerprint=[norm_fingerprint;norm(line)*scale];
        %1-2
        norm_fingerprint=[norm_fingerprint;sum(line)*scale];
    end
    %method-2-%将d_fingerprint按行求归一化得分:FOR:%---4---将d_fingerprint按列归一化：range
    % for j=1:reflen
    %     line=d_fingerprint(j,:);
    %     line(isnan(line))=0;
    %     score_line=RSSnums-sum(line);%满分为30分
    %     norm_fingerprint=[norm_fingerprint;score_line];
    % end

    norm_fingerprint=[norm_fingerprint,[database_with_ref.posID]'];
    sorted_val=sortrows(norm_fingerprint,1,"ascend");
    % knn, k=3，求可能坐标值
    k=knn;
    neighbors=sorted_val(1:k,:);%[vals,locs]
    weight=(1./neighbors(:,1))/sum(1./neighbors(:,1));
    pos3=[];
    for m=1:k
        pos3=[pos3;database_with_ref(neighbors(m,2)).enupos];
    end
    pos=weight'*pos3;
    prob_pos=[prob_pos;pos];
end

end

