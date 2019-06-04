%macro beh_sor;

/* Definere behhf_hn til */

behhf_hn = behhf;
if behhf in (5:26) then behhf_hn = 30;
if behhf in (5:26) then behsh = 400; /* 400 = Andre offentlige sykehus */
*if behsh = 514 then behsh = 241;

format behhf_hn behhf.;

%mend;

%macro bo_sor;
/* Slå sammen alle bohf utenfor Helse Nord */

if bohf in (6:23) then bohf = 25;

if BoShHN = . then BoShHN = 12;

%mend;

%macro ald_gr4;
/* Definer fire aldersgrupper */

if alder in (0:17) then ald_gr4 = 1;
else if alder in (18:49) then ald_gr4 = 2;
else if alder in (50:74) then ald_gr4 = 3;
else if alder in (75:110) then ald_gr4 = 4;

format Ald_gr4 Ald_4Gr.;

%mend;

%macro definer_episodeFag(dsn =);

/* Definere episodeFag hvis ikke definert eller feil */

data &dsn;
set &dsn;

if episodeFag = "" and tjenesteenhetKode = "3652" and behsh in (20,21) then episodeFag = "853"; /* Onkologi */
if episodeFag in ("", "Erg", "FYS", "erg", "0") then episodeFag = "999";

run;

data &dsn;
set &dsn;

if episodeFag = "999" and AvtSpes = 1 then do;
    if fag_skde = 1 then episodeFag = "210";  /* Anestesi */
    if fag_skde = 2 then episodeFag = "220";  /* Barn -> Barnesykdommer */
    if fag_skde = 3 then episodeFag = "230";  /* Fysmed -> Fysikalsk medisin og (re) habilitering */
    if fag_skde = 4 then episodeFag = "200";  /* Gyn -> Kvinnesykdommer og elektiv fødselshjelp */
    if fag_skde = 5 then episodeFag = "240";  /* Hud -> Hud og veneriske sykdommer */
    if fag_skde = 6 then episodeFag = "110";  /* Indremedisin -> Generell indremedisin */
    if fag_skde = 11 then episodeFag = "010"; /* Kirurgi -> Generell kirurgi */
    if fag_skde = 15 then episodeFag = "250"; /* Nevrologi */
    if fag_skde = 18 then episodeFag = "852"; /* Radiologi */
    if fag_skde = 19 then episodeFag = "190"; /* Revmatologi -> Revmatiske sykdommer (revmatologi) */
    if fag_skde = 21 then episodeFag = "290"; /* ØNH -> Øre-nese-hals sykdommer */
    if fag_skde = 22 then episodeFag = "300"; /* Øye -> Øyesykdommer */
end;

run;

%mend;

%macro slett_datasett(datasett =);

Proc datasets nolist;
delete &datasett;
run;

%mend;

%macro unik_pasient(datasett = , variabel =);

/* 
Macro for å markere unike pasienter 

Ny variabel, &variabel._unik, lages i samme datasett
*/

/*1. Sorter på år, aktuell hendelse (merkevariabel), PID, InnDato, UtDato;*/
proc sort data=&datasett;
by aar pid;
run;

/*2. By-statement sørger for at riktig opphold med hendelse velges i kombinasjon med First.-funksjonen og betingelse på hendelse*/
data &datasett;
set &datasett;
&variabel._unik = .;
by aar pid;
if first.pid and &variabel = 1 then &variabel._unik = 1;	
run;

/*proc sort data=&datasett;*/
/*by pid inndato utdato;*/
/*run;*/

%mend;

%macro aggregerMax(dsn = );

