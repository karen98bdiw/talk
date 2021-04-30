import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talk/models/service_response.dart';
import 'package:talk/utils/service_constats.dart';
import '../models/user.dart' as customUser;

class UserServices {
  final FirebaseAuth auth;
  final FirebaseFirestore store;

  customUser.User curentUser;

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

        if (storeResponse.errorText != null)
          return ServiceResponse(
              done: false, errorText: storeResponse.errorText);

        var signingResponse = await setCurentUser(userId: res.user.uid);

        if (signingResponse.errorText != null)
          return ServiceResponse(
              done: false, errorText: signingResponse.errorText);

        print(curentUser.toJson());
        return ServiceResponse(done: true);
      }
    } catch (e) {
      return ServiceResponse(done: false, errorText: e.toString());
    }
  }

  Future<ServiceResponse> toogleUserState(
      {bool isUserOnline, String userId}) async {
    try {
      await store
          .collection(usersCollection)
          .doc(userId)
          .collection(userStatement)
          .doc("0")
          .set({isOnline: isUserOnline});
      return ServiceResponse(
        done: true,
      );
    } catch (e) {
      return ServiceResponse(done: false);
    }
  }

  ServiceResponse userStateStream({String userId}) {
    return ServiceResponse(
      done: true,
      data: store
          .collection(usersCollection)
          .doc(userId)
          .collection(userStatement)
          .doc("0")
          .snapshots(),
    );
  }

  Future<ServiceResponse> setCurentUser({userId}) async {
    try {
      var res = await getUserById(userId: userId);
      if (res.errorText != null)
        return ServiceResponse(done: false, errorText: res.errorText);
      curentUser = res.data;
      return ServiceResponse(done: true);
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
      await toogleUserState(
        userId: userId,
        isUserOnline: true,
      );
      return ServiceResponse(done: true);
    } catch (e) {
      return ServiceResponse(done: false, errorText: e.toString());
    }
  }

  Future<ServiceResponse> signIn({String email, String password}) async {
    try {
      var res = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (res.user == null)
        return ServiceResponse(errorText: userNotExist, done: true);

      var userResponse = await getUserById(userId: res.user.uid);

      curentUser = userResponse.data;

      if (userResponse.errorText == null) {
        return ServiceResponse(done: true, data: userResponse.data);
      }

      return ServiceResponse(done: true, errorText: userResponse.errorText);
    } catch (e) {
      return ServiceResponse(
        errorText: e.toString(),
        done: false,
      );
    }
  }

  Future<bool> logOut() async {
    print("logout was called");
    try {
      await toogleUserState(
        isUserOnline: false,
        userId: curentUser.id,
      );
      await FirebaseAuth.instance.signOut();

      return true;
    } catch (e) {
      print("logout error${e.toString()}");
      return true;
    }
  }

  Future<ServiceResponse> getUserById({String userId}) async {
    try {
      var res = await store.collection(usersCollection).doc(userId).get();
      if (res.exists) {
        await toogleUserState(isUserOnline: true, userId: userId);
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

  Future<ServiceResponse> getAllUsers() async {
    try {
      List<customUser.User> users = [];

      var res = await store.collection(usersCollection).get();
      res.docs.forEach((element) {
        users.add(customUser.User.fromJson(element));
      });

      users.removeWhere((element) => element.id == curentUser.id);

      return ServiceResponse(data: users, done: true);
    } catch (e) {
      return ServiceResponse(data: false, errorText: appServiceError);
    }
  }
}
