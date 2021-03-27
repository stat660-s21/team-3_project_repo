NOTE: Copyright (c) 2016 by SAS Institute Inc., Cary, NC, USA.
NOTE: SAS (r) Proprietary Software 9.4 (TS1M5)
      Licensed to CALIFORNIA STATE UNIVERSITY EAST BAY - SFA - T&R, Site 70141476.
NOTE: This session is executing on the X64_10PRO  platform.



NOTE: Updated analytical products:

      SAS/STAT 14.3
      SAS/ETS 14.3
      SAS/IML 14.3
      SAS/QC 14.3

NOTE: Additional host information:

 X64_10PRO WIN 10.0.17763  Workstation

NOTE: SAS initialization used:
      real time           3.80 seconds
      cpu time            1.29 seconds

WARNING: One or more libraries specified in the concatenated library SASHELP
WARNING: do not exist.  These libraries were removed from the concatenation.
1
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
44
45   *******************************************************************************;
46   **************** 80-character banner for column width reference ***************;
47   * (set window width to banner width to calibrate line length to 80 characters *;
48   *******************************************************************************;
49
50   /*
51   [Dataset 1 Name] ltcfstaffing15
52   [Dataset Description] California Long Term Care Facility Nurse Staffing Hours
53   Worked in 2015
54   [Experimental Unit Description] Operating long-term care facilities in California
55   in 2015
56   [Number of Observations] 1,112
57   [Number of Features] 15
58   [Data Source] The file https://data.chhs.ca.gov/dataset/
59   6e946377-6360-400b-b8df-3528cfdb8b4d/resource/5879d2fe-1729-40d6-b58f-61642dac00f4/
60   download/long-term-care-facility-staffing.csv
61   was downloaded and converted to an Excel worksheet
62   [Data Dictionary] https://data.chhs.ca.gov/dataset/6e946377-6360-400b-b8df-3528cfdb8b4d/
63   resource/fd27d1b0-0079-4bcd-9a3f-d52c1a4d6371/download/hid-datadictionaryltcstaffing.docx
64   [Unique ID Schema] The column “FAC_NO” is a primary key and is equivalent to the
65   unique id column “OSHPD_ID” in ltcfutil15.
66   */
67   %let inputDataset1DSN = ltcfstaffing15;
68   %let inputDataset1URL =
69   https://github.com/stat660/team-3_project_repo/blob/sl-week2/data/ltcfstaffing15.xlsx?raw=true
70   ;
71   %let inputDataset1Type = XLSX;
72
73
74   /*
75   [Dataset 2 Name] ltcfprofitability15
76   [Dataset Description] California Long Term Care Facility Income Statement Data in 2015
77   [Experimental Unit Description] Operating long-term care facilities in California in 2015
78   [Number of Observations] 1,112
79   [Number of Features] 14
80   [Data Source] The file https://data.chhs.ca.gov/dataset/4327ea61-c69b-4f43-a0eb-a354476880bb/
81   resource/1510e857-a2cf-4b40-b4c3-829fe72851e1/download/long-term-care-facility-profitability.csv
82   was downloaded and converted to an Excel worksheet
83   [Data Dictionary] https://data.chhs.ca.gov/dataset/4327ea61-c69b-4f43-a0eb-a354476880bb/
84   resource/c89224f9-1b17-4967-a1b3-26285f9adf28/download/hid-datadictionaryltcprofitability.docx
85   [Unique ID Schema] The column “FAC_NO” is a primary key and is equivalent to the unique id
86   column “OSHPD_ID” in ltcfutil15.
87   */
88   %let inputDataset2DSN = ltcfprofitability15;
89   %let inputDataset2URL =
90   https://github.com/stat660/team-3_project_repo/blob/sl-week2/data/ltcfprofitability15.xlsx?raw=true
91   ;
92   %let inputDataset2Type = XLSX;
93
94
95   /*
96   [Dataset 3 Name] ltcfutil15
97   [Dataset Description] California Long Term Care Facilities Service Capacity,
98   Utilization, Patients, and Capital/Equipment Expenditures in 2015
99   [Experimental Unit Description] Operating long-term care facilities in California in 2015
100  [Number of Observations] 1,218
101  [Number of Features] 240
102  [Data Source] The file
103  https://data.chhs.ca.gov/dataset/ecd99c78-5032-4299-8067-a8a1e3eb434b/resource/
104  cf8035cd-00d6-4550-8af6-b4a702dc482b/download/ltc15utildatafinal.xlsx
105  was downloaded and subset to only include 2015 information
106  [Data Dictionary] https://data.chhs.ca.gov/dataset/ecd99c78-5032-4299-8067-a8a1e3eb434b/
107  resource/65ad64d6-5092-43b5-bd7c-c5734601b17f/download/ltcfrm15.pdf
108  [Unique ID Schema] The column OSHPD_ID is a unique id.
109  */
110  %let inputDataset3DSN = ltcfutil15;
111  %let inputDataset3URL =
112  https://github.com/stat660/team-3_project_repo/blob/sl-week2/data/ltcfutil15.xlsx?raw=true
113  ;
114  %let inputDataset3Type = XLSX;
115
116
117  /* load raw datasets over the wire, if they doesn't already exist */
118  %macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
119      %put &=dsn;
120      %put &=url;
121      %put &=filetype;
122      %if
123          %sysfunc(exist(&dsn.)) = 0
124      %then
125          %do;
126              %put Loading dataset &dsn. over the wire now...;
127              filename
128                  tempfile
129                  "%sysfunc(getoption(work))/tempfile.&filetype."
130              ;
131              proc http
132                      method="get"
133                      url="&url."
134                      out=tempfile
135                  ;
136              run;
137              proc import
138                      file=tempfile
139                      out=&dsn.
140                      dbms=&filetype.
141                  ;
142              run;
143              filename tempfile clear;
144          %end;
145      %else
146          %do;
147              %put Dataset &dsn. already exists. Please delete and try again.;
148          %end;
149  %mend;
150  %macro loadDatasets;
151      %do i = 1 %to 3;
152          %loadDataIfNotAlreadyAvailable(
153              &&inputDataset&i.DSN.,
154              &&inputDataset&i.URL.,
155              &&inputDataset&i.Type.
156          )
157      %end;
158  %mend;
159  %loadDatasets
DSN=ltcfstaffing15
URL=https://github.com/stat660/team-3_project_repo/blob/sl-week2/data/ltcfstaffing15.xlsx?raw=true
FILETYPE=XLSX
Loading dataset ltcfstaffing15 over the wire now...

NOTE: PROCEDURE HTTP used (Total process time):
      real time           0.96 seconds
      cpu time            0.07 seconds

NOTE: 200 OK


NOTE: One or more variables were converted because the data type is not supported by the V9 engine. For
      more details, run with options MSGLEVEL=I.
NOTE: The import data set has 1112 observations and 15 variables.
NOTE: WORK.LTCFSTAFFING15 data set was successfully created.
NOTE: PROCEDURE IMPORT used (Total process time):
      real time           0.52 seconds
      cpu time            0.26 seconds


NOTE: Fileref TEMPFILE has been deassigned.
DSN=ltcfprofitability15
URL=https://github.com/stat660/team-3_project_repo/blob/sl-week2/data/ltcfprofitability15.xlsx?raw=true
FILETYPE=XLSX
Loading dataset ltcfprofitability15 over the wire now...

NOTE: PROCEDURE HTTP used (Total process time):
      real time           0.52 seconds
      cpu time            0.00 seconds

NOTE: 200 OK


NOTE: One or more variables were converted because the data type is not supported by the V9 engine. For
      more details, run with options MSGLEVEL=I.
NOTE: The import data set has 1112 observations and 14 variables.
NOTE: WORK.LTCFPROFITABILITY15 data set was successfully created.
NOTE: PROCEDURE IMPORT used (Total process time):
      real time           0.21 seconds
      cpu time            0.20 seconds


NOTE: Fileref TEMPFILE has been deassigned.
DSN=ltcfutil15
URL=https://github.com/stat660/team-3_project_repo/blob/sl-week2/data/ltcfutil15.xlsx?raw=true
FILETYPE=XLSX
Loading dataset ltcfutil15 over the wire now...

NOTE: PROCEDURE HTTP used (Total process time):
      real time           0.73 seconds
      cpu time            0.04 seconds

NOTE: 200 OK


NOTE:    Variable Name Change.  SN_GEN_LTC_PATIENT DAYS_2015 -> SN_GEN_LTC_PATIENT_DAYS_2015
NOTE:    Variable Name Change.  SN_MD_LTC_PATIENT DAYS_2015 -> SN_MD_LTC_PATIENT_DAYS_2015
NOTE:    Variable Name Change.  IC_GEN_LTC_PATIENT DAYS_2015 -> IC_GEN_LTC_PATIENT_DAYS_2015
NOTE:    Variable Name Change.  IC_DD_LTC_PATIENT DAYS_2015 -> IC_DD_LTC_PATIENT_DAYS_2015
NOTE:    Variable Name Change.  CL_LTC_PATIENT DAYS_2015 -> CL_LTC_PATIENT_DAYS_2015
NOTE:    Variable Name Change.  HOFA_LTC_PATIENT DAYS_2015 -> HOFA_LTC_PATIENT_DAYS_2015
NOTE:    Variable Name Change.  LTC_PATIENT DAYS_2015_TOTL -> LTC_PATIENT_DAYS_2015_TOTL
NOTE:    Variable Name Change.  DIS_LTC_<2WK -> DIS_LTC__2WK
NOTE:    Variable Name Change.  DIS_LTC_2WK_<1MO -> DIS_LTC_2WK__1MO
NOTE:    Variable Name Change.  DIS_LTC_1YR_<2YR -> DIS_LTC_1YR__2YR
NOTE:    Variable Name Change.  DIS_LTC_2YR_<3YR -> DIS_LTC_2YR__3YR
NOTE:    Variable Name Change.  DIS_LTC_3YR_<5YR -> DIS_LTC_3YR__5YR
NOTE:    Variable Name Change.  DIS_LTC_5YR_<7YR -> DIS_LTC_5YR__7YR
NOTE:    Variable Name Change.  DIS_LTC_7YR_<10YR -> DIS_LTC_7YR__10YR
NOTE:    Variable Name Change.  DIS_LTC_>=10YR -> DIS_LTC___10YR
NOTE:    Variable Name Change.  M_WHI_CY_CEN_LTC<45 -> M_WHI_CY_CEN_LTC_45
NOTE:    Variable Name Change.  M_WHI_CY_CEN_LTC_>=95 -> M_WHI_CY_CEN_LTC___95
NOTE:    Variable Name Change.  M_BLK_CY_CEN_LTC<45 -> M_BLK_CY_CEN_LTC_45
NOTE:    Variable Name Change.  M_BLK_CY_CEN_LTC_>=95 -> M_BLK_CY_CEN_LTC___95
NOTE:    Variable Name Change.  M_ASI_PAI_CY_CEN_LTC_<45 -> M_ASI_PAI_CY_CEN_LTC__45
NOTE:    Variable Name Change.  M_ASI_PAI_CY_CEN_LTC_>=95 -> M_ASI_PAI_CY_CEN_LTC___95
NOTE:    Variable Name Change.  M_NAM_CY_CEN_LTC_<45 -> M_NAM_CY_CEN_LTC__45
NOTE:    Variable Name Change.  M_NAM_CY_CEN_LTC_>=95 -> M_NAM_CY_CEN_LTC___95
NOTE:    Variable Name Change.  M_OTH_UNK_CY_CEN_LTC_<45 -> M_OTH_UNK_CY_CEN_LTC__45
NOTE:    Variable Name Change.  M_OTH_UNK_CY_CEN_LTC_>=95 -> M_OTH_UNK_CY_CEN_LTC___95
NOTE:    Variable Name Change.  M_TOT_CY_CEN_LTC_<45 -> M_TOT_CY_CEN_LTC__45
NOTE:    Variable Name Change.  M_TOT_CY_CEN_LTC_>=95 -> M_TOT_CY_CEN_LTC___95
NOTE:    Variable Name Change.  F_WHI_CY_CEN_LTC_<45 -> F_WHI_CY_CEN_LTC__45
NOTE:    Variable Name Change.  F_WHI_CY_CEN_LTC_>=95 -> F_WHI_CY_CEN_LTC___95
NOTE:    Variable Name Change.  F_BLK_CY_CEN_LTC_<45 -> F_BLK_CY_CEN_LTC__45
NOTE:    Variable Name Change.  F_BLK_CY_CEN_LTC_>=95 -> F_BLK_CY_CEN_LTC___95
NOTE:    Variable Name Change.  F_ASI_PAI_CY_CEN_LTC_<45 -> F_ASI_PAI_CY_CEN_LTC__45
NOTE:    Variable Name Change.  F_ASI_PAI_CY_CEN_LTC_>=95 -> F_ASI_PAI_CY_CEN_LTC___95
NOTE:    Variable Name Change.  F_NAM_CY_CEN_LTC_<45 -> F_NAM_CY_CEN_LTC__45
NOTE:    Variable Name Change.  F_NAM_CY_CEN_LTC_>=95 -> F_NAM_CY_CEN_LTC___95
NOTE:    Variable Name Change.  F_OTH_UNK_CY_CEN_LTC_<45 -> F_OTH_UNK_CY_CEN_LTC__45
NOTE:    Variable Name Change.  F_OTH_UNK_CY_CEN_LTC_>=95 -> F_OTH_UNK_CY_CEN_LTC___95
NOTE:    Variable Name Change.  F_TOT_CY_CEN_LTC_<45 -> F_TOT_CY_CEN_LTC__45
NOTE:    Variable Name Change.  F_TOT_CY_CEN_LTC_>=95 -> F_TOT_CY_CEN_LTC___95
NOTE: One or more variables were converted because the data type is not supported by the V9 engine. For
      more details, run with options MSGLEVEL=I.
NOTE: The import data set has 1222 observations and 240 variables.
NOTE: WORK.LTCFUTIL15 data set was successfully created.
NOTE: PROCEDURE IMPORT used (Total process time):
      real time           2.88 seconds
      cpu time            2.84 seconds


NOTE: Fileref TEMPFILE has been deassigned.
160
161  /*
162  print the names of all datasets/tables created above by querying the
163  "dictionary tables" the SAS kernel maintains for the default "Work" library
164  */
165  proc sql;
166      select *
167      from dictionary.tables
168      where libname = 'WORK'
169      order by memname;
NOTE: Writing HTML Body file: sashtml.htm
170  quit;
NOTE: PROCEDURE SQL used (Total process time):
      real time           3.17 seconds
      cpu time            1.93 seconds


