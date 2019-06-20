import 'package:admin_store/widgets/order_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final DocumentSnapshot order;

  const OrderTile({Key key, @required this.order}) : super(key: key);
  final status = const [
    "",
    "Em preparação",
    "Em transporte",
    "Aguardando entrega",
    "Entregue"
  ];

  String _getOrderId() {
    return order.documentID
        .substring(order.documentID.length - 7, order.documentID.length);
  }

  String _titleCase(String text) {
    return text.replaceFirstMapped(
        new RegExp(r"(\w)"), (m) => m[1].toUpperCase());
  }

  Color _getColorStatus() {
    return order["status"] == 4 ? Colors.green : Colors.grey[850];
  }

  void _doRegridir() {
    order.reference.updateData({"status": order.data["status"] - 1});
  }

  void _doAvancar() {
    order.reference.updateData({"status": order.data["status"] + 1});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          key: Key(order.documentID),
          initiallyExpanded: order.data["status"] != 4,
          title: Text(
            "${_getOrderId()} - ${status[order["status"]]}",
            style: TextStyle(color: _getColorStatus()),
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  OrderHeader(order: order),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: order.data["products"].map<Widget>((product) {
                      return ListTile(
                        title: Text("${product["product"]["title"]}"),
                        subtitle: Text(
                            "${_titleCase(product["category"])}/Qtde. x ${product["quantity"]}"),
                        trailing: Text(
                          "R\$ ${product["product"]["price"].toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 20),
                        ),
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Firestore.instance
                              .collection("users")
                              .document(order.data["clientId"])
                              .collection("orders")
                              .document(order.documentID)
                              .delete();
                          order.reference.delete();
                        },
                        textColor: Colors.red,
                        child: Text("Excluir"),
                      ),
                      FlatButton(
                        onPressed:
                            order.data["status"] > 1 ? _doRegridir : null,
                        textColor: Colors.grey[850],
                        child: Text("Regredir"),
                      ),
                      FlatButton(
                        onPressed: order.data["status"] < 4 ? _doAvancar : null,
                        textColor: Colors.green,
                        child: Text("Avançar"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
