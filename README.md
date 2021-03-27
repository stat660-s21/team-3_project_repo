
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

Question 1 of 3: Do the Investor Owned long term care facilities on average make more net income than the Not for Profit long term care facilities? (Rationale: This should help identify   if the type of ownership control impacts how profitable the long term care facility will be) [Note: This compares the columns “NET_INCOME”  and “TYPE_CNTRL” from ltcfprofitability.]

*/


*******************************************************************************;
* Research Question 2 Analysis Starting Point;
*******************************************************************************;
/*
Question 2 of 3: Are the total hours worked by registered nurses dependent on the total patient census days? Does more patient days mean more hours have to be worked by the registered nurses? (Rationale: This should help identify if the total patient census days are a significant factor in how many hours are worked by the registered nurses.) [Note: This compares the column “PRDHR_RN” with “PATIENT_DAYS” from ltcfstaffing.]
*/


*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;
/*
Question 3 of 3:  Is a long term care facility dependent on the total patient census days in order to be profitable? In other words do the facilities that are most profitable have the highest patient days or can a facility be profitable and still log lower patient days? (Rationale: This should help identify whether the patient census days are a significant factor in determining profitability.) [Note: This compares the column “PATIENT_DAYS with “NET_INCOME” from ltcfprofitability.]
*/

*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

/* 
[Dataset 1 Name] ltcfstaffing15
[Dataset Description] California Long Term Care Facility Nurse Staffing Hours
Worked in 2015
[Experimental Unit Description] Operating long-term care facilities in California
in 2015
[Number of Observations] 1,112     
[Number of Features] 15
[Data Source] The file https://data.chhs.ca.gov/dataset/
6e946377-6360-400b-b8df-3528cfdb8b4d/resource/5879d2fe-1729-40d6-b58f-61642dac00f4/
download/long-term-care-facility-staffing.csv
was downloaded and converted to an Excel worksheet
[Data Dictionary] https://data.chhs.ca.gov/dataset/6e946377-6360-400b-b8df-3528cfdb8b4d/
resource/fd27d1b0-0079-4bcd-9a3f-d52c1a4d6371/download/hid-datadictionaryltcstaffing.docx
[Unique ID Schema] The column “FAC_NO” is a primary key and is equivalent to the
unique id column “OSHPD_ID” in ltcfutil15.
*/
%let inputDataset1DSN = ltcfstaffing15;
%let inputDataset1URL =
https://github.com/stat660/team-3_project_repo/blob/sl-week2/data/ltcfstaffing15.xlsx?raw=true
;
%let inputDataset1Type = XLSX;


/*
[Dataset 2 Name] ltcfprofitability15
[Dataset Description] California Long Term Care Facility Income Statement Data in 2015
[Experimental Unit Description] Operating long-term care facilities in California in 2015
[Number of Observations] 1,112     
[Number of Features] 14
[Data Source] The file https://data.chhs.ca.gov/dataset/4327ea61-c69b-4f43-a0eb-a354476880bb/
resource/1510e857-a2cf-4b40-b4c3-829fe72851e1/download/long-term-care-facility-profitability.csv
was downloaded and converted to an Excel worksheet
[Data Dictionary] https://data.chhs.ca.gov/dataset/4327ea61-c69b-4f43-a0eb-a354476880bb/
resource/c89224f9-1b17-4967-a1b3-26285f9adf28/download/hid-datadictionaryltcprofitability.docx
[Unique ID Schema] The column “FAC_NO” is a primary key and is equivalent to the unique id 
column “OSHPD_ID” in ltcfutil15.
*/
%let inputDataset2DSN = ltcfprofitability15;
%let inputDataset2URL =
https://github.com/stat660/team-3_project_repo/blob/sl-week2/data/ltcfprofitability15.xlsx?raw=true
;
%let inputDataset2Type = XLSX;


/*
[Dataset 3 Name] ltcfutil15
[Dataset Description] California Long Term Care Facilities Service Capacity, 
Utilization, Patients, and Capital/Equipment Expenditures in 2015
[Experimental Unit Description] Operating long-term care facilities in California in 2015
[Number of Observations] 1,218
[Number of Features] 240
[Data Source] The file
https://data.chhs.ca.gov/dataset/ecd99c78-5032-4299-8067-a8a1e3eb434b/resource/
cf8035cd-00d6-4550-8af6-b4a702dc482b/download/ltc15utildatafinal.xlsx
was downloaded and subset to only include 2015 information
[Data Dictionary] https://data.chhs.ca.gov/dataset/ecd99c78-5032-4299-8067-a8a1e3eb434b/
resource/65ad64d6-5092-43b5-bd7c-c5734601b17f/download/ltcfrm15.pdf
[Unique ID Schema] The column OSHPD_ID is a unique id.
*/
%let inputDataset3DSN = ltcfutil15;
%let inputDataset3URL =
https://github.com/stat660/team-3_project_repo/blob/sl-week2/data/ltcfutil15.xlsx?raw=true
;
%let inputDataset3Type = XLSX;


/* load raw datasets over the wire, if they doesn't already exist */
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename
                tempfile
                "%sysfunc(getoption(work))/tempfile.&filetype."
            ;
            proc http
                    method="get"
                    url="&url."
                    out=tempfile
                ;
            run;
            proc import
                    file=tempfile
                    out=&dsn.
                    dbms=&filetype.
                ;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%macro loadDatasets;
    %do i = 1 %to 3;
        %loadDataIfNotAlreadyAvailable(
            &&inputDataset&i.DSN.,
            &&inputDataset&i.URL.,
            &&inputDataset&i.Type.
        )
    %end;
%mend;
%loadDatasets

/*
print the names of all datasets/tables created above by querying the
"dictionary tables" the SAS kernel maintains for the default "Work" library
*/
proc sql;
    select *
    from dictionary.tables
    where libname = 'WORK'
    order by memname;
quit;
