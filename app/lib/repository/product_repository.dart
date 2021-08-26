import 'package:app/model/product.dart';

abstract class ProductRepository {
  Future<void> addNew(Product product);

  Future<void> delete(String id);

  Stream<List<Product>> products();

  Future<void> update(Product product);
}
