import json
import sys


dbname = sys.argv[1]

db_params = {}

with open('$HOME/boris/params/productlist.json') as json_file:
    data = json.load(json_file)
    for p in data['geoproduct']:
        if dbname == p['Zugriff']['productname']:

            db_params = {
                "user":         p['Zugriff']['user'],
                "version":      p['Zugriff']['version'],
                "port":         p['Zugriff']['port'],
                "hostname":     p['Zugriff']['hostname'],
                "tablespace":   p['Zugriff']['tablespace'],
                "productname":  p['Zugriff']['productname']
            }

            print(json.dumps(db_params))

        if dbname == '':
            print(p['Zugriff']['productname'])
