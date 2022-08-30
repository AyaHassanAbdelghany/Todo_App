import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/state.dart';

class ArchivedTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (contex, state) {
        var tasks = AppCubit
            .getInstance(context)
            .archivedTasks;
        return  tasksBuilder(tasks: tasks);
      },
      listener: (context, state) {},
    );
  }
}
