/* lage sett for tabellverk-generering */

%let taar = t19;
%let fil = avd;

data off_tot;
set skde19.&taar._magnus_&fil._2014 skde19.&taar._magnus_&fil._2015 skde19.&taar._magnus_&fil._2016 skde19.&taar._magnus_&fil._2017 skde19.&taar._magnus_&fil._2018;
where (BehRHF = 1 or BoRHF = 1) and (BoRHF in (1:4));
run;

data priv_tot;
set skde19.&taar._magnus_avtspes_2014 skde19.&taar._magnus_avtspes_2015 skde19.&taar._magnus_avtspes_2016 skde19.&taar._magnus_avtspes_2017 skde19.&taar._magnus_avtspes_2018;
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
Legg på DRGtypeHastegrad og tjenesteenhetKode fra parvus 
(tjenesteenhetKode for å finne stråleterapienhet ved UNN)
*/
%varFraParvus(dsnMagnus = off_tot, var_som = DRGtypeHastegrad tjenesteenhetKode, taar = 19);

/*
Koble på korrvekt fra sho
*/
%let fil = sho;
data sho;
set skde19.&taar._magnus_&fil._2014 skde19.&taar._magnus_&fil._2015 skde19.&taar._magnus_&fil._2016 skde19.&taar._magnus_&fil._2017 skde19.&taar._magnus_&fil._2018;
where (BehRHF = 1 or BoRHF = 1) and (BoRHF in (1:4));
run;
%let fil = avd;

%henteKorrvekt(avdfil = off_tot, shofil = sho);

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
outfile="&prosjekt_filbane\csv_filer\&fil._behandler&taar..csv"
dbms=csv
replace;
run;

/*
ICD10
*/
%rater_og_aggr(dsn = &datasett, behandler = 1, grupperinger = 0, icd = 1);

proc export data=&datasett._ut
outfile="&prosjekt_filbane\csv_filer\&fil._icd10&taar..csv"
dbms=csv
replace;
run;

/*
fagområde
*/
%rater_og_aggr(dsn = &datasett, behandler = 1, grupperinger = 0, fag = 1);

proc export data=&datasett._ut
outfile="&prosjekt_filbane\csv_filer\&fil._fag&taar..csv"
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
outfile="&prosjekt_filbane\csv_filer\&fil._justoverf&taar..csv"
dbms=csv
replace;
run;


