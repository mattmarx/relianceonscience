import os,shutil
import sys
from google.cloud import bigquery
from google.oauth2 import service_account

# input parameters from user
cred = sys.argv[1]
pos = sys.argv[2]  # [front,body]
a = sys.argv[3]  # included
b = sys.argv[4]  # excluded

#Get Google Cloud credentials. [documentation: https://cloud.google.com/bigquery/docs/reference/libraries#client-libraries-usage-python]
path = './' + cred
credentials = service_account.Credentials.from_service_account_file(path,scopes=["https://www.googleapis.com/auth/cloud-platform"],)

# Construct a BigQuery client object.
client = bigquery.Client(credentials=credentials,project=credentials.project_id,)

if pos == 'front':
    query = """ SELECT pub.publication_number,pub.filing_date,citations.npl_text
                FROM `patents-public-data.patents.publications` as pub
                    CROSS JOIN UNNEST(citation) as citations
                WHERE citations.npl_text <> ""
                AND grant_date >= {} AND grant_date < {}
            """.format(a,b)

elif pos == 'body':
    query = """
                SELECT pub.publication_number,pub.filing_date,description.text
                FROM `patents-public-data.patents.publications` as pub
                    CROSS JOIN UNNEST(description_localized) as description
                WHERE description.text <> ""
                AND grant_date >= {} AND grant_date < {}
            """.format(a,b)

#create empty string
results = ""
#Try: send query, populate string, write to file, and update the tracker.
try:
    # querying
    print("Sending query to Google Cloud..")
    query_job = client.query(query)  # Make an API request.
    i = 0

    for row in query_job:
        # Row values can be accessed by field name or index.
        # Sometimes a row is empty having no data, so use TRY to catch that. This is an error due to GoogleQuery

        try:
            # for first column, that's the ID, type double underscores before and after
            new_line = "__" + row[0] + "__" + "\t" + str(row[1])[0:4:1] + '\n'

        except IndexError:
            new_line = ""

        results += new_line
        i += 1

    # Open a new text file to store the queried years, name the file as a range #####################
    if (pos == 'front'):
        output_file_name = "/home/fs01/nplmatchroot/nplmatch/process_matches/googlePatents/" + "frontpatents" + a + "-" + b + ".txt"
        output_file = open(output_file_name, "w")
        output_file.write(results)

        os.chmod(output_file_name,0o777)
        output_file.close()

    elif pos == 'body':
        output_file_name = "/home/fs01/nplmatchroot/nplmatch/process_matches/googlePatents/"  + "bodypatents" + a + "-" + b + ".txt"
        output_file = open(output_file_name, "w")
        output_file.write(results)

        os.chmod(output_file_name,0o777)
        output_file.close()

    print("Done! {} rows were downloaded to {}.".format(i, output_file_name))

#If this TRY is interrupter, then print ERROR
except Exception as e:
    # print error message
    print("ERROR! ", e)
