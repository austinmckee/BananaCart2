from flask import Flask
import cointool
import json

app = Flask(__name__)

@app.route('/')
def index():
        return "BananaCart API"

@app.route('/coin/price/<float:cost>/name/<string:name>', methods=['GET'])
def return_coin_interface(cost, name):
	code = json.loads(cointool.send_request(cost,name))["button"]["code"]
	return "https://sandbox.coinbase.com/checkouts/" + code
#@app.route('/user/<username>')
#def show_user_profile(username):
#    # show the user profile for that user
#    return 'User %s' % username

if __name__ == '__main__':
        app.run(port=51234, debug=True, host='0.0.0.0')
