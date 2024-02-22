from flask import Flask, render_template_string, render_template, jsonify
from flask import Flask, render_template, request, redirect
from flask import json
from urllib.request import urlopen
import sqlite3
import mysql.connector
#from flask_sqlalchemy import SQLAlchemy
#from flask_mysqldb import MySQL


app = Flask(__name__)

#app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://tran_admin:adm\@Alw202311@mysql-tran.alwaysdata.net/tran_weeat'
#db = SQLAlchemy(app)

app.config['MYSQL_HOST'] = 'mysql-tran.alwaysdata.net'
app.config['MYSQL_USER'] = 'tran_admin'
app.config['MYSQL_PASSWORD'] = 'adm@Alw202311'
app.config['MYSQL_DB'] = 'tran_weeat'
#mysql = MySQL(app)

# Configure MySQL connection
mysql_connection = mysql.connector.connect(
    host="mysql-tran.alwaysdata.net",
    user="tran_admin",
    password="adm@Alw202311",
    database="tran_weeat"
)


@app.route('/')
def hello_world():
    return render_template('hello.html')

@app.route("/fr/")
def monfr():
    return "<h2>Bonjour tout le monde !</h2>"

@app.route('/paris/')
def meteo():
    response = urlopen('https://api.openweathermap.org/data/2.5/forecast/daily?q=Paris,fr&cnt=16&appid=bd5e378503939ddaee76f12ad7a97608')
    raw_content = response.read()
    json_content = json.loads(raw_content.decode('utf-8'))
    results = []
    for list_element in json_content.get('list', []):
        dt_value = list_element.get('dt')
        temp_day_value = list_element.get('temp', {}).get('day') - 273.15 # Conversion de Kelvin en °c 
        results.append({'Jour': dt_value, 'temp': temp_day_value})
    return jsonify(results=results)

@app.route("/rapport/")
def mongraphique():
    return render_template("graphique.html")

@app.route("/rapportcamembert/")
def mongraphiquehisto():
    return render_template("graphiquehisto.html")

@app.route("/rapportbarre/")
def mongraphiquecol():
    return render_template("graphiquecol.html")

@app.route("/consultation/")
def ReadBDD():
    conn = sqlite3.connect('database.db')
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM clients;')
    data = cursor.fetchall()
    conn.close()
    
    # Rendre le template HTML et transmettre les données
    return render_template('read_data.html', data=data)

@app.route('/fiche_client/<int:post_id>')
def Readfiche(post_id):
    conn = sqlite3.connect('database.db')
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM clients WHERE id = ?', (post_id,))
    data = cursor.fetchall()
    conn.close()
    
    # Rendre le template HTML et transmettre les données
    return render_template('read_data.html', data=data)

@app.route('/fiche_clientn/<string:nom>')
def Readfichenom(nom):
    conn = sqlite3.connect('database.db')
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM clients WHERE nom LIKE ?', (nom,))
    data = cursor.fetchall()
    conn.close()
    
    # Rendre le template HTML et transmettre les données
    return render_template('read_data.html', data=data)

@app.route('/search_client', methods=['GET', 'POST'])
def Searchfiche():

    # nom = input("Nom client a chercher: ");
    if request.method == 'POST':
        nom = request.form['nom']
        conn = sqlite3.connect('database.db')
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM clients WHERE nom = ?', (nom,))
        data = cursor.fetchall()
        conn.close()
        if data:
            return render_template('read_data.html', data=data)
        else:
            return "No client found with that name."
    else:     
       return "Method not allowed for..."

@app.route('/ajouter_client/', methods=['GET', 'POST'])
def ajouter_client():
    if request.method == 'POST':
        # Récupérer les données du formulaire
        nom = request.form['nom']
        prenom = request.form['prenom']
        adresse = request.form['adresse']

        # Insérer les données dans la base de données (ici, je suppose que tu as une table 'clients')
        conn = sqlite3.connect('database.db')
        cursor = conn.cursor()
        if conn is not None:
            cursor.execute('INSERT INTO clients (nom, prenom, adresse) VALUES (?, ?, ?)', (nom, prenom, adresse))
            conn.commit()
            conn.close()
        else:
            return 'Erreur de connexion à la base de données'

        # Rediriger vers la page de consultation des clients après l'ajout
        return redirect(url_for('/'))

    # Si la méthode est GET, simplement rendre le template du formulaire
    return render_template('create_data.html')

app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'  # Clé secrète pour les sessions (à cacher par la suite)

# Fonction pour créer une entrée "authentifie" dans la session de l'utilisateur
def est_authentifie():
    return session.get('authentifie')

@app.route('/lecture')
def lecture():
    if not est_authentifie():
        # Rediriger vers la page d'authentification si l'utilisateur n'est pas authentifié
        return redirect(url_for('authentification'))
        

  # Si l'utilisateur est authentifié
    return "<h2>Bravo, vous êtes authentifié</h2>"


@app.route('/authentification', methods=['GET', 'POST'])
def authentification():
    if request.method == 'POST':
        # Vérifier les identifiants
        if request.form['username'] == 'admin' and request.form['password'] == 'password': # password à cacher par la suite
            session['authentifie'] = True
            # Rediriger vers la route lecture après une authentification réussie
            return redirect(url_for('lecture'))
        else:
            # Afficher un message d'erreur si les identifiants sont incorrects
            return render_template('formulaire_authentification.html', error=True)

    return render_template('formulaire_authentification.html', error=False)


@app.route('/client_Read')
def display_client():

    # Creating a connection cursor
  
    #cursor = mysql.connection.cursor()
    cursor = mysql_connection.cursor()
    # data = User.query.all()
    cursor.execute('SELECT * FROM Clients;')
    data = cursor.fetchall()
    #conn.close()
    
    # Closing the cursor
    cursor.close()

    # Rendre le template HTML et transmettre les données
    # return render_template('users.html', users=clients)
    return render_template('/client_Read.html', data=data)


if __name__ == "__main__":
  app.run(debug=True)
