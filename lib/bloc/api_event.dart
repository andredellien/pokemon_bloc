abstract class ApiEvent {}

class FetchDataEvent extends ApiEvent {}

class CreateDataEvent extends ApiEvent {
  final String name;

  CreateDataEvent(this.name);
}

class EditDataEvent extends ApiEvent {
  final String id;
  final String name;

  EditDataEvent(this.id, this.name);
}

class DeleteDataEvent extends ApiEvent {
  final String id;

  DeleteDataEvent(this.id);
}
