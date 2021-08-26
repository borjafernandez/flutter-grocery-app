import 'dart:async';

import 'package:app/model/product.dart';
import 'package:app/repository/product_entity.dart';
import 'package:app/repository/product_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProductRepository implements ProductRepository {
  final collection = Firestore.instance.collection('grocerylist');

  @override
  Future<void> addNew(Product product) {
    return collection.add(product.toEntity().toDocument());
  }

  @override
  Future<void> delete(String id) async {
    return collection.document(id).delete();
  }

  @override
  Stream<List<Product>> products() {
    return collection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Product.fromEntity(ProductEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> update(Product update) {
    return collection
        .document(update.id)
        .updateData(update.toEntity().toDocument());
  }
}
