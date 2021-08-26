import 'package:app/model/product.dart';
import 'package:equatable/equatable.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();
}

class CreateItem extends ItemEvent {
  CreateItem();

  @override
  List<Object> get props => [];
}

class SaveItem extends ItemEvent {
  final Product product;

  SaveItem(this.product) : assert(product != null);

  @override
  List<Object> get props => [product];
}
