import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;

  ProductEntity(this.id, this.name);

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'ProductEntity {  name: $name, id: $id }';
  }

  static ProductEntity fromJson(Map<String, Object> json) {
    return ProductEntity(json['id'] as String, json['name'] as String);
  }

  static ProductEntity fromSnapshot(DocumentSnapshot snap) {
    return ProductEntity(
      snap.documentID,
      snap.data['name'],
    );
  }

  Map<String, Object> toDocument() {
    return {'name': name};
  }

  @override
  List<Object> get props => [id];
}
