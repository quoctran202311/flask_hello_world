from flask import Flask, render_template_string, render_template, jsonify
from flask import Flask, render_template, request, redirect
from flask import json
from urllib.request import urlopen
import sqlite3


app = Flask(__name__)


@app.route('/')
def hello_world():
    return render_template('hello.html')

@app.route("/fr/")
def monfr():
    return "<h2>Bonjour POEC-POEC !</h2>"

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

@app.route("/t_consultation", methods=['GET'])
def ReadBDD():
    conn = sqlite3.connect('database.db')
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM clients;')
    data = cursor.fetchall()
    conn.close()
    
    # Rendre le template HTML et transmettre les données
    return render_template('read_data.html', data=data)

@app.route('/t_fiche_client/<int:post_id>')
def Readfiche(post_id):
    conn = sqlite3.connect('database.db')
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM clients WHERE id = ?', (post_id,))
    data = cursor.fetchall()
    conn.close()
    
    # Rendre le template HTML et transmettre les données
    return render_template('read_data.html', data=data)

@app.route('/t_fiche_clientn/<string:nom>')
def ReadFicheNom(nom):
    conn = sqlite3.connect('database.db')
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM clients WHERE nom LIKE ?', ('%' + nom + '%',))
    data = cursor.fetchall()
    conn.close()
    
    # Rendre le template HTML et transmettre les données
    return render_template('read_data.html', data=data)

@app.route('/t_chercher_client', methods=['GET', 'POST'])
def chercher_client():
    data = []  # Define data as an empty list
    if request.method == 'POST':
        # Récupérer les données du formulaire
        nom = request.form['nom']

        # ici, je suppose que tu as une table 'clients'
        conn = sqlite3.connect('database.db')
        cursor = conn.cursor()
        if conn is not None:
            cursor.execute('SELECT * FROM clients WHERE nom LIKE ?', ('%' + nom + '%',))
            data = cursor.fetchall()
            conn.close()
            # Rendre le template HTML et transmettre les données
            return render_template('read_data.html', data=data)
        else:
            return 'Erreur de connexion à la base de données'
        
    # Rendre le template HTML et transmettre les données
    return render_template('search_data.html', data=data)


@app.route('/t_ajouter_client', methods=['GET', 'POST'])
def ajouter_client():
    data = []  # Define data as an empty list
    if request.method == 'POST':
        data = []  # Define data as an empty list
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
            # cursor.execute('SELECT * FROM clients;')
            # data = cursor.fetchall()
            conn.close()
            return redirect('/t_consultation')
            #return redirect(url_for('ReadBDD'))
            # Rendre le template HTML et transmettre les données
            # return render_template('read_data.html', data=data)
        else:
            return 'Erreur de connexion à la base de données'

        # Rediriger vers la page de consultation des clients après l'ajout
        # return redirect(url_for('ReadBDD'))
        # return redirect('/t_consultation')
        # return render_template('read_data.html', data=data)

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


@app.route("/mspr_Consulter_Client", methods=['GET'])
def Afficher_Client():
    conn = sqlite3.connect('weeat.db')
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM Clients;')
    data = cursor.fetchall()
    conn.close()
    
    # Rendre le template HTML et transmettre les données
    return render_template('mspr_Afficher_Client.html', data=data)


@app.route('/mspr_Chercher_Client', methods=['GET', 'POST'])
def d_Chercher_Client():
    data = []  # Define data as an empty list
    if request.method == 'POST':
        # Récupérer les données du formulaire
        nom = request.form['nom']

        # ici, je suppose que tu as une table 'clients'
        conn = sqlite3.connect('weeat.db')
        cursor = conn.cursor()
        if conn is not None:
            cursor.execute('SELECT * FROM clients WHERE nom LIKE ?', ('%' + nom + '%',))
            data = cursor.fetchall()
            conn.close()
            # Rendre le template HTML et transmettre les données
            return render_template('mspr_Afficher_Client.html', data=data)
        else:
            return 'Erreur de connexion à la base de données'
        
    # Rendre le template HTML et transmettre les données
    return render_template('mspr_Chercher_Client.html', data=data)


@app.route('/mspr_Ajouter_Client', methods=['GET', 'POST'])
def d_mspr_Ajouter_Client():
    if request.method == 'POST':
        # Récupérer les données du formulaire
        nom = request.form['nom']
        prenom = request.form['prenom']
        email = request.form['email']
        telephone = request.form['telephone']

        # Insérer les données dans la table 'clients'
        conn = sqlite3.connect('weeat.db')
        cursor = conn.cursor()
        if conn is not None:
            cursor.execute('INSERT INTO clients (Nom, Prenom, Email, Telephone) VALUES (?, ?, ?, ?)', (nom, prenom, email, telephone))
            conn.commit()
            conn.close()
            return redirect('/mspr_Consulter_Client')
            # return redirect(url_for('Afficher_Client'))
            # Rendre le template HTML et transmettre les données
            # return render_template('mspr_Afficher_Client.html', data=data)
        else:
            return 'Erreur de connexion à la base de données'

        # Rediriger vers la page de consultation des clients après l'ajout
        return redirect(url_for('Afficher_Client'))

    # Si la méthode est GET, simplement rendre le template du formulaire
    return render_template('mspr_Ajouter_Client.html')


