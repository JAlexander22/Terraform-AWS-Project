from flask import Flask, make_response, request, render_template, redirect, jsonify
from random import randrange
import jwt
import datetime
from contextlib import closing
import sqlite3
import calculator_func

#Declare the app
flaskapp = Flask(__name__)
SECRET_KEY = "3D238B65CF6D68E4B6797BBEF4EC3"

# @component External:Guest (#guest)

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
            return False
    else:
        return False

# @component CalcApp:Web:Server:Index (#index)
# @component #guest to #index with HTTP-GET
@flaskapp.route('/')
def index_page():
    print(request.headers)
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
            resp = make_response(redirect('/calculator'))
            resp = make_response(render_template('calculator.html'))
            resp.set_cookie('token', user_token, max_age=606024*2, httponly=True, secure=True, samesite='Strict')
            return resp



@flaskapp.route('/logout', methods = ['GET'])
def calculator_logout():
    resp = make_response(redirect('/login'))
    resp.delete_cookie('token')
    return resp



@flaskapp.route('/calculator', methods = ['GET'])
def calculator_get():
    isUserLoggedIn = False
    if 'token' in request.cookies:
        isUserLoggedIn = verify_token(request.cookies['token'])


    if isUserLoggedIn:
        return render_template("calculator.html")
    else:
        resp = make_response(redirect('/login'))
        return resp




@flaskapp.route('/calculator', methods=['POST'])
def send():
    if request.method == 'POST':
        num1 = request.form.get('num1', type = int)
        num2 = request.form.get('num2', type = int)
        operation = request.form.get('operation')

        result = calculator_func.process(num1, num2, operation)
        return str(result)

@flaskapp.route('/calculator2', methods= ['POST'])
def calculator_post2():
    number1 = request.form.get('num1', type = int)
    number2 = request.form.get('num2', type = int)
    operation = request.form.get('operation', type = str)

    result = calculator_func.process(number1, number2, operation)

    response_data = {
        'data':result
    }

    return make_response(jsonify(response_data))


if __name__ == '__main__':
    print("This is a Secure REST API Server:")
    flaskapp.run(host = '0.0.0.0', debug = True, ssl_context=('cert/cert.pem', 'cert/key.pem'))
