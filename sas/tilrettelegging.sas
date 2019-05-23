%macro tilrettelegging(datainn = , dataut = );

/*
Behold den linjen pr. EoC med max korrvekt (drg-poeng)
*/

proc sql;
create table tabell_tmp as
select *, max(korrvekt) as max_korrvekt
from &datainn
group by PID,EoC_nr_pid;
QUIT;

data tabell_tmp;
set tabell_tmp;
where korrvekt = max_korrvekt;
firsteoc = .;
run;

proc sort data=tabell_tmp;
by eoc_id;
run;

data tabell_tmp;
set tabell_tmp;
by EoC_id;
if first.eoc_id then firsteoc = 1;
run;

data tabell_tmp;
set tabell_tmp;
where firsteoc = 1;
aar = eoc_aar;
alder = eoc_alder;
liggetid = eoc_liggetid;
hastegrad = eoc_hastegrad;
aktivitetskategori3 = eoc_aktivitetskategori3;
run;

/*
Kun beholde relevante variabler
*/
data tabell_alle2;
set tabell_tmp;
keep aar alder ermann korrvekt liggetid
BoShHN BoHF BoRHF BehSh BehHF BehRHF
Aktivitetskategori3 hastegrad ICD10Kap
DRGtypeHastegrad kontakt hdg episodeFag tjenesteenhetKode fag_skde AvtSpes;
kontakt = 1;
if fag_skde = . then fag_skde = 99;
run;

data tabell_alle2;
set tabell_alle2;
if drgtypehastegrad = . then drgtypehastegrad = 9;
if Aktivitetskategori3 = 3 then drgtypehastegrad = 9;
run;

%definer_episodeFag(dsn = tabell_alle2);

/*
slå sammen sykehus og HF fra sør-norge, og lag aldersgrupper
*/
data &dataut;
set tabell_alle2;
  %beh_sor;
  %bo_sor;
  %ald_gr4;
  format BehHF BehHF.;
run;


%mend;
