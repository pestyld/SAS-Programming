import pandas as pd
import requests
import os
import swat


# ##
# ## CONNECT TO THE CAS SERVER
# ##

user_name = os.environ.get('sas_viya_user')
user_password = os.environ.get('sas_viya_password')
conn = swat.CAS('server.demo.sas.com', 30571, user_name, user_password)


##
## CLEAN JSON DATA FUNCTION AND CREATE A PANDAS DATAFRAME
##

def createData(_censusJSON):
    
    # Obtain column names from the JSON file in the first row
    pop_data_col_names = _censusJSON.json()[0]
    
    # Make column names lowercase
    pop_data_col_names = [x.lower() for x in pop_data_col_names]
    
    # Obtain data from the JSON file. First row is headers
    pop_data = _censusJSON.json()[1:]
    
    # Create the dataframe and add the rows and columns
    df = pd.DataFrame(data = pop_data, columns = pop_data_col_names)
    
    # Prepare the DataFrame
    return (df
            .astype({'density_2021':'float',
                     'pop_2021':'int64',
                     'npopchg_2021':'int64'})
            .assign(
                population_pct_2021 = lambda _df: _df.pop_2021 / _df.pop_2021.sum()
                   )
    )



##
## REQUEST TO THE CENSUS API
##

# Get the api key from the csv file and store it
df = pd.read_csv('census_api.csv', header = None)
api_key = df.loc[0,0]
census_url = df.loc[1,0]


# API call for stat population data from the Census
parameters = {'get' : 'DENSITY_2021,POP_2021,NAME,NPOPCHG_2021',
              'for' : 'state',
              'key' : api_key}

JSONdata = requests.get(census_url, params = parameters, timeout = 5)



##
## CREATE A DATAFRAME WITH THE JSON FILE USING THE USER DEFINED FUNCTION
##

df = createData(JSONdata)
print('PREVIEW THE DATAFRAME')
print(df.dtypes, df)



##
## SEND THE DATAFRAME TO THE CAS SERVER 
##

# Table to create in the CAS server
pop_swat_cas_table = {'name':'population2021_swat', 
                      'caslib':'casuser', 
                      'promote':True}


# Drop the global scope table if it exists
conn.dropTable(name = pop_swat_cas_table['name'], 
               caslib = pop_swat_cas_table['caslib'], 
               quiet = True)


# Upload the DataFrame to the CAS server
conn.upload(df, casout = pop_swat_cas_table)



##
## TERMINATE THE CAS CONNECTION
##
conn.terminate()