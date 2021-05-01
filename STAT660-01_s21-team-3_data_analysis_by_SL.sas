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
Note: This compares the column NET_INCOME from ltcfprofitability15.

Limitations: Values of NET_INCOME equal to 0 should be excluded from the 
analysis since they are potentially missing data values.

Methodology: Use proc means to sum total net income by county. Next, use proc
sort to create a temporary sorted table in descending order by net income. 
Finally, use proc print to print the first five rows of the sorted dataset and 
format net income by dollars to two decimal places.

Followup Steps: Next steps would involve finding data on the population count of 
each county from 2015 to draw inferences on whether densely populated counties
have higher net profit margins.
*/

/* Calculate total net income by group. */
ods exclude all;
proc means data=ltcf_analytic_file
        Sum
        STACKODSOUTPUT;
    var NET_INCOME;
    class COUNTY_NAME;
ods output Summary=SummedSummary;
run;
ods exclude none;

/* Sort counties by net income. */
proc sort data=SummedSummary out=SummedSummarySort;
    by descending Sum;
run;


title1 justify=left
'Question 1 of 3: What are the top five counties where long-term care facilities 
have the highest net profit margin?'
;

title2 justify=left
'Rationale: This should help identify whether densely population locations in 
California may have more expensive long-term care facilities.'
;

footnote1 justify=left
'Of the top five counties with largest net profit margins from long term care 
facilities, two are from Southern California and three are from Northern 
California.'
;

footnote2 justify=left
'It would be interesting to look at the number of long term care facilities 
factoring into the net income count.'
;

footnote3 justify=left
'Los Angeles had the highest net profit margin followed by the Bay Area counties
Santa Clara and Alameda. It is possible this is associated with high costs of
living in these counties.'
;

/* Print formatted table */
proc print 
        data=SummedSummarySort(obs=5)
        label
    ;
    id COUNTY_NAME;
    var Sum;
    label
        COUNTY_NAME="County"
        Sum="Net Income"
     ;
	 format
	     Sum dollar20.2
	 ;
run;

/* clear titles/footnotes */
title;
footnote;


title1 'Net Income by County';
footnote1
"In the above plot, we can see that Los Angeles has significantly larger
 profit margins than the other counties."
;

/* Bar Chart */
proc sgplot data=SummedSummarySort(obs=5);
    vbar COUNTY_NAME / response=Sum;
	yaxis label="Net Income";
	xaxis label="County";
	format Sum dollar20.;
run;

/* clear titles/footnotes */
title;
footnote;

*******************************************************************************;
* Research Question 2 Analysis Starting Point;
*******************************************************************************;
/*
Note: This sums the columns PRDHR_MGT, PRDHR_RN, PRDHR_LVN, PRDHR_NA, PRDHR_TSP, 
PRDHR_PSY, and PRDHR_OTH and compares between each county from ltcfstaffing15.

Limitations: None. No missing values in any of the relevant columns.

Methodology:

Followup Steps:
*/

title1 justify=left
'Question 2 of 3: What are the top five counties where long-term care facilities 
have the most number of hours logged by staff?'
;

title2 justify=left
'Rationale: This would help identify whether number a countys net profit margin
might have a relationship with the amount of staff hours.'
;

footnote1 justify=left
;

proc means
        data=ltcf_analytic_file
        out=ltcf_analytic_file_sorted
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

proc print data=ltcf_analytic_file_sorted(obs=5);
    id COUNTY_NAME;
    var PRDHR_MGT PRDHR_RN PRDHR_LVN PRDHR_NA PRDHR_TSP PRDHR_PSY PRDHR_OTH;
run;

/* clear titles/footnotes */
title;
footnote;

*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;
/*
Note: This compares the column DIS_LTC_PATIENT_HOSP from ltcfutil15.

Limitations: Values of DIS_LTC_PATIENT_HOSP that equal to zero should be 
excluded from this analysis since they are potentially missing data values.

Methodology:

Followup Steps:
*/

title1 justify=left
'Question 3 of 3: What is the most common length of stay before discharge in 
each county?'
;

title2 justify=left
'Rationale: This would help identify whether long stays could be attributed to
more profitable facilities.'
;

footnote1 justify=left
;

proc means
        data=ltcf_analytic_file
        out=ltcf_analytic_file_sorted
        maxdec=0
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

proc print data=ltcf_analytic_file_sorted(obs=1);
    id COUNTY;
    var DIS_LTC_PATIENT_HOSP;
run;

/* clear titles/footnotes */
title;
footnote;
