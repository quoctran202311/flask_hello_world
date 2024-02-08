from flask import Flask, render_template_string, render_template, jsonify
from flask import Flask, render_template, request
from flask import json
from urllib.request import urlopen
import sqlite3
                                                                                                                                       
app = Flask(__name__)                                                                                                                  
                                                                                                                                       
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

@app.route('/add_client/', methods=['GET', 'POST'])
def add_client():
    if request.method == 'POST':
        nom = request.form['nom']
        prenom = request.form['prenom']
        adresse = request.form['adresse']

        # Connexion à la base de données
        conn = sqlite3.connect('database.db')
        cursor = conn.cursor()

        # Insertion des données dans la base de données
        if conn is not None:
            query = f"INSERT INTO clients (nom, prenom, adresse) VALUES ('{nom}', '{prenom}', '{adresse}')"
            execute_query(conn, query)
            conn.close()
            # Rediriger vers la page de consultation des clients après l'ajout
            return redirect(url_for('consultation'))
            # return redirect('/')
        else:
            return 'Erreur de connexion à la base de données'

    # Si la méthode est GET, simplement rendre le template du formulaire
    return render_template('create_data.html')


if __name__ == "__main__":
  app.run(debug=True)
