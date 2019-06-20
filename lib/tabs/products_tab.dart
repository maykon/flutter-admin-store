import 'package:admin_store/widgets/category_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductsTab extends StatefulWidget {
  @override
  _ProductsTabState createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("products").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
            ),
          );
        } else if (snapshot.data.documents.length == 0) {
          return Center(
            child: Text(
              "Nenhum pedido encontrado",
              style: TextStyle(color: Colors.pinkAccent),
            ),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return CategoryTile(category: snapshot.data.documents[index]);
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
