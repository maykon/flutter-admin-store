import 'dart:async';

import 'package:admin_store/validators/login_validators.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum LoginState { IDLE, LOADING, SUCCESS, FAIL }

class LoginBloc extends BlocBase with LoginValidators {
  final _emailCtrl = BehaviorSubject<String>();
  final _passwordCtrl = BehaviorSubject<String>();
  final _stateCtrl = BehaviorSubject<LoginState>();

  Stream<String> get outEmail => _emailCtrl.stream.transform(validateEmail);
  Stream<String> get outPassword =>
      _passwordCtrl.stream.transform(validatePassword);
  Stream<LoginState> get outState => _stateCtrl.stream;

  Stream<bool> get outSubmitValid => Observable.combineLatest2(
        outEmail,
        outPassword,
        (a, b) => true,
      );

  Function(String) get changeEmail => _emailCtrl.sink.add;
  Function(String) get changePassword => _passwordCtrl.sink.add;

  StreamSubscription _subscription;

  LoginBloc() {
    _subscription =
        FirebaseAuth.instance.onAuthStateChanged.listen((user) async {
      if (user != null) {
        if (await verifyPrivileges(user)) {
          _stateCtrl.add(LoginState.SUCCESS);
        } else {
          FirebaseAuth.instance.signOut();
          _stateCtrl.add(LoginState.FAIL);
        }
      } else {
        _stateCtrl.add(LoginState.IDLE);
      }
    });
  }

  void submit() {
    final email = _emailCtrl.value;
    final password = _passwordCtrl.value;

    _stateCtrl.add(LoginState.LOADING);
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .catchError((e) {
      _stateCtrl.add(LoginState.FAIL);
    });
  }

  Future<bool> verifyPrivileges(FirebaseUser user) async {
    return await Firestore.instance
        .collection("admins")
        .document(user.uid)
        .get()
        .then((doc) => doc.data != null)
        .catchError((e) => false);
  }

  @override
  void dispose() {
    _subscription.cancel();
    _stateCtrl.close();
    _passwordCtrl.close();
    _emailCtrl.close();

    super.dispose();
  }
}
