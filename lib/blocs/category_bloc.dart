import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class CategoryBloc extends BlocBase {
  final _titleCtrl = BehaviorSubject<String>();
  final _imageCtrl = BehaviorSubject();
  final _deleteCtrl = BehaviorSubject<bool>();

  Stream<String> get outTitle => _titleCtrl.stream.transform(
          StreamTransformer<String, String>.fromHandlers(
              handleData: (title, sink) {
        if (title.isEmpty) {
          sink.addError("Informe um título para categoria.");
        } else {
          sink.add(title);
        }
      }));
  Stream get outImage => _imageCtrl.stream;
  Stream<bool> get outDelete => _deleteCtrl.stream;

  Stream<bool> get outSave =>
      Observable.combineLatest2(outTitle, outImage, (a, b) => true);

  DocumentSnapshot category;
  File image;
  String title;

  CategoryBloc(this.category) {
    if (category != null) {
      title = category.data["title"];
      _titleCtrl.add(category.data["title"]);
      _imageCtrl.add(category.data["icon"]);
      _deleteCtrl.add(true);
    } else {
      _deleteCtrl.add(false);
    }
  }

  void setImage(File image) {
    if (image == null) return;
    this.image = image;
    _imageCtrl.add(image);
  }

  void setTitle(String title) {
    this.title = title;
    _titleCtrl.add(title);
  }

  Future saveData() async {
    if (image == null && category != null && title == category.data["title"])
      return;
    Map<String, dynamic> updateData = {};
    if (image != null) {
      StorageUploadTask task =
          FirebaseStorage.instance.ref().child("icons").child(title).put(image);
      StorageTaskSnapshot snap = await task.onComplete;
      updateData["icon"] = await snap.ref.getDownloadURL();
      updateData["title"] = title;

      if (category == null) {
        await Firestore.instance
            .collection("products")
            .document(title.toLowerCase())
            .setData(updateData);
      } else {
        await category.reference.updateData(updateData);
      }
    }
  }

  Future delete() async {
    await category.reference.delete();
  }

  @override
  void dispose() {
    _deleteCtrl.close();
    _imageCtrl.close();
    _titleCtrl.close();
    super.dispose();
  }
}
