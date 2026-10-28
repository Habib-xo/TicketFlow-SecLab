from flask import Flask
import mysql.connector
import os

app = Flask(__name__)
@app.route('/')
def home():
   return "Hello from Docker Compose with Python! hi guest"

@app.route('/testConnection')
def testdb():
   try:
      mydb = mysql.connector.connect(
         host = os.getenv("MYSQL_HOST"),
         user = os.getenv("MYSQL_USER"),
         password = os.getenv("MYSQL_PASSWORD"),
         database = os.getenv("MYSQL_DATABASE"),
         port = 3306
      )
      
      if mydb.is_connected():
               version = mydb.get_server_info()
               mydb.close()
               return f"Database connected successfully! MySQL Server Version: {version}", 200
               
   except mysql.connector.Error as e:
      return f"Failed to connect to MySQL: {str(e)}", 500

if __name__ == '__main__':
   app.run(host='0.0.0.0', port=5000)