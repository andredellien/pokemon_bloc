import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/api_bloc.dart';
import '../bloc/api_event.dart';
import '../bloc/api_state.dart';

class ApiScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API CRUD with BLoC')),
      body: BlocProvider(
        create: (_) => ApiBloc()..add(FetchDataEvent()),
        child: BlocBuilder<ApiBloc, ApiState>(
          builder: (context, state) {
            if (state is ApiLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is ApiError) {
              return Center(child: Text(state.message));
            }
            if (state is ApiLoaded) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ApiBloc>()
                          .add(CreateDataEvent(nameController.text));
                      nameController.clear();
                    },
                    child: Text('Create Data'),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.data.length,
                      itemBuilder: (context, index) {
                        final item = state.data[index];
                        return ListTile(
                          title: Text(item['name']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  nameController.text = item['name'];
                                  final apiBloc = context
                                      .read<ApiBloc>(); // Capture the bloc here
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Text('Edit Item'),
                                        content: TextField(
                                          controller: nameController,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              apiBloc.add(
                                                EditDataEvent(item['id'],
                                                    nameController.text),
                                              );
                                              Navigator.pop(dialogContext);
                                            },
                                            child: Text('Save'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  context
                                      .read<ApiBloc>()
                                      .add(DeleteDataEvent(item['id']));
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