proc sql;
   create table &dsn._ut as
   select distinct
          aar, 
          BoRHF, 
          BoHF,
          BoShHN, 
          BehRHF,
	      Behhf_hn,
          BehHF,
          BehSh,
          /* summert liggetid */
            (SUM(liggetid)) as liggetid, 
          /* summert korrvekt */
            (SUM(korrvekt)) as drg_poeng, 
          /* antall pasienter */
            (SUM(kontakt)) as kontakter,
          /* rate bosh */
            (SUM(bohf_rate)) as bohf_rate,
          /* rate bohf */
            (SUM(bosh_rate)) as bosh_rate,
          /* rate bosh */
            (SUM(bohf_drgrate)) as bohf_drgrate,
          /* rate bohf */
            (SUM(bosh_drgrate)) as bosh_drgrate,
          /* liggetidsrate bosh */
            (SUM(bosh_liggerate)) as bosh_liggerate,
          /* liggetidsrate bohf */
            (SUM(bohf_liggerate)) as bohf_liggerate,
          /* liggetidsrate bohf */
            (SUM(borhf_liggerate)) as borhf_liggerate

from &dsn
      group by aar,
               BoShHN,
               BehSh,
               BoHF,
               Behhf_hn,
               BehHF;
quit;

%mend;


%macro definerBehandler(dsn=);

/*
1="Eget lokalsykehus"
2="UNN Tromsø"
3="NLSH Bodø"
4="Annet sykehus i eget HF"
5="Annet HF i HN"
6="HF i andre RHF"
7="Private sykehus"
8="Avtalespesialister"
9="UNN HF"
10="NLSH HF"
*/

data &dsn;
set &dsn;

/*
Kirkenes
*/
If BoSHHN=1 then do;
	If BehSh in (10,11) then Behandler=1;
	else if BehSh in (21) then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSH in (12) then Behandler=4;
	else if BehSh in (22,23,31,32,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Hammerfest
*/
If BoSHHN=2 then do;
	If BehSh in (10,12) then Behandler=1;
	else if BehSh in (21) then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSH in (11) then Behandler=4;
	else if BehSh in (22,23,31,32,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Tromsø
*/
If BoSHHN=3 then do;
	If BehSh in (21) then Behandler=1;
*	else if BehSh=21 then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSH in (22,23) then Behandler=4;
	else if BehSh in (10,11,12,31,32,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Harstad
*/
If BoSHHN=4 then do;
	If BehSh in (22) then Behandler=1;
	else if BehSh in (21) then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSH in (23) then Behandler=4;
	else if BehSh in (10,11,12,31,32,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Narvik
*/
If BoSHHN=5 then do;
	If BehSh in (23) then Behandler=1;
	else if BehSh in (21) then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSH in (22) then Behandler=4;
	else if BehSh in (10,11,12,31,32,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Vesterålen
*/
If BoSHHN=6 then do;
	If BehSh in (31) then Behandler=1;
	else if BehSh in (21) then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSH=32 then Behandler=4;
	else if BehSh in (10,11,12,22,23,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Lofoten
*/
If BoSHHN=7 then do;
	If BehSh in (32) then Behandler=1;
	else if BehSh in (21) then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSH=31 then Behandler=4;
	else if BehSh in (10,11,12,22,23,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Bodø
*/
If BoSHHN=8 then do;
	If BehSh in (33) then Behandler=1;
	else if BehSh in (21) then Behandler=2;
/*	else if BehSh=33 then Behandler=3;*/
	else if BehSH in (31,32) then Behandler=4;
	else if BehSh in (10,11,12,22,23,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Rana
*/
If BoSHHN=9 then do;
	If BehSh in (40,41) then Behandler=1;
	else if BehSh in (21) then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSH in (42,43) then Behandler=4;
	else if BehSh in (10,11,12,22,23,31,32) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Mosjøen
*/
If BoSHHN=10 then do;
	If BehSh in (40,42) then Behandler=1;
	else if BehSh in (21) then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSH in (41,43) then Behandler=4;
	else if BehSh in (10,11,12,22,23,31,32) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Sandnessjøen
*/
If BoSHHN=11 then do;
	If BehSh in (40,43) then Behandler=1;
	else if BehSh in (21) then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSH in (41,42) then Behandler=4;
	else if BehSh in (10,11,12,22,23,31,32) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Utenfor Helse Nord
*/
If BoSHHN=12 then do;
	if BehSh in (21) then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSh in (10,11,12,22,23,31,32,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

format behandler behandler.;

run;

%mend;
