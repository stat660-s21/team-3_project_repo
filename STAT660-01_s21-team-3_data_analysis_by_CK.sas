*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;
/*
create macro variable with path to directory where this file is located,
enabling relative imports
*/
%let path=%sysfunc(tranwrd(%sysget(SAS_EXECFILEPATH),%sysget(SAS_EXECFILENAME),));

/*
execute data-prep file, which will generate final analytic dataset used to
answer the research questions below
*/
%include "&path.STAT660-01_s21-team-3_data_preparation.sas";


*******************************************************************************;
* Research Question 1 Analysis Starting Point;
*******************************************************************************;
/*
Question 1 of 3: Do the Investor Owned long term care facilities on average make
more net income than the Not for Profit long term care facilities?

Rationale: This should help identify if the type of ownership control impacts
how profitable the long term care facility will be.

Note: This compares the columns “NET_INCOME” and “TYPE_CNTRL” from 
ltcfprofitability.

Limitations: None. No missing values in any of the relevant columns.
*/
proc sort
        data=ltcf_analytic_file_v2
        out=ltcf_analytic_file_sorted
    ;
    by descending NET_INCOME;
run;

title 
"Top 10 Type of Ownership Control Where Long-Term Care Facilities
Experience the Highest Net Profit Margin";
proc print data=ltcf_analytic_file_sorted(obs=10);
    id TYPE_CNTRL;
    var NET_INCOME;
run;
title;
*******************************************************************************;
* Research Question 2 Analysis Starting Point;
*******************************************************************************;
/*
Question 2 of 3: Are the total hours worked by registered nurses dependent on 
the total patient census days? Does more patient days mean more hours have to be
worked by the registered nurses? 

Rationale: This should help identify if the total patient census days are a
significant factor in how many hours are worked by the registered nurses.

Note: This compares the column “PRDHR_RN” with “PATIENT_DAYS” from ltcfstaffing.

Limitations: None. No missing values in any of the relevant columns.
*/
proc corr data=ltcf_analytic_file_v2; 
    var PRDHR_RN; 
    with PATIENT_DAYS; 
run; 

title "Scatterplot of Hours worked by RN vs Total Patient Days";

proc gplot data=ltcf_analytic_file_v2; 
    plot PRDHR_RN*PATIENT_DAYS; 
run;

proc means
        data=ltcf_analytic_file_v2
        out=ltcf_analytic_file_sorted
        maxdec=0
        mode /* most common number */
    ;
    var 
        PATIENT_DAYS
    ;
    class
        PRDHR_RN
    ;
    label
         PATIENT_DAYS=" "
    ;
run;

title "10 Highest Total Hours Logged by RN at Long-Term Care Facilities
listed with their corresponding Total Patient Days";
proc print data=ltcf_analytic_file_sorted(obs=10);
    id PRDHR_RN;
    var PATIENT_DAYS;
run;
title;
*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;
/*
Question 3 of 3: Is a long term care facility dependent on the total patient 
census days in order to be profitable? In other words do the facilities that
are most profitable have the highest patient days or can a facility be profitable
and still log lower patient days?

Rationale: This should help identify whether the patient census days are a 
significant factor in determining profitability.

Note: This compares the column “PATIENT_DAYS" with “NET_INCOME” from
ltcfprofitability.

Limitations: None. No missing values in any of the relevant columns.
*/

proc means
        data=ltcf_analytic_file_v2
        out=ltcf_analytic_file_sorted
        maxdec=0
        mode /* most common number */
    ;
    var 
        PATIENT_DAYS
    ;
    class
        NET_INCOME
    ;
    label
         PATIENT_DAYS=" "
    ;
run;

title "Top 10 Long-Term Care Facilities experiencing the Highest Net 
Profit Margin listed with their corresponding Total Patient Days";
proc print data=ltcf_analytic_file_sorted(obs=10);
    id NET_INCOME;
    var PATIENT_DAYS;
run;
title;
