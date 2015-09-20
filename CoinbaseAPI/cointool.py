import os
import hashlib
import hmac
import urllib2
import time
import json

api_key = 'O906nWjJtmfjnzAr'
api_secret = 'er7vHtOCHJjhBDRzxcpNVmtXt8cg58Uc'

#This code sample demonstrates a GET call to the Coinbase API
def make_request(url, body=None):
  opener = urllib2.build_opener()
  nonce = int(time.time() * 1e6)
  message = str(nonce) + url + ('' if body is None else body)
  signature = hmac.new(api_secret, message, hashlib.sha256).hexdigest()

  headers = {'ACCESS_KEY' : api_key,
             'ACCESS_SIGNATURE': signature,
             'ACCESS_NONCE': nonce,
             'Accept': 'application/json'}

  # If we are passing data, a POST request is made. Note that content_type is specified as json.
  if body:
    headers.update({'Content-Type': 'application/json'})
    req = urllib2.Request(url, data=body, headers=headers)

  # If body is nil, a GET request is made.
  else:
    req = urllib2.Request(url, headers=headers)

  try:
    return opener.open(req)
  except urllib2.HTTPError as e:
    print e
    return e


# Required parameters for POST /api/v1/buttons
def send_request(cost, name):
	button_params = {
  	'button': {
    	'name' : name,
    	'price_string' : cost,
    	'price_currency_iso' : 'USD'
  	  }
	}

	#POST /api/v1/buttons
	r = make_request('https://api.sandbox.coinbase.com/v1/buttons', body=json.dumps(button_params)).read()
	return r
