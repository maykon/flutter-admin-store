import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserTile extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserTile({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: Colors.white);

    if (user.containsKey("money")) {
      return ListTile(
        title: Text(
          user["name"],
          style: textStyle,
        ),
        subtitle: Text(
          user["email"],
          style: textStyle,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              "Pedidos: ${user["orders"]}",
              style: textStyle,
            ),
            Text(
              "Gasto: R\$ ${user["money"].toStringAsFixed(2)}",
              style: textStyle,
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 200,
                  height: 20,
                  child: Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.grey,
                    child: Container(
                      color: Colors.white.withAlpha(50),
                      margin: EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 20,
                  child: Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.grey,
                    child: Container(
                      color: Colors.white.withAlpha(50),
                      margin: EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 250,
                  height: 20,
                  child: Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.grey,
                    child: Container(
                      color: Colors.white.withAlpha(50),
                      margin: EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 20,
                  child: Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.grey,
                    child: Container(
                      color: Colors.white.withAlpha(50),
                      margin: EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
