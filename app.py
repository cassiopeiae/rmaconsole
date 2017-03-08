#!/usr/bin/env/python
'''
    Super quick super cheesy dump RMA details out
    demo for later cooler app perhaps
'''

__author__ = 'sluzynsk'

from flask import Flask
from flask import render_template
from flask import request
import requests
import os


app = Flask(__name__)

client_id = os.environ.get("CLIENT_ID")
client_secret = os.environ.get("CLIENT_SECRET")


@app.route('/')
def home():
    the_arg = request.args.get('rma')
    if (the_arg):
        rma_num = [x.strip() for x in the_arg.split(',')]
        returns = []
        for index in rma_num:
            print index
            req_url = 'https://api.cisco.com/return/v1.0/returns/rma_numbers/' + index
            headers = {'Authorization': 'Bearer ' + get_token()}
            data = requests.get(req_url, headers=headers)
            returns.append(data.json()[u'returns'][u'RmaRecord'][0])
    return render_template('index.html', rma=rma_num, response=returns,
                           title='RMA Console')


def get_token():
    req_url = 'https://cloudsso.cisco.com/as/token.oauth2'
    headers = {'client_id': client_id,
               'client_secret': client_secret,
               'grant_type': 'client_credentials'}
    r = requests.post(req_url, params=headers, verify=False)

    if (r.status_code == 200):
        return r.json()[u'access_token']
    else:
        return 0


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
