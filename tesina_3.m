clear all
close all
clc

%% INPUT
p1=1; %[bar]
m1=10; %[kg/s]
fluid='nitrogen';
epsisc1=0.95; %efficienza del primo scambiatore
epsisc2=0.80; %efficienza del secondo scambiatore
T0=25; %[°C] ipotesi della temperatura ambiente

%IPOTESI DI COMPRESSIONE ISOTERMA ED ESPANSIONE ENDOREVERSIBILE

% comprimo dal punto 0 invece che dal punto 1. Dopo essermi calcolato tutti
% i punti del ciclo procedo a fare una media tra 0 e 8 per calcolare 1. Conoscendo 1
% mi calcolo i tre punti in più della compressione isoterma (ovvero due
% compressioni interrefrigerate) per completare il ciclo=tesina.
h0=refpropm('h','t',T0+273.15,'p',p1*100,fluid)/1000;
s0=refpropm('s','t',T0+273.15,'p',p1*100,fluid)/1000;
T4=refpropm('t','p',p1*100,'q',1,fluid)-273.15;
h4=refpropm('h','p',p1*100,'q',1,fluid)/1000;
s4=refpropm('s','p',p1*100,'q',1,fluid)/1000;
pc=refpropm('p','c',0,'',0,fluid)/100;
pmax=pc-4; %[bar] ipotesi della pressione massima
max=10;
pvar=linspace(p1,pmax,max);
for i=1:length(pvar);
    p2(i)=pvar(i);
    
    Tl(i)=refpropm('t','p',p2(i)*100,'q',0,fluid)-273.15;
    Tv(i)=refpropm('t','p',p2(i)*100,'q',1,fluid)-273.15;
    sl(i)=refpropm('s','p',p2(i)*100,'q',0,fluid)/1000;
    sv(i)=refpropm('s','p',p2(i)*100,'q',1,fluid)/1000;
    Tc=refpropm('t','c',0,'',0,fluid)-273.15;
    sc=refpropm('s','c',0,'',0,fluid)/1000;
    %punto 2
    T2(i)=T0;
    h2(i)=refpropm('h','t',T0+273.15,'p',p2(i)*100,fluid)/1000;
    s2(i)=refpropm('s','t',T2(i)+273.15,'p',p2(i)*100,fluid)/1000;
    %punto 3
    s3(i)=s4;
    T3(i)=refpropm('t','p',p2(i)*100,'s',s3(i)*1000,fluid)-273.15;
    h3(i)=refpropm('s','t',T3(i)+273.15,'p',p2(i)*100,fluid)/1000;
    %punto 5
    T5(i)=refpropm('t','p',p2(i)*100,'q',0,fluid)-273.15;
    s5(i)=refpropm('s','t',T5(i)+273.15,'q',0,fluid)/1000;
    h5(i)=refpropm('h','t',T5(i)+273.15,'q',0,fluid)/1000;
    %punto 6
    h6(i)=h5(i);
    T6(i)=T4;
    p6(i)=p1;
    s6(i)=refpropm('s','t',T6(i)+273.15,'h',h6(i)*1000,fluid)/1000;
    %punto 7
    T7(i)=T6(i);
    p7(i)=p1;
    h7(i)=refpropm('h','t',T7(i)+273.15,'q',0,fluid)/1000;
    s7(i)=refpropm('s','t',T7(i)+273.15,'q',0,fluid)/1000;
    %bilanci
    Lc(i)=m1*(h0-h2(i));
end
sl(i+1)=sc;
sv(i+1)=sc;
Tl(i+1)=Tc;
Tv(i+1)=Tc;

figure(1);
plot(sl,Tl,'b',sv,Tv,'r');
hold on
plot(s0,T0,'o')
hold on
plot(s2(max),T2,'o')
hold on
plot(s3,T3,'o')
hold on
plot(s4,T4,'o')
hold on
plot(s5(max),T5(max),'o')
hold on
plot(s6(max),T6(max),'ok')
hold on
plot(s7(max),T7(max),'o')

