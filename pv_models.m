%% ====== MODEL JOAN MARC ======
nmodel=1;

for Ti = [25,45]
for Gi = [600,800,1000]

T = Ti+273;%25+273;
G = Gi;

Gstc = 1000;
Tstc = 25+273;

% Num cells series and parallel
Ncells = 144/2;
Ncellp = 2;

Ns = 1;
Np = 1;

I = [];
V = [];

a = 1.1;
k = 1.3807e-23;
q = 1.6022e-19;
Is0 = 1e-10;
Iph_sc = 13.86/Ncellp;


for Vi = [0:1:60];%[0:0.01:1]
	Vcell = Vi/Ns/Ncells;
	Iph = Iph_sc * G/Gstc;
	Is = Is0 * 2.^((T-Tstc)./5);	
	Id = Is * (exp(Vcell.*q./(a.*k.*T)) - 1);
	Icell = Iph - Id;
	Ii = Icell*Ncellp*Np;

	I = [I, max(Ii,0)];		
	V = [V, Vi];
end

P = V.*I;

fig=figure(2*nmodel-1);
set(fig,'units','inches','position',[5,5,2.4,1.4],'defaultaxesfontsize',8)
plot(V,I, "linewidth",1);
axis([0,55,0,15])
box("off")
ylabel("Current (A)")
xlabel("Voltage (V)")
hold on
fig=figure(2*nmodel);
set(fig,'units','inches','position',[5,5,2.4,1.4],'defaultaxesfontsize',8)
plot(V,P, "linewidth",1);
axis([0,55,0,600])
box("off")
ylabel("Power (W)")
xlabel("Voltage (V)")
hold on

end
end


%% ====== MODEL EN50530 MPPT ======
nmodel=2;

for Ti = [25,45]
for Gi = [600, 800, 1000]

T = Ti+273;%25+273;
G = Gi;

Gstc = 1000;
Tstc = 25+273;

% Num modules series and parallel
Ns = 1;
Np = 1;

I = [];
V = [];

Vmpp = 41.64*Ns;
Impp = 12.97*Np;
Vocstc = 49.60*Ns;
Iscstc = 13.86*Np;

KI = 0.045/100;
KV = -0.275/100;
Cg = 2.514e-3;
Cv = 0.08593;
Cr = 1.088e-4;

FFv = Vmpp/Vocstc;
FFi = Impp/Iscstc;
Caq = (FFv-1)/log(1-FFi);

Isc = Iscstc * (G/Gstc)*(1+KI*(T-Tstc));
I0 = Iscstc * (G/Gstc)*(1-FFi)^(1/(1-FFv));

Voc = Vocstc * (1+KV*(T-Tstc))*(log(G/Cg+1)*Cv-Cr*G);

for Vi = [0:1:60]
	Vmod = Vi/Ns;
	Ii = Isc-I0*(exp(Vmod/(Voc*Caq))-1);
	Ii = Ii*Np;

	I = [I, max(Ii,0)];		
	V = [V, Vi];
end

P = V.*I;

fig=figure(2*nmodel-1);
set(fig,'units','inches','position',[5,5,2.4,1.4],'defaultaxesfontsize',8)
plot(V,I, "linewidth",1);
axis([0,55,0,15])
box("off")
ylabel("Current (A)")
xlabel("Voltage (V)")
%set(fig,'units','inches','position',[5,5,3.4,2])
hold on
fig=figure(2*nmodel);
set(fig,'units','inches','position',[5,5,2.4,1.4],'defaultaxesfontsize',8)
plot(V,P, "linewidth",1);
axis([0,55,0,600])
box("off")
ylabel("Power (W)")
xlabel("Voltage (V)")
%set(fig,'units','inches','position',[5,5,3.4,2])
hold on

end
end



