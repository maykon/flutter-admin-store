import 'package:flutter/material.dart';

class AddListItemDialog extends StatefulWidget {
  final Function(String) onValidateItem;

  const AddListItemDialog({Key key, this.onValidateItem}) : super(key: key);

  @override
  _AddListItemDialogState createState() =>
      _AddListItemDialogState(onValidateItem: onValidateItem);
}

class _AddListItemDialogState extends State<AddListItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final Function(String) onValidateItem;

  bool valid = false;
  String errorText = "";

  _AddListItemDialogState({this.onValidateItem});

  void onChanged(String text) {
    setState(() {
      errorText = onValidateItem(text);
      valid = errorText == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Form(
        key: _formKey,
        child: Container(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _controller,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    errorText: valid ?? false ? "" : errorText,
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    child: Text("Add"),
                    textColor: Colors.pinkAccent,
                    onPressed: valid ?? false
                        ? () {
                            Navigator.of(context).pop(_controller.text);
                          }
                        : null,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
