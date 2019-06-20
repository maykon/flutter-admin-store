import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:admin_store/blocs/user_bloc.dart';

class OrderHeader extends StatelessWidget {
  final DocumentSnapshot order;

  const OrderHeader({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontWeight = TextStyle(fontWeight: FontWeight.w500);
    final _usersBloc = BlocProvider.getBloc<UserBloc>();
    final _user = _usersBloc.getUser(order.data["clientId"]);

    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_user["name"]),
              Text(_user["address"]),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
                "Produtos: R\$ ${order.data["productsPrice"].toStringAsFixed(2)}",
                style: fontWeight),
            Text("Total: R\$ ${order.data["totalPrice"].toStringAsFixed(2)}",
                style: fontWeight),
          ],
        ),
      ],
    );
  }
}
