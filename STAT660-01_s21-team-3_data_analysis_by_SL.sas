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
Question 1 of 3: What are the top five counties where long-term care facilities 
have the highest net profit margin? 

Rationale: This should help identify whether densely population locations in 
California may have more expensive long-term care facilities.

Note: This compares the column NET_INCOME from ltcfprofitability15.

Limitations: None. No missing values in any of the relevant columns.
*/

title "Inspect COUNTY_NAME and NET_INCOME from ltcfprofitability15_deduped";
proc means
        data=ltcfprofitability15_deduped
        maxdec=2
        missing
        n /* number of observations */
        nmiss /* number of missing values */
        min q1 median q3 max  /* five-number summary */
        mean std /* two-number summary */
    ;
    var 
        NET_INCOME
    ;
    class
        COUNTY_NAME
    ;
    label
        NET_INCOME=" "
    ;
run;
title;

*******************************************************************************;
* Research Question 2 Analysis Starting Point;
*******************************************************************************;
/*
Question 2 of 3: What are the top five counties where long-term care facilities 
have the most number of hours logged by staff?

Rationale: This would help identify whether number a county's net profit margin
might have a relationship with the amount of staff hours.

Note: This sums the columns PRDHR_MGT, PRDHR_RN, PRDHR_LVN, PRDHR_NA, PRDHR_TSP, 
PRDHR_PSY, and PRDHR_OTH and compares between each county from ltcfstaffing15.

Limitations: None. No missing values in any of the relevant columns.
*/

title "Inspect COUNTY_NAME, PRDHR_MGT, PRDHR_RN, PRDHR_LVN, PRDHR_NA, 
PRDHR_TSP, PRDHR_PSY, and PRDHR_OTH from ltcfstaffing15_deduped";
proc means
        data=ltcfstaffing15_deduped
        maxdec=0
        sum
    ;
    var 
        PRDHR_MGT PRDHR_RN PRDHR_LVN PRDHR_NA PRDHR_TSP PRDHR_PSY PRDHR_OTH
    ;
    class
        COUNTY_NAME
    ;
    label
        PRDHR_MGT=" "
        PRDHR_RN=" "
        PRDHR_LVN=" "
        PRDHR_NA=" "
        PRDHR_TSP=" "
        PRDHR_PSY=" "
        PRDHR_OTH=" "
    ;
run;
title;

*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;
/*
Question 3 of 3: What is the most common length of stay before discharge in 
each county? 

Rationale: This would help identify whether long stays could be attributed to
more profitable facilities.

Note: This compares the column DIS_LTC_PATIENT_HOSP from ltcfutil15.

Limitations: Values of DIS_LTC_PATIENT_HOSP that equal to zero should be 
excluded from this analysis since they are potentially missing data values.
*/

title "Inspect DIS_LTC_PATIENT_HOSP from ltcfutil15_deduped";
proc means
        data=ltcfutil15_deduped
        maxdec=0
        missing
        n /* number of observations */
        nmiss /* number of missing values */
        min q1 median q3 max  /* five-number summary */
        mode /* most common number */
    ;
    var 
        DIS_LTC_PATIENT_HOSP
    ;
    class
        COUNTY
    ;
    label
        DIS_LTC_PATIENT_HOSP=" "
    ;
run;
title;
