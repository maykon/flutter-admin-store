import 'dart:io';

import 'package:admin_store/blocs/category_bloc.dart';
import 'package:admin_store/widgets/image_sources_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditCategoryDialog extends StatefulWidget {
  final DocumentSnapshot category;

  EditCategoryDialog({this.category});

  @override
  _EditCategoryDialogState createState() =>
      _EditCategoryDialogState(category: category);
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  final CategoryBloc _categoryBloc;
  final TextEditingController _titleCtrl;

  _EditCategoryDialogState({DocumentSnapshot category})
      : _categoryBloc = CategoryBloc(category),
        _titleCtrl = TextEditingController(
            text: category != null ? category.data["title"] : "");

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => ImageSourcesSheet(
                            onImageSelected: (image) {
                              Navigator.of(context).pop();
                              _categoryBloc.setImage(image);
                            },
                          ));
                },
                child: StreamBuilder(
                    stream: _categoryBloc.outImage,
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: snapshot.data is File
                              ? Image.file(snapshot.data, fit: BoxFit.cover)
                              : Image.network(snapshot.data, fit: BoxFit.cover),
                        );
                      }
                      return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 1)),
                          child: Icon(Icons.image));
                    }),
              ),
              title: StreamBuilder<String>(
                  stream: _categoryBloc.outTitle,
                  builder: (context, snapshot) {
                    return TextField(
                      controller: _titleCtrl,
                      onChanged: _categoryBloc.setTitle,
                      decoration: InputDecoration(
                          errorText: snapshot.hasError ? snapshot.error : null),
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StreamBuilder<bool>(
                    stream: _categoryBloc.outDelete,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Container();
                      return FlatButton(
                        child: Text("Excluir"),
                        textColor: Colors.red,
                        onPressed: snapshot.data
                            ? () async {
                                await _categoryBloc.delete();
                                Navigator.of(context).pop();
                              }
                            : null,
                      );
                    }),
                StreamBuilder<bool>(
                    stream: _categoryBloc.outSave,
                    builder: (context, snapshot) {
                      return FlatButton(
                        onPressed: snapshot.hasData && snapshot.data
                            ? () async {
                                await _categoryBloc.saveData();
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: Text("Salvar"),
                      );
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
