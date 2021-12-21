%include "&filbane\formater\SKDE_somatikk.sas";
%include "&filbane\formater\NPR_somatikk.sas";
%include "&filbane\formater\bo.sas";
%include "&filbane\formater\beh.sas";

options sasautos=("&filbane\makroer" SASAUTOS);

%include "&sasmappe\formater.sas";
%include "&sasmappe\macroer.sas";
%include "&sasmappe\rater_og_aggr.sas";
%include "&sasmappe\tilrettelegging.sas";
%include "&sasmappe\tilretteleggInnbyggerfil.sas";

%include "&filbane\makroer\boomraader.sas";


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
behandlingsstedkode2
BehHF
BehRHF
behSh
drg
drg_type
HDG
liggetid
polUtforende_1
utTilstand 
intern_kons
niva
npkOpphold:
/*npkOpphold_ISFPoeng*/
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
Episodefag
hastegrad
ICD10Kap
hdiag3tegn
fag_skde
AvtSpes
;

/* lage sett for tabellverk-generering */
data off_tot;
set 
hnana.sho_2017_t21m07 (keep=&magnus_som)
hnana.sho_2018_t21m07 (keep=&magnus_som)
hnana.sho_2019_t21m07 (keep=&magnus_som)
hnana.sho_2020_t21m07 (keep=&magnus_som)
;
where (BehRHF = 1 or BoRHF = 1) and (BoRHF in (1:4));
run;

data priv_tot;
set
hnana.aspes_2017_t20t2 (keep=&magnus_aspes)
hnana.aspes_2018_t20t2 (keep=&magnus_aspes)
hnana.aspes_2019_t20t2 (keep=&magnus_aspes)
hnana.aspes_2020_t20t3 (keep=&magnus_aspes)
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
Lage datasett med innbyggere (brukes i rater_og_aggr)
*/
%tilretteleggInnbyggerfil();

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

run;

%boomraader(inndata = tabell_alle);

/*
Sykehusopphold der hvert sykehus blir behandlet for seg og
polikliniske konsultasjoner er eget opphold
*/

%include "&filbane\makroer\sykehusopphold.sas";

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
Normal
*/
%rater_og_aggr(dsn = &datasett, behandler = 1, grupperinger = 1);

filename output "&prosjekt_filbane\tmongrdata\behandler.csv" encoding="utf-8" termstr=lf;
proc export data=&datasett._ut
outfile=output
dbms=csv
replace;
run;

/*
ICD10
*/
%rater_og_aggr(dsn = &datasett, behandler = 1, grupperinger = 0, icd = 1);

filename output "&prosjekt_filbane\tmongrdata\icd10.csv" encoding="utf-8" termstr=lf;
proc export data=&datasett._ut
outfile=output
dbms=csv
replace;
run;

/*
fagområde
*/
%rater_og_aggr(dsn = &datasett, behandler = 1, grupperinger = 0, fag = 1);

filename output "&prosjekt_filbane\tmongrdata\fag.csv" encoding="utf-8" termstr=lf;
proc export data=&datasett._ut
outfile=output
dbms=csv
replace;
run;



/******************************************************
Kjøre samme kode igjen, med justering for overføringer 

- kjøre EoC makro med inndeling = 0
*******************************************************/


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

run;

%boomraader(inndata = tabell_alle);

/*
EoC justert for overføringer
*/

%Episode_of_care(dsn=tabell_alle, separer_ut_poli = 1, inndeling = 0);


/*
Rydde før rater og aggregering
*/
%let datasett = tabell_klargjor;
%tilrettelegging(datainn = tabell_alle, dataut = &datasett);

/*
Justert for overføringer
*/
%rater_og_aggr(dsn = &datasett, behandler = 1, grupperinger = 1);

proc export data=&datasett._ut
outfile="&prosjekt_filbane\csv_filer\justoverf.csv"
dbms=csv
replace;
run;


