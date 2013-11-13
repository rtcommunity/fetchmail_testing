import json
execfile('fetchmailrc.py')
data_string = json.dumps(fetchmailrc)
print data_string
