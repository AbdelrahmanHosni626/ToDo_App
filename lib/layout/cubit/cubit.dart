import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layout/cubit/states.dart';

import '../../modules/archived/archived_tasks_screen.dart';
import '../../modules/done/done_tasks_screen.dart';
import '../../modules/new/new_tasks_screen.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(TodoIntialState());

  static TodoCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  late Database database;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('Database Created');

        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('Table Created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('Database Opened');
      },
    ).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  insertToDataBase({
    required String title,
    required String date,
    required String time,
  }) async {
    return await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks (title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
            
        print('$value Inserted Successfully');
        
        
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });
    }).then((value) {
      emit(InsertIntoDatabaseState());

      getDataFromDatabase(database);
    });
  }

  void getDataFromDatabase(database) {

    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(GetDataLoadingFromDatabaseState());

    database.rawQuery('SELECT * FROM tasks').then((value) {

      value.forEach((element) {
        if(element['status'] == 'new') {
          newTasks.add(element);
        } else if(element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      },);

      emit(GetDataFromDatabaseState());
    });
  }


  updateDatabase({
    required String status,
    required int id,
})
  {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id]).then((value) {
          getDataFromDatabase(database);
          emit(UpdateDatabaseState());
    });
  }


  deleteDatabase({
    required int id,
  })
  {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(DeleteDataFromDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheet({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;

    emit(ChangeBottomSheetState());
  }
}
