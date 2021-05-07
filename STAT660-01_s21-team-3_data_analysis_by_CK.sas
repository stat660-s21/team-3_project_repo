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

/* Calculate sums of RN staff hours within total patient days */
ods exclude all;
proc means data=ltcf_analytic_file
        Sum
        STACKODSOUTPUT;
    var PRDHR_RN ;
    class PATIENT_DAYS;
ods output Summary=SummedSummary2;
run;
ods exclude none;


/* Sum by patient days */
ods exclude all;
proc means data=SummedSummary2
        Sum
        STACKODSOUTPUT;
    var Sum;
    class PATIENT_DAYS;
ods output Summary=SummedSummary22;
run;
ods exclude none;


/* Sort patient days by hours */
proc sort data=SummedSummary22 out=SummedSummarySort2;
    by descending Sum;
run;


title1 justify=left
"Question 2 of 3: Are the total hours worked by registered nurses dependent
 on the total patient census days? Does more patient days mean more hours have
 to be worked by the registered nurses?"
;

title2 justify=left
"Rationale: This should help identify if the total patient census days are a 
 significant factor in how many hours are worked by the registered nurses."
;

footnote1 justify=left
"Of the top five total patient days with largest number of RN staff hours
 worked from long term care facilities, the top three total patient days
 are also associated with more staff hours logged by RN."
;

footnote2 justify=left
"It would be interesting to look at the size of long term care facilities
 and their patient capacity because that would mean more RN staff is needed."
;

footnote3 justify=left
"88779 is the most patient census days and it is associate with 79,652 hours 
 logged by RN. As the total patient census days decrease, the hours logged
 by RN decrease."
;


/* Print formatted table */
proc print 
        data=SummedSummarySort2(obs=5)
        label
    ;
    id PATIENT_DAYS;
    var Sum;
    label
        PATIENT_DAYS="Patient Days"
        Sum="RN Staff Hours"
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
Note: This compares the column “PATIENT_DAYS" with “NET_INCOME” from
ltcfprofitability.

Limitations: None. No missing values in any of the relevant columns.

Methodology: Use proc means mode to find the total patient days
by net income. Next, use proc sort to create a temporary sorted table 
in descending order by net income. Finally, use proc print to print the output
for total patient days and format days to 0 decimal places.

Followup Steps: Next steps would involve investigating the NA values.
*/

/* Sort net income by total patient census days. */
ods exclude all;
proc means data=ltcf_analytic_file
        mode
        STACKODSOUTPUT;
    var PATIENT_DAYS;
    class NET_INCOME;
ods output Summary=SummedSummary3;
run;
ods exclude none;


/* Sort net income by total patient days. */
proc sort data=SummedSummary3 out=SummedSummarySort3;
    by descending Mode;
run;


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
"The most patient census days was 131490 days with net income $1425371."
;

footnote2 justify=left
"As the total patient census days decrease, the net income does not decrease as
 well. These two factors do not seem to be dependent of each other."
;

footnote3 justify=left
"The net income is independent of the total patient census days. The most
 profitable days does not mean that it will have the most patient census days. 
 Other factors determine how profitable the day will be, not the total patient
 census days."
;


/* Print formatted table */
proc print 
        data=SummedSummarySort3
        label
    ;
    id NET_INCOME;
    var Mode;
    label
        NET_INCOME="Net Income"
        Mode="Total Patient Census Days"
     ;
     format
        Mode best12.;
run;

/* clear titles/footnotes */
title;
footnote;
