clc;clear;close all;
BIN= zeros(1,32);
DEC=234.938293457; %%% liczba decimaal do konwersji

%%%%%%%%%%%%%%%%%%%
%
%  rozdzial na pelne i po przecinku
%
%%%%%%%%%%%%%%%%%%%

fractional=mod(DEC,1);
decimal=DEC-fractional;

%%%%%%%%%%%%%%%%%%%
%
%  wyznaczanie znaku
%
%%%%%%%%%%%%%%%%%%%

if DEC>0 
    ZNAK=0; else
    ZNAK=1;
end
j=ceil(log2(decimal)); %pelne_max_bity 
max_j=j; %zapis na pozniej

%%%%%%%%%%%%%%%%%%%
%
%  zamiana przecinka na binarny
%
%%%%%%%%%%%%%%%%%%%

max_zakres=25-max_j;
przecinek_calk=zeros(1,max_zakres);
przecinek_reszta=zeros(1,max_zakres);
przecinek_reszta(1,1)=fractional;
for(i=2:1:max_zakres)
     przecinek_reszta(i)=przecinek_reszta(i-1)*2;
    if(przecinek_reszta(i)>1)
        przecinek_reszta(i)=przecinek_reszta(i)-1;
        przecinek_calk(i)=1;
    else
        przecinek_calk(i)=0;
    end
end
przecinek_calk(2:max_zakres);


%%%%%%%%%%%%%%%%%%%
%
%  zamiana pelnych na binarny
%
%%%%%%%%%%%%%%%%%%%
pelne_calk=zeros(1,j);
pelne_reszta=zeros(1,j);
if(mod(decimal,2)==0)
pelne_calk(j)=decimal/2;
pelne_reszta(j)=0;
else
pelne_calk(j)=(decimal-1)/2;  
pelne_reszta(j)=1;
end

while(pelne_calk(j)>0 || j<1)
    if(mod(pelne_calk(j),2)==0)
pelne_calk(j-1)=pelne_calk(j)/2;
pelne_reszta(j-1)=0;
else
pelne_calk(j-1)=(pelne_calk(j)-1)/2;  
pelne_reszta(j-1)=1;
    end
j=j-1;
end

pelne_reszta;

%%%%%%%%%%%%%%%%%%%
%
% konkatenacja pelne . przecinek
%
%%%%%%%%%%%%%%%%%%%
bin_scientic=zeros(1,24);
bin_scientic(1:max_j)=pelne_reszta(1:max_j);
bin_scientic(max_j+1:24)=przecinek_calk(2:(23-max_j+2));

%%%%%%%%%%%%%%%%%%%
%
% liczenie przesunienia kropki
%
%%%%%%%%%%%%%%%%%%%
move_decimal= max_j-1;
bias=127+move_decimal;
bits=8; % liczba bitow na exponent
%%%%%%%%%%%%%%%%%%%
%
% liczenie exponentu
%
%%%%%%%%%%%%%%%%%%%
bias_calk=zeros(1,bits);
bias_reszta=zeros(1,bits);

if(mod(bias,2)==0)
bias_calk(bits)=bias/2;
bias_reszta(bits)=0;
else
bias_calk(bits)=(bias-1)/2;  
bias_reszta(bits)=1;
end

while(bias_calk(bits)>0 || bits<1)
    if(mod(bias_calk(bits),2)==0)
bias_calk(bits-1)=bias_calk(bits)/2;
bias_reszta(bits-1)=0;
else
bias_calk(bits-1)=(bias_calk(bits)-1)/2;  
bias_reszta(bits-1)=1;
    end
bits=bits-1;
end
bias_reszta;
%%%%%%%%%%%%%%%%%%%
%
% skladanie koncowe
%
%%%%%%%%%%%%%%%%%%%

BIN(1)= ZNAK;
BIN(2:9)=bias_reszta;
BIN(10:32)=bin_scientic(2:24);

disp(DEC);
disp(BIN);