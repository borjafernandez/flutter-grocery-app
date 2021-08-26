import 'package:app/repository/product_entity.dart';
import 'package:meta/meta.dart';

@immutable
class Product {
  final String id;
  final String name;

  Product({this.id, this.name});

  Product copyWith({String id, String name}) {
    return Product(id: id, name: name);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && id == other.id && name == other.name;

  @override
  String toString() {
    return 'Product { name: $name, id: $id }';
  }

  ProductEntity toEntity() {
    return ProductEntity(id, name);
  }

  static Product fromEntity(ProductEntity entity) {
    return Product(id: entity.id, name: entity.name);
  }
}
