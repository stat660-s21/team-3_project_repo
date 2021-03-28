
2    *******************************************************************************;
3    **************** 80-character banner for column width reference ***************;
4    * (set window width to banner width to calibrate line length to 80 characters *;
5    *******************************************************************************;
6
7    /*
8    create macro variable with path to directory where this file is located,
9    enabling relative imports
10   */
11   %let path=%sysfunc(tranwrd(%sysget(SAS_EXECFILEPATH),%sysget(SAS_EXECFILENAME),));
ERROR: An error occurred while executing function TRANWRD referenced by the %SYSFUNC or %QSYSFUNC macro
       function.
12
13   /*
14   execute data-prep file, which will generate final analytic dataset used to
15   answer the research questions below
16   */
17   %include "&path.STAT660-01_s21-team-3_data_preparation.sas";
WARNING: Physical file does not exist, C:\Users\cv4594\STAT660-01_s21-team-3_data_preparation.sas.
ERROR: Cannot open %INCLUDE file STAT660-01_s21-team-3_data_preparation.sas.
18
19
20   *******************************************************************************;
21   * Research Question 1 Analysis Starting Point;
22   *******************************************************************************;
23   /*
24
25   Question 1 of 3: Do the Investor Owned long term care facilities on average make more net income
25 ! than the Not for Profit long term care facilities? (Rationale: This should help identify   if the
25 ! type of ownership control impacts how profitable the long term care facility will be) [Note: This
25 ! compares the columns “NET_INCOME”  and “TYPE_CNTRL” from ltcfprofitability.]
26
27   */
28
29
30   *******************************************************************************;
31   * Research Question 2 Analysis Starting Point;
32   *******************************************************************************;
33   /*
34   Question 2 of 3: Are the total hours worked by registered nurses dependent on the total patient
34 ! census days? Does more patient days mean more hours have to be worked by the registered nurses?
34 ! (Rationale: This should help identify if the total patient census days are a significant factor in
34 ! how many hours are worked by the registered nurses.) [Note: This compares the column “PRDHR_RN”
34 ! with “PATIENT_DAYS” from ltcfstaffing.]
35   */
36
37
38   *******************************************************************************;
39   * Research Question 3 Analysis Starting Point;
40   *******************************************************************************;
41   /*
42   Question 3 of 3:  Is a long term care facility dependent on the total patient census days in order
42 ! to be profitable? In other words do the facilities that are most profitable have the highest
42 ! patient days or can a facility be profitable and still log lower patient days? (Rationale: This
42 ! should help identify whether the patient census days are a significant factor in determining
42 ! profitability.) [Note: This compares the column “PATIENT_DAYS with “NET_INCOME” from
42 ! ltcfprofitability.]
43   */
