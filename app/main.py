from flask import Flask, make_response, request, render_template
from random import randrange
import jwt
import datetime
from contextlib import closing
import sqlite3

#Declare the app
flaskapp = Flask(__name__)
SECRET_KEY = "3D238B65CF6D68E4B6797BBEF4EC3"

# Start an app route
def newuser(username, password):
    with closing(sqlite3.connect("users.db")) as connection:
        with closing(connection.cursor()) as cursor:
            cursor.execute("INSERT INTO user_info (username, password) VALUES(?,?)",(username, password,))
            connection.commit()

def verify_token(token):
    if user_token:
        decoded_token = jwt.decoded(token, SECRET_KEY, "HS256")
        with closing(sqlite3.connect("users.db")) as connection:
            with closing(connection.cursor()) as cursor:
                cursor.execute("SELECT * FROM user_info WHERE username=?", (decoded_token.get('username'),))
                userdata=cursor.fetchone()

        if userdata != None:
            return True
        else:
            return falsle
    else:
        return False

@flaskapp.route('/')
def index_page():
    print(request.cookies)
    isUserLoggedIn = False

    if 'token' in request.cookies:
        isUserLoggedIn = verify_token(request.cookies['token'])

    if isUserLoggedIn:
        return render_template("calculator.html")
    else:
        return render_template("main.html")

@flaskapp.route('/login')
def login_page():
    return render_template('login.html')


def create_token(username, password):
    validity = datetime.datetime.utcnow() + datetime.timedelta(days=15)
    token = jwt.encode({'user_id': 123154, 'username': 'user', 'expiry': str(validity)}, SECRET_KEY, "HS256")
    return token


@flaskapp.route('/auth', methods = ['POST'])
def authenticate_users():
    try:
        with closing(sqlite3.connect("users.db")) as connection:
            with closing(connection.cursor()) as cursor:
                cursor.execute("CREATE TABLE user_info (id INTEGER PRIMARY KEY, username TEXT, password TEXT);")
                connection.commit()
    except:
        pass
    data = request.form
    username = data['username']
    password = data['password']
    with closing(sqlite3.connect("users.db")) as connection:
        with closing(connection.cursor()) as cursor:
            cursor.execute("SELECT * FROM user_info WHERE username=? and password=?", (username, password,))
            udat=cursor.fetchone()
        if udat == None:
            newuser(username,password)
            user_token = create_token(username, password)
            resp = make_response(render_template('loginredirect.html'))
            resp.set_cookie('token', user_token)
            return resp
        else:
            user_token = create_token(username,password)
            resp = make_response(render_template('calculator.html'))
            resp.set_cookie('token', user_token)
            return resp

@flaskapp.route('/send', methods=['POST','GET'])
def send(sum=sum):
    print(request.cookies)
    if request.method == 'POST':
        num1 = request.form['num1']
        num2 = request.form['num2']
        operation = request.form['operation']

        if operation == 'add':
            sum = float(num1) + float(num2)
            return render_template('calculator.html', sum=sum)
        elif operation == 'subtraction':
            sum = float(num1) - float(num2)
            return render_template('calculator.html', sum=sum)
        if operation == 'multiply':
            sum = float(num1) * float(num2)
            return render_template('calculator.html', sum=sum)
        elif operation == 'division':
            sum = float(num1) / float(num2)
            return render_template('calculator.html', sum=sum)
        else:
            return render_template('calculator.html')



if __name__ == '__main__':
    print("This is a Secure REST API Server:")
    flaskapp.run(host="0.0.0.0", debug = True, ssl_context=('cert/cert.pem', 'cert/key.pem'))
