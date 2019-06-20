import 'package:admin_store/blocs/products_bloc.dart';
import 'package:admin_store/validators/product_validator.dart';
import 'package:admin_store/widgets/images_widget.dart';
import 'package:admin_store/widgets/list_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot product;

  ProductScreen({Key key, @required this.categoryId, this.product})
      : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState(categoryId, product);
}

class _ProductScreenState extends State<ProductScreen> with ProductValidators {
  final ProductsBloc _productBloc;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _ProductScreenState(String categoryId, DocumentSnapshot product)
      : _productBloc = ProductsBloc(categoryId: categoryId, product: product);

  InputDecoration _buildDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey),
    );
  }

  void _saveProduct() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Salvando produto...",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        duration: Duration(minutes: 1),
        backgroundColor: Colors.pinkAccent,
      ));

      bool success = await _productBloc.saveProduct();
      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          success ? "Produto salvo!" : "Erro ao salvar o produto",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.pinkAccent,
      ));
    }
  }

  void _deleteProduct() {
    _productBloc.deleteProduct();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final fieldStyle = TextStyle(color: Colors.white, fontSize: 16);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: StreamBuilder<Object>(
            initialData: false,
            stream: _productBloc.outCreated,
            builder: (context, snapshot) {
              return Text(snapshot.data ? "Editando produto" : "Criar Produto");
            }),
        elevation: 0,
        actions: <Widget>[
          StreamBuilder<bool>(
              initialData: false,
              stream: _productBloc.outCreated,
              builder: (context, snapshot) {
                if (snapshot.data) {
                  return StreamBuilder<Object>(
                      initialData: false,
                      stream: _productBloc.outLoading,
                      builder: (context, snapshot) {
                        return IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: snapshot.data ? null : _deleteProduct,
                        );
                      });
                } else {
                  return Container();
                }
              }),
          StreamBuilder<bool>(
              stream: _productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(Icons.save),
                  onPressed: snapshot.data ? null : _saveProduct,
                );
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
                stream: _productBloc.outProducts,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();

                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: <Widget>[
                      Text(
                        "Imagens",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      ImagesWidget(
                        context: context,
                        initialValue: snapshot.data["images"],
                        onSaved: _productBloc.saveImages,
                        validator: validateImages,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["title"],
                        style: fieldStyle,
                        decoration: _buildDecoration("Título"),
                        onSaved: _productBloc.saveTitle,
                        validator: validateTitle,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["description"],
                        style: fieldStyle,
                        maxLines: 6,
                        decoration: _buildDecoration("Descrição"),
                        onSaved: _productBloc.saveDescription,
                        validator: validateDescription,
                      ),
                      TextFormField(
                        initialValue:
                            snapshot.data["price"]?.toStringAsFixed(2),
                        style: fieldStyle,
                        decoration: _buildDecoration("Preço"),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onSaved: _productBloc.savePrice,
                        validator: validatePrice,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        initialValue: snapshot.data["optionTitle"],
                        style: fieldStyle,
                        decoration: _buildDecoration("Título das Opções"),
                        onSaved: _productBloc.saveOptionTitle,
                        validator: validateOptionTitle,
                      ),
                      ListFormField(
                        context: context,
                        initialValue: snapshot.data["options"],
                        onSaved: _productBloc.saveOptions,
                        validator: validateOptions,
                        onValidateItem: validateOptionsItem,
                      ),
                      ListFormField(
                        context: context,
                        initialValue: snapshot.data["prices"],
                        onSaved: _productBloc.savePrices,
                        validator: validatePrices,
                        onSelectedItem: (item) => double.parse(item),
                        onValidateItem: validatePrice,
                      ),
                    ],
                  );
                }),
          ),
          StreamBuilder<bool>(
              stream: _productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: !snapshot.data,
                  child: Container(
                    color: snapshot.data ? Colors.black54 : Colors.transparent,
                  ),
                );
              }),
        ],
      ),
    );
  }
}
