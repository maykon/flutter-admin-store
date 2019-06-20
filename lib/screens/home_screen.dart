import 'package:admin_store/blocs/orders_bloc.dart';
import 'package:admin_store/blocs/user_bloc.dart';
import 'package:admin_store/screens/login_screen.dart';
import 'package:admin_store/tabs/orders_tab.dart';
import 'package:admin_store/tabs/products_tab.dart';
import 'package:admin_store/tabs/users_tab.dart';
import 'package:admin_store/widgets/edit_category_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _page = 0;

  UserBloc _userBloc;
  OrdersBloc _ordersBloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _userBloc = UserBloc();
    _ordersBloc = OrdersBloc();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.pinkAccent,
          primaryColor: Colors.white,
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.white54),
              ),
        ),
        child: BottomNavigationBar(
          currentIndex: _page,
          onTap: (page) {
            _pageController.animateToPage(
              page,
              duration: Duration(seconds: 1),
              curve: Curves.elasticOut,
            );
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text("Clientes"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text("Pedidos"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text("Produtos"),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: BlocProvider(
          blocs: [
            Bloc((i) => _userBloc),
            Bloc((i) => _ordersBloc),
          ],
          child: PageView(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                _page = page;
              });
            },
            children: <Widget>[
              UsersTab(),
              OrdersTab(),
              ProductsTab(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  Widget _buildFloating() {
    switch (_page) {
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.pinkAccent,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
              child: Icon(
                Icons.arrow_downward,
                color: Colors.pinkAccent,
              ),
              backgroundColor: Colors.white,
              label: "Concluídos Abaixo",
              labelStyle: TextStyle(fontSize: 14),
              onTap: () {
                _ordersBloc.setOrderCriteria(SortCriteria.READ_LAST);
              },
            ),
            SpeedDialChild(
              child: Icon(
                Icons.arrow_upward,
                color: Colors.pinkAccent,
              ),
              backgroundColor: Colors.white,
              label: "Concluídos Acima",
              labelStyle: TextStyle(fontSize: 14),
              onTap: () {
                _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);
              },
            ),
          ],
        );
        break;
      case 2:
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.pinkAccent,
          onPressed: () {
            showDialog(
                context: context, builder: (context) => EditCategoryDialog());
          },
        );
        break;
      default:
        return FloatingActionButton(
          child: Icon(Icons.redo),
          backgroundColor: Colors.pinkAccent,
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        );
        ;
    }
  }
}
