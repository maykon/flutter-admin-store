import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

enum SortCriteria { READY_FIRST, READ_LAST }

class OrdersBloc extends BlocBase {
  final _ordersCtrl = BehaviorSubject<List>();
  final _firestore = Firestore.instance;
  List<DocumentSnapshot> _orders = [];

  Stream<List> get outOrders => _ordersCtrl.stream;

  SortCriteria _criteria;

  OrdersBloc() {
    _criteria = SortCriteria.READY_FIRST;
    _addOrdersListener();
  }

  void _addOrdersListener() {
    _firestore.collection("orders").snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String oid = change.document.documentID;
        switch (change.type) {
          case DocumentChangeType.added:
            _orders.add(change.document);
            break;
          case DocumentChangeType.modified:
            _orders.removeWhere((order) => order.documentID == oid);
            _orders.add(change.document);
            break;
          case DocumentChangeType.removed:
            _orders.removeWhere((order) => order.documentID == oid);
            break;
        }
      });
      _sort();
    });
  }

  void setOrderCriteria(SortCriteria criteria) {
    _criteria = criteria;
    _sort();
  }

  void _sort() {
    switch (_criteria) {
      case SortCriteria.READY_FIRST:
        _orders.sort((a, b) {
          int sa = a.data["status"];
          int sb = b.data["status"];
          if (sa < sb)
            return 1;
          else if (sa > sb)
            return -1;
          else
            return 0;
        });
        break;
      case SortCriteria.READ_LAST:
        _orders.sort((a, b) {
          int sa = a.data["status"];
          int sb = b.data["status"];
          if (sa > sb)
            return 1;
          else if (sa < sb)
            return -1;
          else
            return 0;
        });
        break;
    }
    _ordersCtrl.add(_orders);
  }

  @override
  void dispose() {
    _ordersCtrl.close();
    super.dispose();
  }
}
