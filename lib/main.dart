import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build (BuildContext context) {
    return MaterialApp (
      title: 'Encrypted Shared Preferences Demo',
      theme: ThemeData (
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage (title: 'Encrypted Shared Preferences Demo',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final EncryptedSharedPreferences encryptedSharedPreferences =
  EncryptedSharedPreferences ();
  final _formKey = GlobalKey<FormState> ();
  final myController = TextEditingController ();
  String value = '';

  @override
  void initState () {
    super.initState ();
    init ();
  }

  init () async {
    encryptedSharedPreferences.getString ('sample').then ( (String value) {
      setState ( () {
        value = value;
        debugPrint('value->$value');
        myController.text = value;
      });
    });
  }

  @override
  void dispose () {
    myController.dispose ();
    super.dispose ();
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold (
      appBar: AppBar (
        title: const Text ('Encrypted Shared Preferences Demo Page'),
      ),
      body: Form (
          key: _formKey,
          child: Padding (
            padding: const EdgeInsets.all (8.0),
            child: Column (
              children: <Widget> [
                TextFormField (
                    decoration:
                    const InputDecoration (hintText: 'Type text here and save'),
                    controller: myController,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    }),
                Text ('Current value: $value')
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton (
        onPressed: () {
          if (_formKey.currentState!.validate ()) {
            encryptedSharedPreferences
                .setString ('sample', myController.text)
                .then ( (bool success) {
              if (success) {
                debugPrint('save success');
                encryptedSharedPreferences
                    .getString ('sample')
                    .then ( (String value) {
                  setState ( () {
                    value = value;
                  });
                });
              } else {
                debugPrint('save fail');
              }
            });
          }
        },
        tooltip: 'Save',
        child: const Icon (Icons.save),
      ),
    );
  }
}
