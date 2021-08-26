import 'package:app/model/product.dart';
import 'package:app/repository/product_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'event.dart';
import 'state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final ProductRepository repository;

  ListBloc({@required this.repository}) : assert(repository != null);

  @override
  ListState get initialState => ListEmpty();

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    if (event is FetchList) {
      yield ListLoading();
      try {
        final Stream<List<Product>> itemListStream = repository.products();
        yield ListLoaded(itemListStream: itemListStream);
      } catch (e) {
        yield ListLoadingError(e);
      }
    } else if (event is DeleteItem) {
      yield DeletingItem();
      try {
        await repository.delete(event.id);
        yield ItemDeleted();
      } catch (e) {
        yield ItemDeletionError();
      }
    }
  }
}
