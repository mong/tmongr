%let filbane=/sas_smb/skde_analyse/Data/SAS/felleskoder/main;
%let sasmappe = /sas_smb/skde_analyse/Brukere/Arnfinn/repo/tmongr/sas;
%let prosjekt_filbane = /sas_smb/skde_analyse/Brukere/Arnfinn/repo;

%include "&filbane/formater/SKDE_somatikk.sas";
%include "&filbane/formater/NPR_somatikk.sas";
%include "&filbane/formater/bo.sas";
%include "&filbane/formater/beh.sas";

options sasautos=("&filbane/makroer" SASAUTOS);

%include "&sasmappe/formater.sas";
%include "&sasmappe/macroer.sas";
%include "&sasmappe/rater_og_aggr.sas";
%include "&sasmappe/tilrettelegging.sas";
%include "&sasmappe/tilretteleggInnbyggerfil.sas";

%include "&filbane/makroer/boomraader.sas";

%let magnus_som=
pid
aar
inndato
utdato
ErMann
alder
komnr
bydel
bohf
borhf
boshhn
Fylke
NPRId_reg
fodselsar
dodDato
institusjonId
debitor
Episodefag
hastegrad
ICD10Kap
hdiag3tegn
InnTid
UtTid
aktivitetskategori3
aktivitetskategori
/*behandlingsstedkode2*/
BehHF
BehRHF
behSh
drg
drg_type
HDG
liggetid
polUtforende_1
utTilstand 
niva
npkOpphold:
dag_kir
aggrshoppID_Lnr
;

%let magnus_aspes=
pid
aar
inndato
utdato
ErMann
alder
komnr
bydel
bohf
borhf
boshhn
Fylke
NPRId_reg
fodselsar
dodDato
institusjonId
debitor
hastegrad
ICD10Kap
hdiag3tegn
fag_skde
/*AvtSpes*/
;

/* lage sett for tabellverk-generering */
data off_tot;
set 
HNANA.SHO_2017_T3 (keep=&magnus_som)
HNANA.SHO_2018_T3 (keep=&magnus_som)
HNANA.SHO_2019_T3 (keep=&magnus_som)
HNANA.SHO_2020_T3 (keep=&magnus_som)
HNANA.SHO_2021_T3 (keep=&magnus_som)
HNANA.SHO_2022_T3 (keep=&magnus_som)
HNANA.SHO_2023_T3 (keep=&magnus_som)
;
where (BehRHF = 1 or BoRHF = 1) and (BoRHF in (1:4));
run;

data priv_tot;
set
HNANA.ASPES_2017_T3 (keep=&magnus_aspes)
HNANA.ASPES_2018_T3 (keep=&magnus_aspes)
HNANA.ASPES_2019_T3 (keep=&magnus_aspes)
HNANA.ASPES_2020_T3 (keep=&magnus_aspes)
HNANA.ASPES_2021_T3 (keep=&magnus_aspes)
HNANA.ASPES_2022_T3 (keep=&magnus_aspes)
HNANA.ASPES_2023_T3 (keep=&magnus_aspes)
;
where (BoRHF = 1) and (alder ne .);
BehHF = 28;
BehRHF = 6;
behSh = 500;
liggetid = 0;
Aktivitetskategori3 = 3;
hastegrad = 4;
AvtSpes = 1;
run;

/*
Sette sammen off og priv
*/
data tabell_alle;
set off_tot priv_tot;
if length(compress(episodefag)) = 2 then episodefag = compress("0"||episodefag);
   format ermann ermann.;
   format BehRHF BehRHF.;
   format fag_skde Fag_SKDE.;
   format episodeFag episodeFag.;
   format drgtypehastegrad drgtypehastegrad.;
   /* Ukjent hastegrad */
   if (hastegrad eq .) then hastegrad = 9;
   /* 
   Hastegrad "Tilbakeføring av pasient fra annet sykehus" settes til "Planlagt" 
   Meget få kontakter i 2017, så lager bare støy
   */
   if (hastegrad eq 5) then hastegrad = 4;
   if institusjonid = 974116804 then do;
     behsh = 230;
	  behhf = 23;
	  behrhf = 4;
   end;
run;

%boomraader(inndata = tabell_alle);

/*
Sykehusopphold der hvert sykehus blir behandlet for seg og
polikliniske konsultasjoner er eget opphold
*/


%include "&filbane/makroer/sykehusopphold.sas";

%sykehusopphold(dsn=tabell_alle);


/*
Rydde før rater og aggregering
*/

%let datasett = tabell_klargjor;
%tilrettelegging(datainn = tabell_alle, dataut = &datasett);

/*
Lage datasett med innbyggere (brukes i rater_og_aggr)
*/
%tilretteleggInnbyggerfil();

/*
fagområde
*/
%rater_og_aggr(dsn = &datasett, behandler = 1, grupperinger = 0, fag = 1);

options nobomfile;
filename output "&prosjekt_filbane/tmongrdata/fag.csv" encoding="utf-8" termstr=lf;
proc export data=&datasett._ut
outfile=output
dbms=csv
replace;
run;


/*
Uten "sykehusopphold"
*/

%tilrettelegging(datainn = tabell_alle, dataut = &datasett, sho = 0);

%tilretteleggInnbyggerfil();

%rater_og_aggr(dsn = &datasett, behandler = 1, grupperinger = 0, fag = 1);

options nobomfile;
filename output "&prosjekt_filbane/tmongrdata/fag2.csv" encoding="utf-8" termstr=lf ;
proc export data=&datasett._ut
outfile=output
dbms=csv
replace;
run;
