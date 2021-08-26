import 'package:app/bloc/item/event.dart';
import 'package:app/bloc/item/state.dart';
import 'package:app/model/product.dart';
import 'package:app/repository/product_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ProductRepository repository;

  ItemBloc({@required this.repository}) : assert(repository != null);

  @override
  ItemState get initialState => ItemEmpty();

  @override
  Stream<ItemState> mapEventToState(ItemEvent event) async* {
    if (event is CreateItem) {
      yield ItemCreating(Product());
    } else if (event is SaveItem) {
      yield ItemSaving();
      try {
        await repository.addNew(event.product);
        yield ItemSaved();
      } catch (e) {
        yield ItemSavingError(e);
      }
    }
  }
}
