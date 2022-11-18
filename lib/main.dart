import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/cubit/cubit.dart';
import 'package:todo_app/shared/bloc_observer.dart';

import 'layout/todo_layout.dart';

void main() {

  Bloc.observer = MyBlocObserver();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TodoCubit()..createDatabase(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ToDoLayoutScreen(),
      ),
    );
  }
}