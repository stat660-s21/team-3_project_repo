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

/* Calculate total net income by group */
ods exclude all;
proc means data=ltcf_analytic_file
        Sum
        STACKODSOUTPUT;
    var NET_INCOME;
    class COUNTY_NAME;
ods output Summary=SummedSummary;
run;
ods exclude none;

/* Sort counties by net income */
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

Methodology: Use proc means to sum staff hours by each position by county. 
Next, use proc means again to sum all the hours reported from each position
by county. Then, sort to create a temporary sorted table in descending order by 
hours worked. Finally, use proc print to print the first five rows of the sorted 
dataset and format hours worked with commas.

Followup Steps: Next steps would involve looking into salaries or wage per hour
paid to staff.
*/

/* Calculate sums of each staff position within each county */
ods exclude all;
proc means data=ltcf_analytic_file
        Sum
        STACKODSOUTPUT;
    var PRDHR_MGT PRDHR_RN PRDHR_LVN PRDHR_NA PRDHR_TSP PRDHR_PSY PRDHR_OTH;
    class COUNTY_NAME;
ods output Summary=SummedSummary2;
run;
ods exclude none;


/* Sum by county */
ods exclude all;
proc means data=SummedSummary2
        Sum
        STACKODSOUTPUT;
    var Sum;
    class COUNTY_NAME;
ods output Summary=SummedSummary22;
run;
ods exclude none;


/* Sort counties by hours */
proc sort data=SummedSummary22 out=SummedSummarySort2;
    by descending Sum;
run;


title1 justify=left
'Question 2 of 3: What are the top five counties where long-term care facilities 
 have the most number of hours logged by staff?'
;

title2 justify=left
'Rationale: This would help identify whether net profit margin might have a 
 relationship with the amount of staff hours.'
;

footnote1 justify=left
'Of the top five counties with largest number of staff hours worked from long term 
 care facilities, the top three are from Southern California and the other two are 
 from Northern California.'
;

footnote2 justify=left
'It would be interesting to look at the size of long term care facilities and their 
 patient capacity because that would mean more staff is needed.'
;

footnote3 justify=left
'Los Angeles, San Diego and Orange counties have the highest number of staff hours
 worked, which may mean there are more or larger facilities in Southern California
 and that might be asociated with a preference for warmer weather by those who are
 in the long term care facilities.'
;


/* Print formatted table */
proc print 
        data=SummedSummarySort2(obs=5)
        label
    ;
    id COUNTY_NAME;
    var Sum;
    label
        COUNTY_NAME="County"
        Sum="Staff Hours"
     ;
	 format
	     Sum comma20.
	 ;
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
NA values are potentially not reported data values that will need to be 
investigated further.

Methodology: Use proc means mode to find the most commonly reported length
of stay before discharge. Next, use proc sort to create a temporary sorted table 
in descending order by length of stay. Finally, use proc print to print the output
for all counties and format days to 0 decimal places.

Followup Steps: Next steps would involve investigating the NA values.
*/

/* Sort counties by common length of stay before discharge. */
ods exclude all;
proc means data=ltcf_analytic_file
        mode
        STACKODSOUTPUT;
    var DIS_LTC_PATIENT_HOSP;
    class COUNTY_NAME;
ods output Summary=SummedSummary3;
run;
ods exclude none;


/* Sort counties by length of stay. */
proc sort data=SummedSummary3 out=SummedSummarySort3;
    by descending Mode;
run;


title1 justify=left
'Question 3 of 3: What is the most common length of stay before discharge in 
 each county?'
;

title2 justify=left
'Rationale: This would help identify whether long stays could be attributed to
 more profitable facilities.'
;

footnote1 justify=left
'The most commonly reported length of stay was 211 days from Orange County. 
 A significant number of counties did not have reported values.'
;

footnote2 justify=left
'Orange County is on the list of top five counties with highest net profit margin,
 so their profit margin could be related to longer lengths of stays at the 
 hospital.'
;

footnote3 justify=left
'Many Southern California counties have reported longer lengths of stay, which may
 indicate a larger population of elderly people in warmer weather.'
;


/* Print formatted table */
proc print 
        data=SummedSummarySort3
        label
    ;
    id COUNTY_NAME;
    var Mode;
    label
        COUNTY_NAME="County"
        Mode="Most Common Length of Stay"
     ;
	 format
	    Mode best12.;
run;

/* clear titles/footnotes */
title;
footnote;
