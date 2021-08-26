import 'package:app/model/product.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class ItemEmpty extends ItemState {}

// ignore: must_be_immutable
class ItemCreating extends ItemState {
  Product product;
  ItemCreating(this.product);
  @override
  List<Object> get props => [product];
}

class ItemCreated extends ItemState {}

class ItemSaving extends ItemState {}

class ItemSaved extends ItemState {}

class ItemErrorState extends ItemState {
  final Exception e;
  ItemErrorState({@required this.e}) : assert(e != null);
}

class ItemCreatingError extends ItemErrorState {
  ItemCreatingError(Exception e) : super(e: e);
}

class ItemSavingError extends ItemErrorState {
  ItemSavingError(Exception e) : super(e: e);
}
