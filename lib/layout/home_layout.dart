import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/tasks/task_model.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

import '../shared/cubit/state.dart';

class HomeLayout extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (contex)=>AppCubit()..createDB(),
      child: BlocConsumer<AppCubit , AppStates>(
      listener: (context,state)
      {
        if(state is AppInsertDatabaseState) Navigator.pop(context);

      },
        builder: (context,state) {
        AppCubit cubit = AppCubit.getInstance(context);
        return  Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
          ),
          body: cubit.screens[cubit.currentIndex],
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottomSheetShow) {
                if (formKey.currentState!.validate()) {
                  cubit.changeBottomSheetShow(isShow: false, icon:Icons.edit );
                  cubit.insertIntoDB(
                      taskModel:TaskModel(
                          titleController.text.toString(),
                          dateController.text.toString(),
                          timeController.text.toString()
                      )
                  );
                }
              }
              else {
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
                                functionValidator: (value) {
                                  if (value.isEmpty) {
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
                              functionValidator: (value) {
                                if (value.isEmpty) {
                                  return ('time must not be empty');
                                }
                                return null;
                              },
                              onTap: () {
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
                              functionValidator: (value) {
                                if (value.isEmpty) {
                                  return ('date must not be empty');
                                }
                                return null;
                              },
                              onTap: () {
                                showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2022-12-30'))
                                    .then((value) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value!);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  elevation: 20.0,
                ).closed.then((value) {
                  cubit.changeBottomSheetShow(isShow: false, icon:Icons.edit );
                });
                cubit.changeBottomSheetShow(isShow: true, icon:Icons.add );
              }
            },
            child: Icon(
              cubit.fabIcon,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
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
            onTap: (index) {
              cubit.changeIndex(index);
            },
          ),
        );
        },
      ),
    );
  }
}



