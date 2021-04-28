import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talk/models/service_response.dart';
import 'package:talk/utils/service_constats.dart';
import '../models/user.dart' as customUser;

class UserServices {
  final FirebaseAuth auth;
  final FirebaseFirestore store;

  UserServices({this.auth, this.store});

  Future<ServiceResponse> createUser({
    customUser.User user,
    String password,
  }) async {
    try {
      var res = await auth.createUserWithEmailAndPassword(
          email: user.email, password: password);
      if (res.user == null) {
        return ServiceResponse(done: false, errorText: appServiceError);
      } else {
        var storeResponse = await storeUser(
          userId: res.user.uid,
          user: user,
        );
        if (storeResponse.done) {
          return ServiceResponse(done: true);
        }
        return ServiceResponse(done: false, errorText: storeResponse.errorText);
      }
    } catch (e) {
      return ServiceResponse(done: false, errorText: e.toString());
    }
  }

  Future<ServiceResponse> storeUser({
    String userId,
    customUser.User user,
  }) async {
    try {
      user.id = userId;
      await store.collection(usersCollection).doc(userId).set(user.toJson());
      return ServiceResponse(done: true);
    } catch (e) {
      return ServiceResponse(done: false, errorText: e.toString());
    }
  }

  Future<ServiceResponse> getUserById({String userId}) async {
    try {
      var res = await store.collection(usersCollection).doc(userId).get();
      if (res.exists) {
        return ServiceResponse(
          done: true,
          data: customUser.User.fromJson(res.data()),
        );
      }
      return ServiceResponse(
        done: false,
        errorText: userNotExist,
      );
    } catch (e) {
      return ServiceResponse(
        done: false,
        errorText: e.toString(),
      );
    }
  }
}
