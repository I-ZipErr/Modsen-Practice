import socket
from flask import Flask
app = Flask(__name__)

@app.route("/")
def main():
    return "Welcome!"

@app.route('/who are you')
def hello():
    return 'My name is ' + socket.gethostname()+ '. I am good, how about you?'

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)