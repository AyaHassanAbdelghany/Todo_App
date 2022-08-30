import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/state.dart';

import '../../models/tasks/task_model.dart';
import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New Task',
    'Done Task',
    'Archived Task',
  ];
  Database? db;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;

  AppCubit() : super(AppInitialState());

  static AppCubit getInstance(context) => BlocProvider.of(context);

  void changeIndex(index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void changeBottomSheetShow({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShow = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void createDB() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      database
          .execute('CREATE  TABLE tasks'
              '(id INTEGER PRIMARY KEY ,time TEXT, status TEXT ,title TEXT, date TEXT)')
          .then((value) {})
          .catchError((error) {
        print('error when create tables ${error.toString()}');
      });
    }, onOpen: (database)
    {
      getDataFromDB(database);
    }).then((value) {
      db = value;
      emit(AppCreateDatabaseState());
    });
  }

  void insertIntoDB({required TaskModel taskModel}) async {
    await db!.transaction((txn){
      txn.rawInsert(' INSERT INTO tasks (title , date, time ,status) '
              'VALUES ("${taskModel.title}","${taskModel.date}","${taskModel.time}","new")')
          .then((value)
      {
        emit(AppInsertDatabaseState());
       getDataFromDB(db);
      })
          .catchError((error) {
        print('error without insert ${error.toString()}');
      });
      return null;
    });
  }

  void getDataFromDB(db)  {

    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    return  db!.rawQuery('SELECT * FROM tasks').then((value)
    {
      value.forEach((element){
        if(element['status'] =='new'){
          newTasks.add(element);
        }
        else if(element['status'] =='done'){
          doneTasks.add(element);
        }
        else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateDataInDB({
    required String status,
    required int id,
  }) {
    db!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['${status}', '${id}']).then((value)
    {
      emit(AppUpdateDatabaseState());
      getDataFromDB(db);
    }
    );
  }

  void deleteDataFromDB({required int id}){
    db!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value){
      emit(AppDeleteDatabaseState());
      getDataFromDB(db);
    });
  }
}
