import 'package:admin_store/blocs/login_bloc.dart';
import 'package:admin_store/screens/home_screen.dart';
import 'package:admin_store/widgets/input_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();
    _loginBloc.outState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
          break;
        case LoginState.FAIL:
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Erro"),
                  content: Text("Você não possui os privilégios necessários."),
                ),
          );
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: StreamBuilder<LoginState>(
          initialData: LoginState.LOADING,
          stream: _loginBloc.outState,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case LoginState.LOADING:
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                  ),
                );
                break;

              case LoginState.FAIL:
              case LoginState.IDLE:
              case LoginState.SUCCESS:
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(),
                    SingleChildScrollView(
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.store_mall_directory,
                              color: Colors.pinkAccent,
                              size: 160,
                            ),
                            InputField(
                              hint: "Username",
                              icon: Icons.person_outline,
                              stream: _loginBloc.outEmail,
                              onChanged: _loginBloc.changeEmail,
                            ),
                            InputField(
                              hint: "Password",
                              icon: Icons.lock_outline,
                              obscure: true,
                              stream: _loginBloc.outPassword,
                              onChanged: _loginBloc.changePassword,
                            ),
                            SizedBox(height: 32),
                            StreamBuilder<bool>(
                              initialData: false,
                              stream: _loginBloc.outSubmitValid,
                              builder: (context, snapshot) {
                                return SizedBox(
                                  height: 50,
                                  child: RaisedButton(
                                    onPressed: snapshot.hasData
                                        ? _loginBloc.submit
                                        : null,
                                    color: Colors.pinkAccent,
                                    child: Text("Entrar"),
                                    textColor: Colors.white,
                                    disabledColor: Colors.pink[200],
                                    disabledTextColor: Colors.white30,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
                break;
            }
          }),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}
