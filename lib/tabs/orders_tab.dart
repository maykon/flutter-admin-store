import 'package:admin_store/blocs/orders_bloc.dart';
import 'package:admin_store/widgets/order_tile.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _ordersBloc = BlocProvider.getBloc<OrdersBloc>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: StreamBuilder<List>(
          stream: _ordersBloc.outOrders,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                ),
              );
            } else if (snapshot.data.length == 0) {
              return Center(
                child: Text(
                  "Nenhum pedido encontrado",
                  style: TextStyle(color: Colors.pinkAccent),
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return OrderTile(order: snapshot.data[index]);
              },
            );
          }),
    );
  }
}
