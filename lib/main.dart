import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_block/screens/screen_api.dart';
import 'bloc/api_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter BLoC CRUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => ApiBloc(), // Provide ApiBloc here
        child: ApiScreen(), // Your screen that will use ApiBloc
      ),
    );
  }
}