@app.route("/mspr_Consulter_Livreur", methods=['GET'])
def Afficher_Livreur():
    conn = sqlite3.connect('weeat.db')
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM Livreurs;')
    data = cursor.fetchall()
    conn.close()
    
    # Rendre le template HTML et transmettre les données
    return render_template('mspr_Afficher_Livreur.html', data=data)


@app.route('/mspr_Chercher_Livreur', methods=['GET', 'POST'])
def d_Chercher_Livreur():
    data = []  # Define data as an empty list
    if request.method == 'POST':
        # Récupérer les données du formulaire
        nom = request.form['nom']

        # ici, je suppose que tu as une table 'Livreurs'
        conn = sqlite3.connect('weeat.db')
        cursor = conn.cursor()
        if conn is not None:
            cursor.execute('SELECT * FROM Livreurs WHERE nom LIKE ?', ('%' + nom + '%',))
            data = cursor.fetchall()
            conn.close()
            # Rendre le template HTML et transmettre les données
            return render_template('mspr_Afficher_Livreur.html', data=data)
        else:
            return 'Erreur de connexion à la base de données'
        
    # Rendre le template HTML et transmettre les données
    return render_template('mspr_Chercher_Livreur.html', data=data)


@app.route('/mspr_Ajouter_Livreur', methods=['GET', 'POST'])
def d_mspr_Ajouter_Livreur():
    if request.method == 'POST':
        # Récupérer les données du formulaire
        nom = request.form['nom']
        prenom = request.form['prenom']
        telephone = request.form['telephone']

        # Insérer les données dans la table 'Livreurs'
        conn = sqlite3.connect('weeat.db')
        cursor = conn.cursor()
        if conn is not None:
            cursor.execute('INSERT INTO Livreurs (Nom, Prenom, Telephone) VALUES (?, ?, ?)', (nom, prenom, telephone))
            conn.commit()
            conn.close()
            return redirect('/mspr_Consulter_Livreur')
            # return redirect(url_for('Afficher_Livreur'))
            # Rendre le template HTML et transmettre les données
            # return render_template('mspr_Afficher_Livreur.html', data=data)
        else:
            return 'Erreur de connexion à la base de données'

        # Rediriger vers la page de consultation des clients après l'ajout
        # return redirect('/mspr_Consulter_Livreur')

    # Si la méthode est GET, simplement rendre le template du formulaire
    return render_template('mspr_Ajouter_Livreur.html')


@app.route("/mspr_Consulter_Produit", methods=['GET'])
def Afficher_Produit():
    conn = sqlite3.connect('weeat.db')
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM Produits;')
    data = cursor.fetchall()
    conn.close()
    
    # Rendre le template HTML et transmettre les données
    return render_template('mspr_Afficher_Produit.html', data=data)


@app.route('/mspr_Chercher_Produit', methods=['GET', 'POST'])
def d_Chercher_Produit():
    data = []  # Define data as an empty list
    if request.method == 'POST':
        # Récupérer les données du formulaire
        nom = request.form['nom']

        # ici, je suppose que tu as une table 'Produits'
        conn = sqlite3.connect('weeat.db')
        cursor = conn.cursor()
        if conn is not None:
            cursor.execute('SELECT * FROM Produits WHERE nom LIKE ?', ('%' + nom + '%',))
            data = cursor.fetchall()
            conn.close()
            # Rendre le template HTML et transmettre les données
            return render_template('mspr_Afficher_Produit.html', data=data)
        else:
            return 'Erreur de connexion à la base de données'
        
    # Rendre le template HTML et transmettre les données
    return render_template('mspr_Chercher_Produit.html', data=data)


@app.route('/mspr_Ajouter_Produit', methods=['GET', 'POST'])
def d_mspr_Ajouter_Produit():
    if request.method == 'POST':
        # Récupérer les données du formulaire
        nom = request.form['nom']
        description = request.form['description']
        prix = request.form['prix']
        stock = request.form['stock']

        # Insérer les données dans la table 'Produits'
        conn = sqlite3.connect('weeat.db')
        cursor = conn.cursor()
        if conn is not None:
            cursor.execute('INSERT INTO Produits (Nom, Description, Prix, Stock) VALUES (?, ?, ?, ?)', (nom, description, prix, stock))
            conn.commit()
            conn.close()
            return redirect('/mspr_Consulter_Produit')
            # return redirect(url_for('Afficher_Produit'))
            # Rendre le template HTML et transmettre les données
            # return render_template('mspr_Afficher_Produit.html', data=data)
        else:
            return 'Erreur de connexion à la base de données'

        # Rediriger vers la page de consultation des clients après l'ajout
        # return redirect('/mspr_Consulter_Produit')

    # Si la méthode est GET, simplement rendre le template du formulaire
    return render_template('mspr_Ajouter_Produit.html')


if __name__ == "__main__":
  app.run(debug=True)
