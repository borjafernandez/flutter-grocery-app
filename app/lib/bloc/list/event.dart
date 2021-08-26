import 'package:equatable/equatable.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();
}

class FetchList extends ListEvent {
  @override
  List<Object> get props => [];
}

class DeleteItem extends ListEvent {
  final String id;

  DeleteItem(this.id) : assert(id != null);

  @override
  List<Object> get props => [id];
}
