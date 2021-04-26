*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

/* 
[Dataset 1 Name] ltcfstaffing15
[Dataset Description] California Long Term Care Facility Nurse Staffing Hours
Worked in 2015
[Experimental Unit Description] Operating long-term care facilities in 
California in 2015
[Number of Observations] 1,112 
 
[Number of Features] 15
[Data Source] The file https://data.chhs.ca.gov/dataset/
6e946377-6360-400b-b8df-3528cfdb8b4d/resource/
5879d2fe-1729-40d6-b58f-61642dac00f4/
download/long-term-care-facility-staffing.csv was downloaded and converted 
to an Excel worksheet
[Data Dictionary] https://data.chhs.ca.gov/dataset/
6e946377-6360-400b-b8df-3528cfdb8b4d/resource/
fd27d1b0-0079-4bcd-9a3f-d52c1a4d6371/download/hid-datadictionaryltcstaffing.docx
[Unique ID Schema] The column ‚ÄúFAC_NO‚Äù is a primary key and is equivalent 
to the unique id column ‚ÄúOSHPD_ID‚Äù in ltcfutil15.
*/
%let inputDataset1DSN = ltcfstaffing15;
%let inputDataset1URL =
https://github.com/stat660/team-3_project_repo/blob/main/data/ltcfstaffing15.xlsx?raw=true;
%let inputDataset1Type = XLSX;


/*
[Dataset 2 Name] ltcfprofitability15
[Dataset Description] California Long Term Care Facility Income Statement Data 
in 2015
[Experimental Unit Description] Operating long-term care facilities in 
California in 2015
[Number of Observations] 1,112 
 
[Number of Features] 14
[Data Source] The file https://data.chhs.ca.gov/dataset/
4327ea61-c69b-4f43-a0eb-a354476880bb/resource/
1510e857-a2cf-4b40-b4c3-829fe72851e1/download/
long-term-care-facility-profitability.csv was downloaded and converted to an 
Excel worksheet
[Data Dictionary] https://data.chhs.ca.gov/dataset/
4327ea61-c69b-4f43-a0eb-a354476880bb/resource/
c89224f9-1b17-4967-a1b3-26285f9adf28/download/
hid-datadictionaryltcprofitability.docx
[Unique ID Schema] The column ‚ÄúFAC_NO‚Äù is a primary key and is equivalent 
to the unique id column ‚ÄúOSHPD_ID‚Äù in ltcfutil15.
*/
%let inputDataset2DSN = ltcfprofitability15;
%let inputDataset2URL =
https://github.com/stat660/team-3_project_repo/blob/main/data/ltcfprofitability15.xlsx?raw=true;
%let inputDataset2Type = XLSX;


/*
[Dataset 3 Name] ltcfutil15
[Dataset Description] California Long Term Care Facilities Service Capacity, 
Utilization, Patients, and Capital/Equipment Expenditures in 2015
[Experimental Unit Description] Operating long-term care facilities in 
California in 2015
[Number of Observations] 1,218
[Number of Features] 240
[Data Source] The file
https://data.chhs.ca.gov/dataset/ecd99c78-5032-4299-8067-a8a1e3eb434b/resource/
cf8035cd-00d6-4550-8af6-b4a702dc482b/download/ltc15utildatafinal.xlsx
was downloaded and subset to only include 2015 information
[Data Dictionary] https://data.chhs.ca.gov/dataset/
ecd99c78-5032-4299-8067-a8a1e3eb434b/resource/
65ad64d6-5092-43b5-bd7c-c5734601b17f/download/ltcfrm15.pdf
[Unique ID Schema] The column OSHPD_ID is a unique id.
*/
%let inputDataset3DSN = ltcfutil15;
%let inputDataset3URL =
https://github.com/stat660/team-3_project_repo/blob/main/data/ltcfutil15.xlsx?raw=true;
%let inputDataset3Type = XLSX;


