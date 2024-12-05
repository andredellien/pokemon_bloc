abstract class ApiState {}

class ApiInitial extends ApiState {}

class ApiLoading extends ApiState {}

class ApiLoaded extends ApiState {
  final List<dynamic> data;

  ApiLoaded(this.data);
}

class ApiError extends ApiState {
  final String message;

  ApiError(this.message);
}
