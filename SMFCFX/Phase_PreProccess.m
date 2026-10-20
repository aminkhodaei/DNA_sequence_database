clear
clc
format short;
%% Data Read & Filter Ambigious-Characters Samples
data = fastaread('Flu.fasta');
num_data = size(data,1);
num = zeros(num_data,2);
for i=1:num_data
    DNAstrin= data(i).Sequence;
    data_len(i)=length(DNAstrin);
    for j=1:data_len(i)
        if((DNAstrin(j)~='A')&&(DNAstrin(j)~='C')&&(DNAstrin(j)~='G')&&(DNAstrin(j)~='T'))
            num(i,1) = i;
            num(i,2) = j;
            break;
        end
    end
end
[rr rt] = find(num(:,1)>0);
khata = num(rr,:);
khata = khata(:,1);
keepIndices = true(length(data), 1);
keepIndices(khata) = false;
filteredSequences = data(keepIndices);
% newFastaFile = 'Flu.fasta';
% fastawrite(newFastaFile, filteredSequences);
data = filteredSequences;
for i=1:num_data
DNAstr= data(i).Sequence;
data_len(i)=length(DNAstr);
%% EIIP 
A=zeros(1,size(DNAstr,2));
T=zeros(1,size(DNAstr,2));
G=zeros(1,size(DNAstr,2));
C=zeros(1,size(DNAstr,2));
inA=find(DNAstr=='A');
inT=find(DNAstr=='T');
inC=find(DNAstr=='C');
inG=find(DNAstr=='G');
% A(inA)=0.1260;
% T(inT)=0.1335;
% G(inG)=0.0806;
% C(inC)=0.1340;
%% Integer
A(inA)=2;
T(inT)=3;
G(inG)=1;
C(inC)=4;
XnYnZn=(A+G)+(C+T);
output{i} = XnYnZn;
end
save('output_Flu.mat','output')
