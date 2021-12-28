import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final _collectionReference =
      _firestore.collection('Users').doc('UsersInfo').collection('Profile');
  static final _documentReference = _collectionReference.doc('ProfileInfo');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
        TextButton(onPressed: () => addData(), child: Text('Add Data')),
        TextButton(onPressed: () => readData(), child: Text('Read Data')),
        TextButton(onPressed: () => updateData(), child: Text('Update Data')),
        TextButton(onPressed: () => deleteData(), child: Text('Delete Data')),
      ])), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  addData() async {
    Map<String, dynamic> demoData = {
      'Name': "Sarah",
      'Email': 'chummysarah@gmail.com'
    };
    _documentReference
        .set(demoData)
        .whenComplete(
            () => Fluttertoast.showToast(msg: "User Added Successfully"))
        .onError((error, stackTrace) =>
            Fluttertoast.showToast(msg: error.toString()));
  }

  readData() async {
    var documentSnapshot = await _collectionReference.doc("ProfileInfo").get();
    if (documentSnapshot.exists) {
      Map<String, dynamic>? data = documentSnapshot.data();

      Fluttertoast.showToast(msg: data?['Name']);
    }
  }

  updateData() async {
    Map<String, dynamic> demoData = {
      'Name': "Sarah Rollins",
    };
    _documentReference
        .update(demoData)
        .whenComplete(
            () => Fluttertoast.showToast(msg: "User Updated Successfully"))
        .onError((error, stackTrace) =>
            Fluttertoast.showToast(msg: error.toString()));
  }

  deleteData() async {
    _documentReference
        .delete()
        .whenComplete(
            () => Fluttertoast.showToast(msg: "User Updated Successfully"))
        .onError((error, stackTrace) =>
            Fluttertoast.showToast(msg: error.toString()));
  }
}