/* load raw datasets over the wire */
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
For ltcfstaffing15, the column ìFAC_NOî is a primary key.
Rows should be removed if they are missing values for the primary key.
After running the proc sort step below, the new dataset ltcfstaffing15_deduped
will have no duplicate/repeated unique id values, and all unique id values will
correspond to our experimental units of interest, which are operating 
California Long Term Care Facilities in 2015. This means the column FAC_NO in 
ltcfstaffing15_deduped is guaranteed to be a primary key.
*/
proc sort
        nodupkey
        data=ltcfstaffing15
        dupout=ltcfstaffing15_dups
        out=ltcfstaffing15_deduped
    ;
    where
        /* remove rows with missing primary key */
        not(missing(FAC_NO))
    ;
    by
        FAC_NO
    ;
run;

/*
For ltcfprofitability15, the column ìFAC_NOî is a primary key. 
Rows should be removed if they are missing values for any of the primary key.
After running the proc sort step below, the new dataset 
ltcfprofitability15_deduped will have no duplicate/repeated unique id values, 
and all unique id values will correspond to our experimental units of interest,
which are operating California Long Term Care Facilities in 2015. This means 
the column FAC_NO in ltcfprofitability15_deduped is guaranteed to be a 
primary key.
*/
proc sort
        nodupkey
        data=ltcfprofitability15
        dupout=ltcfprofitability15_dups
        out=ltcfprofitability15_deduped
    ;
    where
        /* remove rows with missing primary key */
        not(missing(FAC_NO))
    ;
    by
        FAC_NO
    ;
run;

/*
For ltcfutil15, the column ìOSHPD_IDî is a primary key.
Rows should be removed if they are missing values for any of the primary key.
After running the proc sort step below, the new dataset ltcfutil15_deduped
will have no duplicate/repeated unique id values, and all unique id values will
correspond to our experimental units of interest, which are operating 
California Long Term Care Facilities in 2015. This means the column OSHPD_ID 
in ltcfutil15_deduped is guaranteed to be a primary key.
*/
proc sort
        nodupkey
        data=ltcfutil15
        dupout=ltcfutil15_dups
        out=ltcfutil15_deduped
    ;
    where
        /* remove rows with missing primary key */
        not(missing(OSHPD_ID))
    ;
    by
        OSHPD_ID
    ;
run;

/*
Merge-match ltcf data by FAC_NO.
*/
data ltcf_analytic_file_v1;
    merge ltcfstaffing15_deduped ltcfprofitability15_deduped;
    by FAC_NO;
run;

/*
Merge v1 analytic file to ltcfutils15
*/
data ltcf_analytic_file_v2;
    retain
        TYPE_CNTRL
        NET_INCOME
        COUNTY_NAME
        PRDHR_MGT
        PRDHR_RN
        PRDHR_LVN
        PRDHR_NA
        PRDHR_TSP
        PRDHR_PSY
        PRDHR_OTH
        DIS_LTC_PATIENT_HOSP
        PATIENT_DAYS
        COUNTY
        ID
    ;
    keep
        TYPE_CNTRL
        NET_INCOME
        COUNTY_NAME
        PRDHR_MGT
        PRDHR_RN
        PRDHR_LVN
        PRDHR_NA
        PRDHR_TSP
        PRDHR_PSY
        PRDHR_OTH
        DIS_LTC_PATIENT_HOSP
        PATIENT_DAYS
        COUNTY
        ID
    ;
    merge 
        ltcf_analytic_file_v1(rename=(FAC_NO=ID))
        ltcfutil15_deduped(rename=(OSHPD_ID=ID))
    ;
    by
        ID
	;
run;
/*
data integrity steps 
*/
data ltcf_analytic_file_v2_raw;
    set ltcf_analytic_file_v2;
    by ID;

    if
        first.ID*last.ID = 0
        or
        missing(ID)
    then
        do;
            output;
        end;
run;
