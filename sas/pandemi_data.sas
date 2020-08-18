
data off_tot;
set hnana.t20t1_magnus_avd_2019;
where aar = 2019 and (BehRHF = 1 or BoRHF = 1) and (BoRHF in (1:4));
run;


data parvus;
set hnana.t20t1_parvus_avd_2019;
run;

proc sql;
create table off_tot as
select *
from off_tot, parvus(keep=koblingsID DRGtypeHastegrad tjenesteenhetKode npkopphold_poengsum)
where off_tot.koblingsID = parvus.koblingsID;
quit;


/*
Koble på korrvekt fra sho
*/

/* Ikke enda...
%let fil = sho;
data sho;
set skde19.&taar._magnus_&fil._2014 skde19.&taar._magnus_&fil._2015 skde19.&taar._magnus_&fil._2016 skde19.&taar._magnus_&fil._2017 skde19.&taar._magnus_&fil._2018;
where (BehRHF = 1 or BoRHF = 1) and (BoRHF in (1:4));
run;
%let fil = avd;


%henteKorrvekt(avdfil = off_tot, shofil = sho);
*/

/*
Lage datasett med innbyggere (brukes i rater_og_aggr)
*/
%tilretteleggInnbyggerfil();

/*
Sette sammen off og priv
*/
data tabell_alle;
set off_tot;* priv_tot;
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
   korrvekt = npkopphold_poengsum;
   %boomraader;
run;

/*
EoC der hvert sykehus blir behandlet for seg og polikliniske konsultasjoner er egne EoC
*/

%Episode_of_care(dsn=tabell_alle, separer_ut_poli = 1, inndeling = 3);


/*
Rydde før rater og aggregering
*/

%let datasett = tabell_klargjor;
%tilrettelegging(datainn = tabell_alle, dataut = &datasett);

/*
Normal
*/
%rater_og_aggr(dsn = &datasett, behandler = 1, grupperinger = 1);

proc export data=&datasett._ut
outfile="&prosjekt_filbane\tmongrdata\avd_behandler_2019.csv"
dbms=csv
replace;
run;

/*
ICD10
*/

/*
%rater_og_aggr(dsn = &datasett, behandler = 1, grupperinger = 0, icd = 1);

proc export data=&datasett._ut
outfile="&prosjekt_filbane\tmongrdata\&fil._icd10&taar..csv"
dbms=csv
replace;
run;
*/

/*
fagområde
*/
%rater_og_aggr(dsn = &datasett, behandler = 1, grupperinger = 0, fag = 1);

proc export data=&datasett._ut
outfile="&prosjekt_filbane\tmongrdata\avd_fagomr_2019.csv"
dbms=csv
replace;
run;



/******************************************************
Kjøre samme kode igjen, med justering for overføringer 

- kjøre EoC makro med inndeling = 0
*******************************************************/


data tabell_alle;
set off_tot;* priv_tot;
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
   korrvekt = npkopphold_poengsum;

   %boomraader;
run;

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
outfile="&prosjekt_filbane\tmongrdata\avd_justoverf_2019.csv"
dbms=csv
replace;
run;
