import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/datas/cart_product.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;

  bool isLoading = false;

  List<CartProduct> prodcuts = [];

  CartModel(this.user) {
    if (user.isLoggedIn()) _loadCartItems();
  }

  static CartModel of(BuildContext context) => ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    prodcuts.add(cartProduct);
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.cid = doc.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .delete();

    prodcuts.remove(cartProduct);

    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;

    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity++;

    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void _loadCartItems() async {
    QuerySnapshot query =
        await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").getDocuments();

    prodcuts = query.documents.map((e) => CartProduct.fromDocument(e)).toList();

    notifyListeners();
  }
}
