******************************************************************************************;
* PROGRAM DESCRIPTION: Create Data for the Python Course                                 *;
* DATE: 09/28/2021                                                                       *;
******************************************************************************************;
* SUMMARY:                                                                               *;
*	- Creates fakes data for the Python course. Creates fake loan, customer and app      *;
*     rating data. Also utilizes the heart and cars sashelp tables.                      *;
*	- All data will be created in the casuser caslib. No data is deleted from the        *;
*	  casuser caslib in case it deletes necessary/saved files.                           *;
*	- Program saves a variety of data source files in different formats.                 *;
*   - The fake data is created based on the number of threads on the CAS server. These   *;
*     can be adjusted in the 'Set Number of Customers' section below.                    *; 
******************************************************************************************;
* REQUIREMENTS:                                                                          *;
* 1. All execute programs reside in same folder location.                                *;
* - 01_cre8loan_raw.sas                                                                  *;
* - 02_cre8customer_raw.sas                                                              *;
* - 03_cre8appratings.sas                                                                *;
* - 04_cre8sashelp_data.sas                                                              *;
* - 05_utility.sas                                                                       *;
******************************************************************************************;
* FILES CREATED (CASUSER caslib):                                                        *;
* - loans_raw CAS table (deletes) -> loans_raw.sashdat(saves)                            *;
* - customers CAS table (deletes). Table is used to create customers_raw.                *;
* - customers_raw CAS table (deletes) -> customers_raw.csv(saves)                        *;
* - appRatings CAS table (deletes) -> AppRatings.sashdat(saves)                          *;
* - cars CAS table (deletes), cars.txt, cars.sas7bdat(saves)                             *;
* - heart CAS table (deletes) -> heart.sashdat(saves)                                    *;
* FINAL OUTPUT: 1 promoted in-memory table (cars), 6 data source files                   *;
******************************************************************************************;

**************************;
* Set the Folder Path    *;
**************************;
%let homedir=%sysget(HOME);
%let path=&homedir/cre8_fake_data;


***************************;
* Set Number of Customers *;
***************************;
* NOTE: Total number of rows = (specified number) x (number of threads) *;
* NOTE: Image currently has 16 threads *;

* - Sets the number of customers to use in 01_cre8loan_raw.sas. Customers can have multiple accounts *;
%let numLoanCustomers = 450002;


* - Sets the number of additional customers to add without loans in 02_cre8customer_raw.sas *; 
* - Customers here only having savings and checking accounts *;
%let numAdditionalCustomers = 40003;


* - Sets the number of app ratings for the products in 03_cre8appratings.sas *;
%let numRatings = 1100003;



*****************************;
* Create Connection to CAS  *;
*****************************;
cas conn;
libname casuser cas caslib='casuser';


******************************;
* Execute cre8 Data Programs *;
******************************;
%include "&path/01_cre8loans_raw.sas";
%include "&path/02_cre8customer_raw.sas";
%include "&path/03_cre8appratings.sas";
%include "&path/04_cre8sashelp_data.sas";
%include "&path/05_utility.sas";


*************************;
* Terminate Connection  *;
*************************;
cas conn terminate;