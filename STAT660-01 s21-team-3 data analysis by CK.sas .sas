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
(Rationale:This should help identify   if the type of ownership control impacts
howprofitable the long term care facility will be) 
[Note: This compares the columns“NET_INCOME” and “TYPE_CNTRL” from 
ltcfprofitability.]

*/


*******************************************************************************;
* Research Question 2 Analysis Starting Point;
*******************************************************************************;
/*
Question 2 of 3: Are the total hours worked by registered nurses dependent on 
the total patient census days? Does more patient days mean more hours have to be
worked by the registered nurses? 
(Rationale: This should help identify if the total patient census days are a
significant factor in how many hours are worked by the registered nurses.)
[Note: This compares the column “PRDHR_RN” with “PATIENT_DAYS” from ltcfstaffing.]
*/


*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;
/*
Question 3 of 3:  Is a long term care facility dependent on the total patient 
census days in order to be profitable? In other words do the facilities that
are most profitable have the highest patient days or can a facility be profitable
and still log lower patient days?
(Rationale: This should help identify whether the patient census days are a 
significant factor in determining profitability.)
[Note: This compares the column “PATIENT_DAYS with “NET_INCOME” from
ltcfprofitability.]
*/
