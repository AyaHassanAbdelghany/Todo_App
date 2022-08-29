import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/tasks/task_model.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/constants/constants.dart';

class HomeLayout extends StatefulWidget {

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  List<Widget> screens =[
    NewTasksScreen(),
    DoneTasksScreen(),
   ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New Task',
    'Done Task',
    'Archived Task',
  ];
  Database? db ;
  var scaffoldKey =  GlobalKey<ScaffoldState>();
  var formKey =  GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;

  @override
  void initState() {
    createDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:scaffoldKey,
      appBar: AppBar(
        title: Text(
          titles[currentIndex],
        ),
      ),
      body: ConditionalBuilder(
          condition: tasks.length >0,
          builder: (context) => screens[currentIndex],
          fallback:(context) => Center(child: CircularProgressIndicator()) ,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(isBottomSheetShow) {
            if (formKey.currentState!.validate()) {
              isBottomSheetShow = false;
              Navigator.pop(context);
              setState(() {
                fabIcon = Icons.edit;
              });
              insertIntoDB(taskModel: TaskModel(
                  titleController.text.toString(),
                  dateController.text.toString(),
                  timeController.text.toString()));
            }
          }
          else{
          scaffoldKey.currentState!.showBottomSheet((context) =>
             Container(
               padding: EdgeInsets.all(10.0),
               child: Form(

                 key: formKey,
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                    children: [
                      defultTextFormField(
                          controller: titleController,
                          type: TextInputType.text,
                          label: 'Task Title',
                          prefix: Icons.title,
                          functionValidator: (value){
                            if(value.isEmpty){
                              return ('title must not be empty');
                            }
                            return null;
                          }
                          ),
                      SizedBox(
                        height: 10.0,
                      ),
                      defultTextFormField(
                          controller: timeController,
                          type: TextInputType.datetime,
                          label: 'Task Time',
                          prefix: Icons.watch_later_outlined,
                          functionValidator: (value){
                            if(value.isEmpty){
                              return('time must not be empty');
                            }
                            return null;
                          },
                        onTap: ()
                        {
                            showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now()
                            ).then((value) {
                              timeController.text = value!.format(context);
                            });
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      defultTextFormField(
                        controller: dateController,
                        type: TextInputType.datetime,
                        label: 'Task Date',
                        prefix: Icons.calendar_today,
                        functionValidator: (value){
                          if(value.isEmpty){
                            return('date must not be empty');
                          }
                          return null;
                        },
                        onTap: ()
                        {
                         showDatePicker(
                             context: context,
                             initialDate: DateTime.now(),
                             firstDate: DateTime.now(),
                             lastDate: DateTime.parse('2022-12-30'))
                             .then((value) {
                               dateController.text = DateFormat.yMMMd().format(value!);
                         });
                        },
                      ),
                    ],
                 ),
               ),
             ),
            elevation: 20.0,
          ).closed.then((value){
            isBottomSheetShow = false;
            setState(() {
              fabIcon = Icons.edit;
            });
          });
          isBottomSheetShow = true;
          setState((){
            fabIcon = Icons.add;
          });
          }
        },
        child: Icon(
          fabIcon,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_circle_outline,
            ),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.archive_outlined,
            ),
            label: 'Archived',
          ),
        ],
        onTap: (index){
          setState((){
            currentIndex = index;
          });
        },
      ),
    );
  }

  void createDB() async {
   db = await openDatabase(
    'todo.db',
    version: 1,
    onCreate: (database , version)  {
    print('create database');
    database.execute('CREATE  TABLE tasks'
    '(id INTEGER PRIMARY KEY ,time TEXT, status TEXT ,title TEXT, date TEXT)')
        .then((value){
    }).catchError((error){
    print('error when create tables ${error.toString()}');
    });
    },
    onOpen: (database){
     getDataFromDB(database).then((value) {
       tasks = value;
       print(value);
     });
    }
    );
  }

  Future insertIntoDB({
  required TaskModel taskModel
   }) async {
    print("title  ${taskModel.title.toString()}");
    print("date ${taskModel.date.toString()}");
    print("time ${taskModel.time.toString()}");

    return await db!.transaction((txn) {
      txn.rawInsert(' INSERT INTO tasks (title , date, time ,status) '
          'VALUES ("${taskModel.title}","${taskModel.date}","${taskModel.time}","New")')
      .then((value) {
        print('insert is successfuly ${value}');
    }).catchError((error) {
     print('error without insert ${error.toString()}');
    });
    return null;
  });
  }

  Future<List<Map>> getDataFromDB(db) async{
    return await db!.rawQuery('SELECT * FROM tasks');
  }
}

