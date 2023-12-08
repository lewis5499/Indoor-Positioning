% created by Hengzhen Liu, Oct. 16th, 2023
%% init and load data
clc;clear;
load ..\dataset\data_default.mat;
%% get fingerprint database
database_with_ref=getdatabase_with_ref(database,rploc);
%% match: knn+normalized distance
prob_pos=getprob(test1withref,database_with_ref,3);
%% plot: probPos and refPos
rp=[test1withref.east,test1withref.north];
%posplot("Position-solution-and-reference",prob_pos,table2array(rploc(:,2:4)));
posplot("Position-solution-and-reference",prob_pos,rp);