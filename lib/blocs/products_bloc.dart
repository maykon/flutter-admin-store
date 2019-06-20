import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class ProductsBloc extends BlocBase {
  final _productCtrl = BehaviorSubject<Map>();
  final _loadingCtrl = BehaviorSubject<bool>();
  final _createdCtrl = BehaviorSubject<bool>();

  Stream<Map> get outProducts => _productCtrl.stream;
  Stream<bool> get outLoading => _loadingCtrl.stream;
  Stream<bool> get outCreated => _createdCtrl.stream;

  String categoryId;
  DocumentSnapshot product;
  Map<String, dynamic> unSavedProduct;

  ProductsBloc({this.categoryId, this.product}) {
    if (product != null) {
      unSavedProduct = Map.of(product.data);
      unSavedProduct["images"] = List.of(product.data["images"]);
      unSavedProduct["options"] = List.of(product.data["options"]);
      unSavedProduct["prices"] = List.of(product.data["prices"]);
      _createdCtrl.add(true);
    } else {
      unSavedProduct = {
        "title": null,
        "description": null,
        "images": [],
        "options": [],
        "prices": [],
        "price": null,
        "optionTitle": null,
      };
      _createdCtrl.add(false);
    }

    _productCtrl.add(unSavedProduct);
  }

  void saveTitle(String title) {
    unSavedProduct["title"] = title;
  }

  void saveDescription(String description) {
    unSavedProduct["description"] = description;
  }

  void savePrice(String price) {
    unSavedProduct["price"] = double.parse(price);
  }

  void saveOptionTitle(String optionTitle) {
    unSavedProduct["optionTitle"] = optionTitle;
  }

  void saveImages(List images) {
    unSavedProduct["images"] = images;
  }

  void saveOptions(List options) {
    unSavedProduct["options"] = options;
  }

  void savePrices(List prices) {
    print(prices);
    unSavedProduct["prices"] = prices;
  }

  Future<bool> saveProduct() async {
    try {
      _loadingCtrl.add(true);
      try {
        if (product != null) {
          await _uploadImage(product.documentID);
          await product.reference.updateData(unSavedProduct);
        } else {
          DocumentReference doc = await Firestore.instance
              .collection("products")
              .document(categoryId)
              .collection("items")
              .add(Map.from(unSavedProduct)..remove("images")..remove("image"));
          await _uploadImage(doc.documentID);
          await doc.updateData(unSavedProduct);
        }
        _createdCtrl.add(true);
        return true;
      } catch (e) {
        return false;
      }
    } finally {
      _loadingCtrl.add(false);
    }
  }

  Future _uploadImage(String productId) async {
    for (int i = 0; i < unSavedProduct["images"].length; i++) {
      if (unSavedProduct["images"][i] is String) continue;

      StorageUploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(categoryId)
          .child(productId)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(unSavedProduct["images"][i]);

      StorageTaskSnapshot s = await uploadTask.onComplete;
      String downloadUrl = await s.ref.getDownloadURL();
      unSavedProduct["images"][i] = downloadUrl;
    }
  }

  void deleteProduct() {
    product.reference.delete();
  }

  @override
  void dispose() {
    _loadingCtrl.close();
    _productCtrl.close();
    _createdCtrl.close();
    super.dispose();
  }
}
