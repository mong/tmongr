%macro tilretteleggInnbyggerfil(just_aar = 2020);

/*
Returnerer fire datasett:
- borhf_innbygg
- bohf_innbygg
- bosh_innbygg
- ald_just

Variablen `just_aar` bestemmer justeringsår
*/

data innbygg;
set innbygg.innb_skde_bydel;
  where aar > 2016;
run;

%boomraader(inndata = innbygg);

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
create table tmp_ald_just as
select *
from tmp_pop left join tmp_pop_tot
on 
tmp_pop.aar=tmp_pop_tot.aar;
quit;

data tmp_fakt;
set tmp_ald_just;
where aar = &just_aar;
faktor = innb/innb_tot;
drop innb_tot innb aar;
run;

proc sql;
create table ald_just as
select *
from tmp_ald_just left join tmp_fakt
on
tmp_ald_just.ald_gr4=tmp_fakt.ald_gr4 and
tmp_ald_just.ermann=tmp_fakt.ermann;
quit;

data ald_just;
set ald_just;
drop innb innb_tot;
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
%slett_datasett(datasett = tmp_ald_just);
%slett_datasett(datasett = tmp_fakt);

%mend;
