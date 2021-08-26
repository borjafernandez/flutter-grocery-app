import 'package:app/model/product.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ListState extends Equatable {
  const ListState();

  @override
  List<Object> get props => [];
}

class ListEmpty extends ListState {}

class ListLoading extends ListState {}

class DeletingItem extends ListState {}

class ItemDeletionError extends ListState {}

class ItemDeleted extends ListState {}

class ItemSaved extends ListState {}

class ListLoaded extends ListState {
  final Stream<List<Product>> itemListStream;

  const ListLoaded({@required this.itemListStream})
      : assert(itemListStream != null);

  @override
  List<Object> get props => [itemListStream];
}

class ListErrorState extends ListState {
  final Exception e;
  ListErrorState({@required this.e}) : assert(e != null);
}

class ListLoadingError extends ListErrorState {
  ListLoadingError(Exception e) : super(e: e);
}

class ItemDeletingError extends ListErrorState {
  ItemDeletingError(Exception e) : super(e: e);
}
