import 'dart:async';

import 'package:firebase_poc/models/User.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'flutter-firebase-poc',
    options: const FirebaseOptions(
      googleAppID: '', // Ok
      gcmSenderID: '', // Project number :
      apiKey: '', // Ok
      projectID: '', // Ok
    ),
  );
  final Firestore firestore = Firestore(app: app);

  runApp(
    MaterialApp(
      title: 'Firestore Example',
      home: MyHomePage(
        firestore: firestore,
      ),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  final Firestore firestore;

  MyHomePage({Key key, this.firestore}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _synchronizedUsers = 0;
  int _specificUsers = 0;

  CollectionReference usersCollection;
  @override
  void initState() {
    this.usersCollection = widget.firestore.collection('users');
    super.initState();
  }

  void _addGenericUser() async {
    // Créer un nouvel utilisateur
    User newUser = User(
        id: 'azerty',
        name: 'Rémy',
        email: 'contact@email.com',
        phoneNumber: '06060606',
        role: 'admin');
    // L'ajouter à la base de données
    DocumentReference addedUser =
        await this.usersCollection.add(newUser.toJson());

    setState(() {});
  }

  void _retrieveAllUsers() async {
    // On récupère tous les utilisateurs
    QuerySnapshot allUsers = await this.usersCollection.getDocuments();

    setState(() {
      // Onmet à jour le nombre d'utilisateurs
      this._synchronizedUsers = allUsers.documents.length;
    });
  }

  void _getRandomUser() async {
    // Modifier le code pour ajouter un utilisateur unique dans la base de données
    User newUser = User(
        id: 'azerty',
        name: 'Rémy',
        email: 'contact@email.com',
        phoneNumber: '06060606',
        role: 'moderateur');
    // L'ajouter à la base de données
    DocumentReference addedUser =
        await this.usersCollection.add(newUser.toJson());
    // Lancer une requête pour récupérer seulement les rôles modérateurs
    QuerySnapshot allModerateurs = await this
        .usersCollection
        .where('role', isEqualTo: 'moderateur')
        .getDocuments();

    setState(() {
      this._specificUsers = allModerateurs.documents.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Afficher le nombre d\'utilisateur dans la base de données',
            ),
            Text(
              '$_synchronizedUsers',
              style: Theme.of(context).textTheme.headline4,
            ),
            RaisedButton(
              onPressed: () {
                this._retrieveAllUsers();
              },
              child: Text('Récupérer les utilisateurs'),
            ),
            RaisedButton(
              onPressed: () {
                this._getRandomUser();
              },
              child: Text('Récupérer nombre de modérateurs'),
            ),
            Text(
              '$_specificUsers',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGenericUser,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
