import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseGlobal {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final CollectionReference users =
      FirebaseFirestore.instance.collection('utenti');
  static final CollectionReference wordBooks =
      FirebaseFirestore.instance.collection('rubriche');
  static final CollectionReference dailyWords =
      FirebaseFirestore.instance.collection('parola_del_giorno');
  static const String wordBook = 'rubrica';
  static const String words = 'parole';
}
