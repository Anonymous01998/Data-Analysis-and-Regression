DATA Liver_transplant;
INFILE 'Liver_transplant.csv' firstobs = 2 delimiter = ',';
INPUT ID age sex $ abo $ year futime event $;
Abo1 = (abo='A');
Abo2 = (abo='B');
Abo3 = (abo='AB');
numsex=( sex='m');
numevent=( event='ltx');
RUN;

PROC PRINT;
RUN;

PROC FREQ DATA = Liver_transplant;
TABLES Abo1 Abo2 Abo3;
RUN;

PROC PRINT DATA = Liver_transplant;
RUN;

PROC LOGISTIC DATA = Liver_transplant;
MODEL event (event ='1') = numsex ID age year futime Abo1 Abo2 Abo3;
RUN;

PROC LOGISTIC DATA = Liver_transplant;
MODEL event (event ='1') = numsex ID age year futime Abo1 Abo2 Abo3 / STB;
RUN;

PROC LOGISTIC DATA = Liver_transplant;
MODEL event (event ='1') = numsex ID age year futime Abo1 Abo2 Abo3 / selection = stepwise rsquare;
RUN;

PROC LOGISTIC DATA = Liver_transplant;
MODEL event (event ='1') = numsex ID age year futime Abo1 Abo2 Abo3 / selection = backward rsquare;
RUN;

PROC LOGISTIC DATA = Liver_transplant;
MODEL event (event ='1') = numsex age year futime;
RUN;

PROC LOGISTIC DATA = Liver_transplant;
MODEL event (event ='1') = numsex age year futime / influence iplots corrb STB;
RUN;

ods graphics off;

PROC SGSCATTER;
TITLE "Scatter Plots";
MATRIX numevent numsex age year futime;
RUN;

PROC SORT DATA = Liver_transplant;
by numevent;

PROC BOXPLOT DATA = Liver_transplant;
TITLE "Boxplot";
PLOT (year)*numevent;
PLOT (age)*numevent;
RUN;

PROC CORR DATA = Liver_transplant;
VAR numevent numsex age year futime;
RUN;

PROC REG DATA = Liver_transplant;
MODEL numevent = numsex age year futime;
RUN;

PROC REG DATA = Liver_transplant;
MODEL numevent = numsex age year futime / VIF tol;
RUN;

PROC REG DATA = Liver_transplant;
MODEL numevent = numsex age year futime / VIF tol;
PLOT student.*(numsex age year futime);
PLOT student.*predicted.;
PLOT npp.*student.;
RUN;

PROC REG DATA = Liver_transplant;
MODEL numevent = numsex age year futime / influence r;
RUN;

DATA Liver_transplant_new;
SET Liver_transplant;
IF _n_ = 259 THEN DELETE;
RUN;

PROC REG DATA = Liver_transplant_new;
MODEL numevent = numsex age year futime / influence r STB;
RUN;

DATA Liver_transplant_new_2;
SET Liver_transplant;
IF _n_ = 674 THEN DELETE;
RUN;

PROC REG DATA = Liver_transplant_new_2;
MODEL numevent = numsex age year futime / influence r STB;
RUN;

PROC REG DATA = Liver_transplant_new_2;
MODEL numevent = numsex age year futime / influence r STB;
PLOT student.*(numsex age year futime predicted.);
PLOT npp.*predicted.;
RUN;

PROC LOGISTIC DATA = Liver_transplant;
MODEL event(event ='1') = numsex age year futime / STB CORRB INFLUENCE iplots;
RUN;

PROC SURVEYSELECT DATA = Liver_transplant OUT = train_test seed = 76341 samprate = 0.75 outall;
RUN;

PROC PRINT;
RUN;

DATA train_test;
SET train_test;
IF selected then train_y = numevent;
RUN;

PROC PRINT;
RUN;

PROC LOGISTIC;
MODEL train_y (event ='1') = numsex age year futime / selection=stepwise rsquare;
RUN;

PROC LOGISTIC;
MODEL train_y (event ='1') = year futime / ctable pprob = (0.1 to 0.8 by 0.05);
output out=pred (where = (train_y = .)) p = phat lower = lcl upper = ucl;
RUN;

DATA probs;
SET pred;
pred_y = 0;
IF (phat >= 0.6 ) THEN pred_y = 1;
RUN;

PROC PRINT; 
RUN;

PROC FREQ;
TABLES numevent*pred_y / norow nocol nopercent;
RUN;

PROC REG DATA = Liver_transplant;
MODEL numevent = year futime / VIF tol;
RUN;

PROC REG DATA = Liver_transplant;
MODEL numevent = year futime / VIF tol;
PLOT student.*(year futime);
PLOT student.*predicted.;
PLOT npp.*student.;
RUN;

PROC REG DATA = Liver_transplant;
MODEL numevent = year futime / influence r;
RUN;

DATA Liver_transplant_new;
SET Liver_transplant;
IF _n_ = 259 THEN DELETE;
RUN;

PROC REG DATA = Liver_transplant_new;
MODEL numevent = year futime / influence r STB;
RUN;

PROC REG DATA = Liver_transplant_new;
MODEL numevent = year futime / influence r STB;
PLOT student.*(year futime predicted.);
PLOT npp.*predicted.;
RUN;



































 




