%% ====== MODEL BELLINI ======
%nmodel=3;
%
%for Ti = [25,45]
%for Gi = [600, 800, 1000]
%
%T = Ti+273;%25+273;
%G = Gi;
%
%Gstc = 1000;
%Tstc = 25+273;
%
%DT = T-Tstc;
%
%% Num modules series and parallel
%Ns = 1;
%Np = 1;
%
%I = [];
%V = [];
%
%Vmppstc = 41.64*Ns;
%Imppstc = 12.97*Np;
%Vocstc = 49.60*Ns;
%Iscstc = 13.86*Np;
%
%KI = 0.045/100;
%KV = -0.275/100;
%
%
%
%% DV
%Vocm = C
%DV = Vocstc-Vocm;
%
%% sc and oc
%Isc = Iscstc*G/Gstc*(1+KI*DT);
%Voc = Vocstc*(1+KV*DT)-DV;
%
%% mpp
%Impp = Imppstc*G/Gstc*(1+KI*DT);
%Vmpp = Vmppstc*(1+KV*DT)-DV;
%
%% C2
%C2 = (Vmpp/Voc-1)/(log(1-Impp/Isc));
%
%% C1
%C1 = (1-Impp/Isc)*exp(-Vmpp/C2/Voc);
%
%
%for Vi = [0:1:60]
%	Vmod = Vi/Ns;
%	Ii = Isc*(1-C1*(exp(vmod/C2/Voc)-1));
%	Ii = Ii*Np;
%
%	I = [I, max(Ii,0)];		
%	V = [V, Vi];
%end
%
%P = V.*I;
%
%fig=figure(2*nmodel-1);
%set(fig,'units','inches','position',[5,5,2.4,1.4],'defaultaxesfontsize',8)
%plot(V,I, "linewidth",1);
%axis([0,55,0,15])
%box("off")
%ylabel("Current (A)")
%xlabel("Voltage (V)")
%%set(fig,'units','inches','position',[5,5,3.4,2])
%hold on
%fig=figure(2*nmodel);
%set(fig,'units','inches','position',[5,5,2.4,1.4],'defaultaxesfontsize',8)
%plot(V,P, "linewidth",1);
%axis([0,55,0,600])
%box("off")
%ylabel("Power (W)")
%xlabel("Voltage (V)")
%%set(fig,'units','inches','position',[5,5,3.4,2])
%hold on
%
%end
%end


%% ====== MODEL DE SOTO ======
nmodel=4;

for Ti = [25,45]
for Gi = [600, 800, 1000]

T = Ti+273;%25+273;
G = Gi;
M = 1.5; % assume Mstc

Gstc = 1000;
Tstc = 25+273;
Mstc = 1.5;

DT = T-Tstc;

% Num modules series and parallel
Ns = 1;
Np = 1;

% Num cells series and parallel
Ncells = 144/2;
Ncellp = 2;

I = [];
V = [];

Vocstc = 49.60/Ncells;
Iscstc = 13.86/Ncellp;

KI = 0.045/100;
KV = -0.275/100;

a = 1.026;
k = 1.3807e-23; % J/K
k_evK = 8.6617333262e-5; % eV/K
q = 1.6022e-19;
Rs = 0.2/Ncells; % Rs of the cell
Rpstc = 500/Ncells; % Rp of the cell
Rp = Rpstc*Gstc/G;
Egstc = 1.12;
dEgdT = 0.0002677;
I0stc = 1e-10; % assume

Eg = Egstc*(1-dEgdT*DT);

Iphstc = Iscstc; % assume
Iph = G/Gstc*M/Mstc*Iphstc*(1+KI*DT);

I0 = I0stc*(T/Tstc)^3*exp((Egstc/(k_evK*Tstc)-Eg/(k_evK*T)));
Vt = k*T/q; 

for Vi = [0:1:60]
	if (size(I)>0) && (I(end)<=0)
		I = [I,0];
		V = [V,Vi];
		continue
	end
	
	Vicell = Vi/Ncells/Ns;

	e = 1e6;
	Ii = Iscstc/Ncellp;
	while e >= 1e-6
	Iprev = Ii;
	Vd = Vicell+Ii*Rs;
	
	Id = I0*(exp(Vd/(a*Vt))-1);
	Ii = Iph - Id - Vd/Rp;
	e = abs(Ii - Iprev);
	if (Ii<=0)% && (Iprev<=0)
		break
	end
	end
	I = [I, max(Ii*Ncellp*Np,0)];		
	V = [V, Vi];
end

P = V.*I;

fig=figure(2*nmodel-1);
set(fig,'units','inches','position',[5,5,2.4,1.4],'defaultaxesfontsize',8)
plot(V,I, "linewidth",1);
axis([0,55,0,15])
box("off")
ylabel("Current (A)")
xlabel("Voltage (V)")
%set(fig,'units','inches','position',[5,5,3.4,2])
hold on
fig=figure(2*nmodel);
set(fig,'units','inches','position',[5,5,2.4,1.4],'defaultaxesfontsize',8)
plot(V,P, "linewidth",1);
axis([0,55,0,600])
box("off")
ylabel("Power (W)")
xlabel("Voltage (V)")
%set(fig,'units','inches','position',[5,5,3.4,2])
hold on

end
end


