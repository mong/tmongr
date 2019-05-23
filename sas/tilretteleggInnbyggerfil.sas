%macro tilretteleggInnbyggerfil();

/*
Returnerer fire datasett:
- borhf_innbygg
- bohf_innbygg
- bosh_innbygg
- ald_just
*/

data innbygg;
set innbygg.innb_2004_2017_bydel_allebyer;
  where aar in (2013:2017);
  %boomraader;
run;

data innbygg;
set innbygg;
  %ald_gr4;
  %bo_sor;
run;

/* lage tmp-tabell for kjønns- og aldersjustering */

proc sql;
create table tmp_pop as
select distinct
   aar,
	ald_gr4,
   ermann,
	(SUM(innbyggere)) as innb
from innbygg
group by
   aar,
	ald_gr4,
   ermann;
quit;


proc sql;
create table tmp_pop_tot as
select distinct
    aar,
	(SUM(innbyggere)) as innb_tot
from innbygg
group by
    aar;
quit;

proc sql;
create table ald_just as
select *
from tmp_pop left join tmp_pop_tot
on 
tmp_pop.aar=tmp_pop_tot.aar;
quit;


data ald_just;
set ald_just;
faktor = innb/innb_tot;
drop innb_tot innb;
run;


/* Antall innbyggere i bosh*/

proc sql;
create table bosh_innbygg as
select distinct
          aar,
          ald_gr4,
          ermann,
          BoRHF, 
          BoHF, 
          BoShHN,
          /* summert innbyggere */
            (SUM(innbyggere)) as bosh_innb
from innbygg
group by
          aar,
          ald_gr4,
          ermann,
          BoRHF, 
          BoHF, 
          BoShHN;
quit;

/* Antall innbyggere i bohf*/

proc sql;
create table bohf_innbygg as
select distinct
          aar,
          ald_gr4,
          ermann,
          BoRHF,
          BoHF, 
          /* summert innbyggere */
            (SUM(innbyggere)) as bohf_innb
from innbygg
group by
          aar,
          ald_gr4,
          ermann,
          BoRHF, 
          BoHF;
quit;

/* Antall innbyggere i borhf*/

proc sql;
create table borhf_innbygg as
select distinct
          aar,
          ald_gr4,
          ermann,
          BoRHF,
          /* summert innbyggere */
            (SUM(innbyggere)) as borhf_innb
from innbygg
group by
          aar,
          ald_gr4,
          ermann,
          BoRHF;
quit;


%slett_datasett(datasett = tmp_pop);
%slett_datasett(datasett = tmp_pop_tot);
%slett_datasett(datasett = innbygg);

%mend;
