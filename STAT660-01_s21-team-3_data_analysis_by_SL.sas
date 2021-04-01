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
Note: This compares the column “NET_INCOME” from ltcfprofitability15.]
*/


*******************************************************************************;
* Research Question 2 Analysis Starting Point;
*******************************************************************************;
/*
Question 2 of 3: What are the top ten long-term care facilities with the most 
hours logged by staff and are they in the top five counties from Research 
Question 1?
Rationale: This would help identify whether facilities with the largest staff 
are also the facilities with the most profit.
Note: This sums the columns “PRDHR_MGT”, “PRDHR_RN”, “PRDHR_LVN”, “PRDHR_NA”, 
“PRDHR_TSP”, “PRDHR_PSY”, and “PRDHR_OTH” and compares between facilities and 
county from ltcfstaffing15.
*/


*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;
/*
Question 3 of 3: What is the most common length of stay before discharge at the 
most profitable long-term care facilities? 
Rationale: This would help identify what types of visits may be more costly.
Note: This compares the columns that start with “DIS_LTC_...” from ltcfutil15.
*/