%% ====== MODEL EN50530 ALT ======
%nmodel=5;
%
%for Ti = [25,45]
%for Gi = [600, 800, 1000]
%
%T = Ti+273;%25+273;
%G = Gi;
%Tamb = 20+273;
%
%Gstc = 1000;
%Tstc = 25+273;
%
%% Num modules series and parallel
%Ns = 1;
%Np = 1;
%
%I = [];
%V = [];
%
%Vocstc = 49.60/Ncells;
%Iscstc = 13.86/Ncellp;
%
%a = 1.113;
%k = 1.3807e-23;
%k_evK = 8.6617333262e-5; % eV/K
%q = 1.6022e-19;
%Rs = 47.731e-3;
%Rp = 11.173;
%Iphstc = 1*Iscstc;
%C0 = 101.668;
%Eg = 1.1;
%
%Iph = Iphstc*G/Gstc;
%I0 = C0*T^3*exp(Eg/(k_evK*Tamb));
%Vt = k*T/q;
%
%c = 0;
%for Vi = [0:1:60]
%	Vcell = Vi/Ncells/Ns;
%
%	e = 1e6;
%	Ii = 0;
%	while e >= 1e-6
%	Iprev = Ii;
%	Vd = Vcell+Ii*Rs;
%	Ii = Iph-I0*(exp(Vd/(a*Vt))-1)-Vd/Rp;
%	e = abs(Ii - Iprev);
%	c = c+1;
%	if ((Ii<=0) && (Iprev<=0))  || (c > 10)
%		break
%	end
%	end
%	I = [I, max(Ii*Ncellp*Np,0)];		
%	V = [V, Vi];
%end
%
%P = V.*I;
%
%fig=figure(2*nmodel-1);
%set(fig,'units','inches','position',[5,5,2.4,1.4],'defaultaxesfontsize',8)
%plot(V,I, "linewidth",1);
%axis([0,55,0,15])
%box("off")
%ylabel("Current (A)")
%xlabel("Voltage (V)")
%%set(fig,'units','inches','position',[5,5,3.4,2])
%hold on
%fig=figure(2*nmodel);
%set(fig,'units','inches','position',[5,5,2.4,1.4],'defaultaxesfontsize',8)
%plot(V,P, "linewidth",1);
%axis([0,55,0,600])
%box("off")
%ylabel("Power (W)")
%xlabel("Voltage (V)")
%%set(fig,'units','inches','position',[5,5,3.4,2])
%hold on
%
%end
%end


%% ====== MODEL VILLALVA ======
nmodel=6;

for Ti = [25,45]
for Gi = [600,800,1000]

T = Ti+273;%25+273;
G = Gi;
Tamb = 25+273;

Gstc = 1000;
Tstc = 25+273;

% Num modules series and parallel
Ns = 1;
Np = 1;

% Num cells series and parallel
Ncells = 144/2;
Ncellp = 2;

I = [];
V = [];

a = 1.113;
k = 1.3807e-23;
q = 1.6022e-19;
Rs = 0.2/Ncells; % Rs of the cell
Rp = 500/Ncells; % Rp of the cell

Vocstc = 49.60/Ncells;
Iscstc = 13.86/Ncellp;
KI = 0.045/100;
KV = -0.275/100;

%a = 1.3;
%Vocstc = 32.9/54;
%Iscstc = 8.21;
%KI = 0.0032;
%KV = -0.1230/54; Ns = 54 --> si ens donen KV o KI en absolut cal tenir-ho en compte
%Rp = 415.405;
%Rs = 0.221/54;

DT = T-Tstc;

Iphstc = (Rp+Rs)/Rp*Iscstc;
Iph = Iphstc*(1+KI*DT)*G/Gstc;
Vt = k*T/q;
I0 = Iscstc*(1+KI*DT)/(exp(Vocstc*(1+KV*DT)/(a*Vt))-1);

%I0 = (Iscstc+KI*DT)/(exp((Vocstc+KV*DT)/(a*Vt))-1); si tenim KV KI en valor absolut
for Vi = [0:1:60]
	if (size(I)>0) && (I(end)<=0)
		I = [I,0];
		V = [V,Vi];
		continue
	end
	
	Vicell = Vi/Ncells;
	e = 1e6;
	Ii = Iscstc;
	while e >= 1e-6
	Iprev = Ii;
	Vd = Vicell+Ii*Rs;
	Ii = Iph-I0*(exp(Vd/(a*Vt))-1)-Vd/Rp;
	e = abs(Ii - Iprev);
	if (Ii<=0) && (Iprev<=0)
		break
	end
	end
	I = [I, max(Ii*Ncellp,0)];		
	V = [V, Vi];
end

P = V.*I;

fig=figure(2*nmodel-1);
set(fig,'units','inches','position',[5,5,2.4,1.4],'defaultaxesfontsize',8)
plot(V,I, "linewidth",1);
axis([0,55,0,15])
box("off")
ylabel("Current (A)")
xlabel("Voltage (V)")
%set(fig,'units','inches','position',[5,5,3.4,2])
hold on
fig=figure(2*nmodel);
set(fig,'units','inches','position',[5,5,2.4,1.4],'defaultaxesfontsize',8)
plot(V,P, "linewidth",1);
axis([0,55,0,600])
box("off")
ylabel("Power (W)")
xlabel("Voltage (V)")
%set(fig,'units','inches','position',[5,5,3.4,2])
hold on

end
end

