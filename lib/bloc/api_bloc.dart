import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_event.dart';
import 'api_state.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  ApiBloc() : super(ApiInitial()) {
    on<FetchDataEvent>(_onFetchData);
    on<CreateDataEvent>(_onCreateData);
    on<EditDataEvent>(_onEditData);
    on<DeleteDataEvent>(_onDeleteData);
  }

  final String apiUrl =
      'https://674869495801f5153590c2a3.mockapi.io/api/v1/pokemon';

  // Fetch data event handler
  Future<void> _onFetchData(
      FetchDataEvent event, Emitter<ApiState> emit) async {
    emit(ApiLoading());
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        emit(ApiLoaded(data));
      } else {
        emit(ApiError("Failed to load data"));
      }
    } catch (e) {
      emit(ApiError(e.toString()));
    }
  }

  // Create data event handler
  Future<void> _onCreateData(
      CreateDataEvent event, Emitter<ApiState> emit) async {
    emit(ApiLoading());
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode({'name': event.name}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201) {
        add(FetchDataEvent()); // Refresh the data
      } else {
        emit(ApiError("Failed to create data"));
      }
    } catch (e) {
      emit(ApiError(e.toString()));
    }
  }

  // Edit data event handler
  Future<void> _onEditData(EditDataEvent event, Emitter<ApiState> emit) async {
    emit(ApiLoading());
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${event.id}'),
        body: json.encode({'name': event.name}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        add(FetchDataEvent()); // Refresh the data
      } else {
        emit(ApiError("Failed to edit data"));
      }
    } catch (e) {
      emit(ApiError(e.toString()));
    }
  }

  // Delete data event handler
  Future<void> _onDeleteData(
      DeleteDataEvent event, Emitter<ApiState> emit) async {
    emit(ApiLoading());
    try {
      final response = await http.delete(Uri.parse('$apiUrl/${event.id}'));
      if (response.statusCode == 200) {
        add(FetchDataEvent()); // Refresh the data
      } else {
        emit(ApiError("Failed to delete data"));
      }
    } catch (e) {
      emit(ApiError(e.toString()));
    }
  }
}
