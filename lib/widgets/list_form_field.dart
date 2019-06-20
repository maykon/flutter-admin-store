import 'package:admin_store/widgets/add_list_item_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListFormField extends FormField<List> {
  ListFormField(
      {BuildContext context,
      List initialValue,
      FormFieldSetter<List> onSaved,
      FormFieldValidator<List> validator,
      Function(dynamic) onSelectedItem,
      Function(String) onValidateItem})
      : super(
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 34,
                    child: GridView(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.3,
                      ),
                      children: state.value.map((s) {
                        return GestureDetector(
                          onLongPress: () {
                            state.didChange(state.value..remove(s));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                  color: Colors.pinkAccent, width: 3),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "$s",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }).toList()
                        ..add(GestureDetector(
                          onTap: () async {
                            String item = await showDialog(
                              context: context,
                              builder: (context) => AddListItemDialog(
                                  onValidateItem: onValidateItem),
                            );
                            var selected = onSelectedItem != null
                                ? onSelectedItem(item)
                                : item;
                            if (item != null) {
                              state.didChange(state.value..add(selected));
                              state.validate();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                color: state.hasError
                                    ? Colors.red
                                    : Colors.pinkAccent,
                                width: 3,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        )),
                    ),
                  ),
                  state.hasError
                      ? Text(
                          state.errorText,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        )
                      : Container(),
                ],
              );
            });
}
