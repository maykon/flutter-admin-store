import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase {
  final _usersCtrl = BehaviorSubject<List>();
  Map<String, Map<String, dynamic>> _users = {};

  Firestore _firestore = Firestore.instance;

  Stream<List> get outUsers => _usersCtrl.stream;

  UserBloc() {
    _addUsersListener();
  }

  void _addUsersListener() {
    _firestore.collection("users").snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String uid = change.document.documentID;
        switch (change.type) {
          case DocumentChangeType.added:
            _users[uid] = change.document.data;
            _subscribeToOrders(uid);
            break;
          case DocumentChangeType.modified:
            _users[uid].addAll(change.document.data);
            _usersCtrl.add(_users.values.toList());
            break;
          case DocumentChangeType.removed:
            _unsubscribeToOrders(uid);
            _users.remove(uid);
            _usersCtrl.add(_users.values.toList());
            break;
        }
      });
    });
  }

  void _subscribeToOrders(String uid) {
    _users[uid]["subscription"] = _firestore
        .collection("users")
        .document(uid)
        .collection("orders")
        .snapshots()
        .listen((orders) async {
      int numOrders = orders.documents.length;
      double money = 0.0;
      for (var doc in orders.documents) {
        var order = await _firestore
            .collection("orders")
            .document(doc.documentID)
            .get();
        if (order.data == null) continue;

        money += order.data["totalPrice"];
      }
      _users[uid].addAll({"money": money, "orders": numOrders});
      _usersCtrl.add(_users.values.toList());
    });
  }

  void onChangedSearch(String search) {
    search = search.trim();
    if (search.isEmpty) {
      _usersCtrl.add(_users.values.toList());
    } else {
      _usersCtrl.add(_filter(search));
    }
  }

  List<Map<String, dynamic>> _filter(String search) {
    List<Map<String, dynamic>> filteredUsers =
        List.from(_users.values.toList());
    filteredUsers.retainWhere(
        (user) => user["name"].toUpperCase().contains(search.toUpperCase()));
    return filteredUsers;
  }

  void _unsubscribeToOrders(String uid) {
    _users[uid]["subscription"].cancel();
  }

  Map<String, dynamic> getUser(String uid) {
    return _users[uid];
  }

  @override
  void dispose() {
    _usersCtrl.close();
    super.dispose();
  }
}
