import 'package:admin_store/blocs/user_bloc.dart';
import 'package:admin_store/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.getBloc<UserBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Pesquisar",
              hintStyle: TextStyle(color: Colors.white),
              icon: Icon(Icons.search, color: Colors.white),
              border: InputBorder.none,
            ),
            onChanged: _userBloc.onChangedSearch,
          ),
        ),
        Expanded(
          child: StreamBuilder<List>(
              stream: _userBloc.outUsers,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                    ),
                  );
                } else if (snapshot.data.length == 0) {
                  return Center(
                    child: Text(
                      "Nenhum usuário encontrado.",
                      style: TextStyle(color: Colors.pinkAccent),
                    ),
                  );
                }

                return ListView.separated(
                  itemBuilder: (context, index) {
                    return UserTile(user: snapshot.data[index]);
                  },
                  itemCount: snapshot.data.length,
                  separatorBuilder: (context, index) {
                    return Divider(color: Colors.white24);
                  },
                );
              }),
        ),
      ],
    );
  }
}
