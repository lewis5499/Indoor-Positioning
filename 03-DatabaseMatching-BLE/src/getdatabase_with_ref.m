function [database_with_ref]=getdatabase_with_ref(database,rp)
datanums=height(database);
posnums=height(rp);
counts=0;
database_with_ref=[];
% pos_i的指纹强度按i分类，添加count, enupos
for i=1:posnums
    j=counts+1;
    count=0;
    ref_i_table=[];
    while database.posID(j)~=i
        j=j+1;
    end
    while database.posID(j)==i
        line_table=database(j,:);
        ref_i_table=[ref_i_table;line_table];
        j=j+1;
        count=count+1;
        if j==datanums+1
            break;
        end
    end
    counts=counts+count;
    ref_i_struct=table2struct(ref_i_table,"ToScalar",true);
    ref_i_struct.posID=table2array(rp(i,1));
    ref_i_struct.count=count;
    ref_i_struct.enupos=table2array(rp(i,2:4));
    % disp(ref_i_table)
    %disp(i)
    database_with_ref=[database_with_ref;ref_i_struct];
    if j==datanums
        break;
    end
end
% pos_i的指纹强度均值：不用-110,存储为多维向量fingerprint
for i=1:posnums
    idata=[];
    fields=fieldnames(database_with_ref(i));
    len=30;
    for k=2:len+1 %posID, count, enupos不做均值处理
        fieldName=fields{k};
        database_with_ref(i).(fieldName)=mean(database_with_ref(i).(fieldName)(database_with_ref(i).(fieldName)~=-110));
        idata=[idata,database_with_ref(i).(fieldName)];
        database_with_ref(i).fingerprint=idata;
    end
end
end
























