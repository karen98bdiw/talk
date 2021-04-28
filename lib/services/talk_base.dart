import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talk/services/user_services.dart';

class TalkBase {
  TalkBase._internal();

  static final talkBase = TalkBase._internal();

  factory TalkBase() => talkBase;

  static final FirebaseFirestore _store = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  UserServices userServices = UserServices(
    auth: _auth,
    store: _store,
  );
}
