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
Note: This compares the columns “NET_INCOME” and “TYPE_CNTRL” from 
ltcfprofitability.

Limitations: None. No missing values in any of the relevant columns.

Methodology: Use proc means to sum total net income by type of ownership control. 
Next, use proc sort to create a temporary sorted table in descending order by net 
income. Finally, use proc print to print the first ten rows of the sorted dataset
and format net income by dollars to two decimal places.

Followup Steps: Next steps would involve finding data on the population count of 
each type of ownership control from 2015 to draw inferences on whether investor
owned long term care facilities have higher net profit margins.
*/

/* Calculate total net income by group */
ods exclude all;
proc means data=ltcf_analytic_file
        Sum
        STACKODSOUTPUT;
    var NET_INCOME;
    class TYPE_CNTRL;
ods output Summary=SummedSummary;
run;
ods exclude none;

/* Sort type of ownership control by net income */ 
proc sort data=SummedSummary out=SummedSummarySort;
    by descending Sum;
run;


title1 justify=left
"Question 1 of 3: Do the Investor Owned long term care facilities on average
 make more net income than the Not for Profit long term care facilities?"
;

title2 justify=left
"Rationale: This should help identify if the type of ownership control impacts
 how profitable the long term care facility will be."
;

footnote1 justify=left
"Of the top types of ownership control with largest net profit margins
 from long term care facilities, the top one is investor owned."
;

footnote2 justify=left
"It would be interesting to look at other variables from long term care
 facilities factoring into the net income count."
;

footnote3 justify=left
"Investor Owned had the highest net profit margin. It is possible this is associated with
 investors needing to see their profit returns being met."
;

/* Print formatted table */
proc print 
        data=SummedSummarySort(obs=5)
        label
    ;
    id TYPE_CNTRL;
    var Sum;
    label
        TYPE_CNTRL="Type of Ownership Control"
        Sum="Net Income"
     ;
     format
         Sum dollar20.2
     ;
run;

/* clear titles/footnotes */
title;
footnote;


title1 "Net Income by Type of Ownership Control";
footnote1
"In the above plot, we can see that Investor Owned Type 
 Control has significantly larger profit margins than the other counties."
;

/* Bar Chart */
proc sgplot data=SummedSummarySort(obs=5);
    vbar TYPE_CNTRL / response=Sum;
    yaxis label="Net Income";
    xaxis label="Type of Ownership Control";
    format Sum dollar20.;
run;

/* clear titles/footnotes */
title;
footnote;

************************************************************************;
* Research Question 2 Analysis Starting Point;
*******************************************************************************;
/*
Note: This compares the column “PRDHR_RN” with “PATIENT_DAYS” from ltcfstaffing.

Limitations: None. No missing values in any of the relevant columns.

Methodology: Use proc means to sum RN staff hours by total patient days. 
Next, use proc means again to sum all the hours reported from RN staff hours
by patient days. Then, sort to create a temporary sorted table in descending order by 
hours worked. Finally, use proc print to print the first five rows of the sorted 
dataset and format hours worked with commas.

Followup Steps: Next steps would involve looking into salaries or wage per hour
paid to staff.
*/

/* clear titles/footnotes */
title;
footnote;

title1 justify=left
"Question 2 of 3: Are the total hours worked by registered nurses dependent
 on the total patient census days? Does more patient days mean more hours have
 to be worked by the registered nurses?"
;

title2 justify=left
"Rationale: This should help identify if the total patient census days are a 
 significant factor in how many hours are worked by the registered nurses."
;

footnote2 justify=left
"The correlation coeffient is not significant, therefore the total hours
 worked by registered nurses is not dependent on the total patient census days.
 It would be interesting to look at the size of long term care facilities
 and their patient capacity because that would mean more RN staff is needed."
;

proc corr data=ltcf_analytic_file; 
    var PRDHR_RN; 
    with PATIENT_DAYS; 
run; 

/* clear titles/footnotes */
title;
footnote;

title1 justify=left
"Scatterplot of Hours worked by RN vs Total Patient Days"
;

footnote1 justify=left
"The scatter plot shows that there is not any trend or correlation
 between the hours worked by RN vs Total Patient Days ."
;

proc gplot data=ltcf_analytic_file; 
    plot PRDHR_RN*PATIENT_DAYS; 
run;

*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;
/*
Note: This compares the column “PATIENT_DAYS" with “NET_INCOME” from
ltcfprofitability.

Limitations: None. No missing values in any of the relevant columns.

Methodology: Use proc means mode to find the total patient days
by net income. Next, use proc sort to create a temporary sorted table 
in descending order by net income. Finally, use proc print to print the output
for total patient days and format days to 0 decimal places.

Followup Steps: Next steps would involve investigating the NA values.
*/

/* clear titles/footnotes */
title;
footnote;

title1 justify=left
"Question 3 of 3: Is a long term care facility dependent on the total patient
 census days in order to be profitable? In other words do the facilities that
 are most profitable have the highest patient days or can a facility be
 profitable and still log lower patient days?"
;

title2 justify=left
"Rationale: This should help identify whether the patient census days are a
 significant factor in determining profitability."
;

footnote1 justify=left
"The correlation coeffient is not significant, therefore the net income is
 not dependent on the total patient census days. The most profitable days
 does not mean that it will have the most patient census days."
;

proc corr data=ltcf_analytic_file; 
    var NET_INCOME; 
    with PATIENT_DAYS; 
run; 
* clear titles/footnotes */
title;
footnote;

title1 justify=left
"Scatterplot of Net Income vs Total Patient Days"
;

footnote1 justify=left
"The scatter plot shows that there is not any trend or correlation between
 the total net income and the total patient days."
;


proc gplot data=ltcf_analytic_file; 
    plot NET_INCOME*PATIENT_DAYS; 
run;



