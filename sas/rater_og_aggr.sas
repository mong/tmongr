%macro rater_og_aggr(dsn =, behandler = 1, grupperinger = 0, hdg = 0, icd = 0, fag = 0);


data tmp;
set &dsn;
run;


%if &behandler ne 0 %then %do;
   %definerBehandler(dsn=tmp);
%end;

/* Legge inn BOShHN innbyggertall */

proc sql;
create table tabl as
select *
from tmp left join bosh_innbygg
on 
   tmp.aar=bosh_innbygg.aar and 
   tmp.BoRHF=bosh_innbygg.BoRHF and 
   tmp.BoHF=bosh_innbygg.BoHF and 
   tmp.BoShHN=bosh_innbygg.BoShHN and
   tmp.ald_gr4=bosh_innbygg.ald_gr4 and
   tmp.ermann=bosh_innbygg.ermann;
quit;

/* Legge inn BOHF innbyggertall */

proc sql;
create table tabl2 as
select *
from tabl left join bohf_innbygg
on 
   tabl.aar=bohf_innbygg.aar and
   tabl.BoRHF=bohf_innbygg.BoRHF and 
   tabl.BoHF=bohf_innbygg.BoHF and
   tabl.ald_gr4=bohf_innbygg.ald_gr4 and
   tabl.ermann=bohf_innbygg.ermann;
quit;

proc sql;
create table tabl3 as
select *
from tabl2 left join borhf_innbygg
on 
   tabl2.aar=borhf_innbygg.aar and
   tabl2.BoRHF=borhf_innbygg.BoRHF and 
   tabl2.ald_gr4=borhf_innbygg.ald_gr4 and
   tabl2.ermann=borhf_innbygg.ermann;
quit;


proc sql;
   create table tabl4 as
   select *
   from tabl3 left join ald_just
   on 
   tabl3.aar=ald_just.aar and
   tabl3.ald_gr4=ald_just.ald_gr4 and
   tabl3.ermann=ald_just.ermann;
quit;

data tabl4;
set tabl4;
   bosh_rate = 1000*faktor/bosh_innb;
   bohf_rate = 1000*faktor/bohf_innb;
   borhf_rate = 1000*faktor/borhf_innb;
   bosh_drgrate = 1000*faktor*npkOpphold_ISFPoeng/bosh_innb;
   bohf_drgrate = 1000*faktor*npkOpphold_ISFPoeng/bohf_innb;
   borhf_drgrate = 1000*faktor*npkOpphold_ISFPoeng/borhf_innb;
   bosh_liggerate = 1000*faktor*liggetid/bosh_innb;
   bohf_liggerate = 1000*faktor*liggetid/bohf_innb;
   borhf_liggerate = 1000*faktor*liggetid/borhf_innb;

drop bosh_innb bohf_innb borhf_innb;
run;

data tabl4;
set tabl4;
where Ald_gr4 ne . and ermann ne .;
   if (hastegrad eq .) then hastegrad = 9;
format hastegrad innmateHast_2delt.;
format BehSh behSh.;
run;

proc sql;
   create table &dsn._ut as
   select distinct
      aar,
      Aktivitetskategori3,
      %if &grupperinger ne 0 %then %do;
         Ald_gr4,
         Ermann,
         hastegrad, 
         DRGtypeHastegrad,
         BehHF,
         BehSh,
      %end;
      Behhf_hn,
	  %if &hdg ne 0 %then %do;
	     hdg,
	  %end;
	  %if &icd ne 0 %then %do;
	     ICD10Kap,
      %end;
      %if &fag ne 0 %then %do;
         episodeFag,
         fag_skde,
      %end;
      BehRHF,
      %if &behandler ne 0 %then %do;
         behandler,
      %end;
      BoRHF, 
      BoHF,
      BoShHN, 
      /* summert liggetid */
      (SUM(liggetid)) as liggetid, 
      /* summert drg-poeng */
      (SUM(npkOpphold_ISFPoeng)) as drg_poeng, 
      /* antall pasienter */
      (SUM(kontakt)) as kontakter,
      /* rate bosh */
      (SUM(bosh_rate)) as bosh_rate,
      /* rate bohf */
      (SUM(bohf_rate)) as bohf_rate,
      /* rate bohf */
      (SUM(borhf_rate)) as borhf_rate,
      /* drg-rate bosh */
      (SUM(bosh_drgrate)) as bosh_drgrate,
      /* drg-rate bohf */
      (SUM(bohf_drgrate)) as bohf_drgrate,
      /* drg-rate bohf */
      (SUM(borhf_drgrate)) as borhf_drgrate,
      /* liggetidsrate bosh */
      (SUM(bosh_liggerate)) as bosh_liggerate,
      /* liggetidsrate bohf */
      (SUM(bohf_liggerate)) as bohf_liggerate,
      /* liggetidsrate bohf */
      (SUM(borhf_liggerate)) as borhf_liggerate

from tabl4
   group by 
      aar,
      Aktivitetskategori3,
      %if &grupperinger ne 0 %then %do;
         Ald_gr4,
         ermann,
         hastegrad,
         DRGtypeHastegrad,
         BehHF,
         BehSh,
      %end;
	  Behhf_hn,
	  %if &hdg ne 0 %then %do;
	     hdg,
	  %end;
	  %if &icd ne 0 %then %do;
	     ICD10Kap,
	  %end;
      %if &fag ne 0 %then %do;
         episodeFag,
         fag_skde,
      %end;
      BehRHF,
      %if &behandler ne 0 %then %do;
         behandler,
      %end;
	  BoRHF,
      BoHF,
      BoShHN;
quit;

/* nye navn */
data &dsn._ut;
set &dsn._ut;
   rename Aktivitetskategori3 = behandlingsniva;
   %if &grupperinger ne 0 %then %do;
      rename Ald_gr4 = alder;
      rename ermann = kjonn;
      rename Behhf = behandlende_HF;
      rename BehSh = behandlende_sykehus;
      format drgtypehastegrad drgtypehastegrad.;
      format kjonn ermann.;
   %end;
   rename Behhf_hn = behandlende_HF_HN;
   %if &hdg ne 0 %then %do;
      rename hdg = Hoveddiagnosegruppe;
   %end;
   rename BoRHF = boomr_RHF;
   rename BoHF = boomr_HF;
   rename BoShHN = boomr_sykehus;
   rename BehRHF = behandlende_RHF;
   format behandlende_RHF BehRHF.;
run;

data &dsn._ut;
set &dsn._ut;
   %if behandler eq 0 %then %do;
      format behandlende_sykehus behSh.;
   %end;
   format boomr_HF BoHF_kort.;
   format boomr_RHF BoRHF.;
   format boomr_sykehus boshHN.;
   format behandlingsniva BEHANDLINGSNIVA3F.;
   %if &fag ne 0 %then %do;
       format fag_skde Fag_SKDE.;
       format episodeFag episodeFag.;
   %end;
   %if  &icd ne 0 %then %do;
       format ICD10Kap ICD_KAP.;
   %end;
run;


%slett_datasett(datasett = tabl);
%slett_datasett(datasett = tabl2);
%slett_datasett(datasett = tabl3);
%slett_datasett(datasett = tabl4);
%slett_datasett(datasett = tmp);

%mend;



