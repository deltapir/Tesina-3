clear all
close all
clc

%% INPUT
p1=1; %[bar]
m1=10; %[kg/s]
fluid='nitrogen';
epsisc1=0.95; %efficienza del primo scambiatore
epsisc2=0.80; %efficienza del secondo scambiatore
T0=25; %[�C] ipotesi della temperatura ambiente

%IPOTESI DI COMPRESSIONE ISOTERMA ED ESPANSIONE ENDOREVERSIBILE

% comprimo dal punto 0 invece che dal punto 1. Dopo essermi calcolato tutti
% i punti del ciclo procedo a fare una media tra 0 e 8 per calcolare 1. Conoscendo 1
% mi calcolo i tre punti in pi� della compressione isoterma (ovvero due
% compressioni interrefrigerate) per completare il ciclo=tesina.
h0=refpropm('h','t',T0+273.15,'p',p1*100,fluid)/1000;
s0=refpropm('s','t',T0+273.15,'p',p1*100,fluid)/1000;
T4=refpropm('t','p',p1*100,'q',1,fluid)-273.15;
h4=refpropm('h','p',p1*100,'q',1,fluid)/1000;
s4=refpropm('s','p',p1*100,'q',1,fluid)/1000;
pc=refpropm('p','c',0,'',0,fluid)/100;
pmax=pc-0.8; %[bar] ipotesi della pressione massima (pi� mi avvicino alla pressione critica e pi� il valore di y supera l'1.
max=100;
pvar=linspace(p1+2,pmax,max);
for i=1:length(pvar);
    p2(i)=pvar(i);
    %punto 2
    T2(i)=T0;
    h2(i)=refpropm('h','t',T0+273.15,'p',p2(i)*100,fluid)/1000;
    s2(i)=refpropm('s','t',T2(i)+273.15,'p',p2(i)*100,fluid)/1000;
    %punto 3
    s3(i)=s4;
    T3(i)=refpropm('t','p',p2(i)*100,'s',s3(i)*1000,fluid)-273.15;
    h3(i)=refpropm('h','t',T3(i)+273.15,'p',p2(i)*100,fluid)/1000;
    %punto 5
    T5(i)=refpropm('t','p',p2(i)*100,'q',0,fluid)-273.15;
    s5(i)=refpropm('s','t',T5(i)+273.15,'q',0,fluid)/1000;
    h5(i)=refpropm('h','t',T5(i)+273.15,'q',0,fluid)/1000;
    %punto 6
    h6(i)=h5(i);
    T6(i)=T4;
    p6(i)=p1;
    s6(i)=refpropm('s','t',T6(i)+273.15,'h',h6(i)*1000,fluid)/1000;
    q6(i)=refpropm('q','t',T6(i)+273.15,'s',s6(i)*1000,fluid);
    %punto 7
    T7(i)=T6(i);
    p7(i)=p1;
    h7(i)=refpropm('h','t',T7(i)+273.15,'q',0,fluid)/1000;
    s7(i)=refpropm('s','t',T7(i)+273.15,'q',0,fluid)/1000;
    %sfrutto le efficienze degli scambiatori per determinare le temperature
    %del punto 9 e 8. L'efficienza del secondo scambiatore vale solo nel
    %tratto di condensa.
    TB(i)=epsisc1*(T5(i)-T4)+T4;
    hB(i)=refpropm('h','t',TB(i)+273.15,'p',p1*100,fluid)/1000;
    hA(i)=refpropm('h','t',T5(i)+273.15,'q',1,fluid)/1000;
    sB(i)=refpropm('s','t',TB(i)+273.15,'p',p1*100,fluid)/1000;
    TA(i)=refpropm('t','p',p2(i)*100,'h',hA(i)*1000,fluid)-273.15;
    sA(i)=refpropm('s','t',TA(i)+273.15,'p',p2(i)*100,fluid)/1000;
    y(i)=(h5(i)+q6(i)*hB(i)-hA(i)-q6(i)*h4)/(h4-hB(i)-hA(i)-q6(i)*h4+h5(i)+q6(i)*hB(i));
    m4(i)=m1*y(i);
    m7(i)=m1*(1-y(i))*q6(i);
%     punto 9
    h9(i)=h3(i)+hB(i)-hA(i);
    T9(i)=refpropm('t','p',p1*100,'h',h9(i)*1000,fluid);
    if T9(i)>T3(i)          %stiamo facendo un bilancio di prima legge senza verificare il secondo principio. quindi uso l'IF
        T9(i)=T3(i);
        h9(i)=refpropm('h','t',T9(i)+273.15,'p',p1*100,fluid)/1000;
        s9(i)=refpropm('s','t',T9(i)+273.15,'p',p1*100,fluid)/1000;
    end
    s9(i)=refpropm('s','t',T9(i)+273.15,'p',p1*100,fluid)/1000;
%     punto 8 con il primo scambiatore. Molto probabilmente in questo punto
%     non viene verificato il primo principio della termodinamica. Per� noi
%     non siamo studiati e ce ne freghiamo. (cambiano le capacit� termiche
%     dei due fluidi: dovremmo andare a verificare il primo principio e poi
%     verificare che il punto 8 non sia superiore del punto 2.
    T8(i)=epsisc1*(T2(i)-T9(i))+T9(i);
    s8(i)=refpropm('s','t',T8(i)+273.15,'p',p1*100,fluid)/1000;
    h8(i)=refpropm('h','t',T8(i)+273.15,'s',s8(i)*1000,fluid)/1000;
    
    %bilanci
%     Lreale(i)=m1*(h0-h2(i));
    h1(i)=q6(i)*h8(i)+(1-q6(i))*h0;     %ho usato il titolo nel punto 6.
    T1(i)=refpropm('t','p',p1*100,'h',h1(i)*1000,fluid)-273.15;
    s1(i)=refpropm('s','t',T1(i)+273.15,'p',p1*100,fluid)/1000;
    %determino i punti dei compressori interrefrigerati
    p10(i)=sqrt(p2(i)*p1);
    s1p(i)=s1(i);
    T1p(i)=refpropm('t','p',p10(i)*100,'s',s1p(i)*1000,fluid)-273.15;
    h1p(i)=refpropm('h','p',p10(i)*100,'s',s1p(i)*1000,fluid)/1000;
    T10(i)=T0;
    s10(i)=refpropm('s','t',T10(i)+273.15,'p',p10(i)*100,fluid)/1000;
    h10(i)=refpropm('h','p',p10(i)*100,'s',s10(i)*1000,fluid)/1000;
    s10p(i)=s10(i);
    p10p(i)=p2(i);
    T10p(i)=refpropm('t','p',p10p(i)*100,'s',s10p(i)*1000,fluid)-273.15;
    h10p(i)=refpropm('h','p',p10p(i)*100,'s',s10p(i)*1000,fluid)/1000;
    %bilanci ancora
    Z(i)=m7(i)/m1;
    %lavoro compressori interrefrigerati
    Lreale(i)=(h1p(i)-h1(i)+h10p(i)-h10(i)-(h3(i)-h4)*y(i))/Z(i); 
    Lmin(i)=(T0+273.15)*(s0-s7(i))-(h0-h7(i));
    eta(i)=Lmin(i)/Lreale(i);
end
pvar1=linspace(p1,pmax,max);
for i=1:length(pvar1)
    Tl(i)=refpropm('t','p',pvar1(i)*100,'q',0,fluid)-273.15;
    Tv(i)=refpropm('t','p',pvar1(i)*100,'q',1,fluid)-273.15;
    sl(i)=refpropm('s','p',pvar1(i)*100,'q',0,fluid)/1000;
    sv(i)=refpropm('s','p',pvar1(i)*100,'q',1,fluid)/1000;
    Tc=refpropm('t','c',0,'',0,fluid)-273.15;
    sc=refpropm('s','c',0,'',0,fluid)/1000;
end
sl(i+1)=sc;
Tl(i+1)=Tc;
sv(i+1)=sc;
Tv(i+1)=Tc;

figure(2)
plot(pvar,y)
title('Y vs Pmax')

figure(3)
plot(pvar,m4,pvar,m7,Z,pvar)
legend('Portata in 4','Portata liquefatta-da integrare','Z')

figure(4)
plot(pvar,eta)
title('\etavsPRESSIONEmax');

figure(5)
plot(pvar,Lmin,pvar,Lreale)
legend('Lavoro minimo','Lavoro reale')

figure(1);
plot(sl,Tl,'b',sv,Tv,'r');
hold on
plot(s0,T0)
text(s0,T0,'0','horizontalalignment','center')
hold on
plot(s1(max),T1(max))
text(s1(max),T1(max),'1','horizontalalignment','center')
hold on
plot(s2(max),T2(max))
text(s2(max),T2(max),'2','horizontalalignment','center')
hold on
plot(s3,T3)
text(s3,T3,'3','horizontalalignment','center')
hold on
plot(s4,T4)
text(s4,T4,'4','horizontalalignment','center')
hold on
plot(s5(max),T5(max))
text(s5(max),T5(max),'5','horizontalalignment','center')
hold on
plot(s6(max),T6(max))
text(s6(max),T6(max),'6','horizontalalignment','center')
hold on
plot(s7(max),T7(max))
text(s7(max),T7(max),'7','horizontalalignment','center')
hold on
plot(s8(max),T8(max))
text(s8(max),T8(max),'8','horizontalalignment','center')
hold on
plot(s9(max),T9(max))
text(s9(max),T9(max),'9','horizontalalignment','center')
hold on
plot(s1p(max),T1p(max))
text(s1p(max),T1p(max),'1p','horizontalalignment','center')
hold on
plot(s10(max),T10(max))
text(s10(max),T10(max),'10','horizontalalignment','center')
hold on
plot(s10p(max),T10p(max))
text(s10p(max),T10p(max),'10p','horizontalalignment','center')
hold on
plot(sA(max),TA(max))
text(sA(max),TA(max),'A','horizontalalignment','center')
hold on
plot(sB(max),TB(max))
text(sB(max),TB(max),'B','horizontalalignment','center')
