import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/state.dart';

class NewTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
      builder: (contex,state){
        var tasks  = AppCubit.getInstance(context).newTasks;
        return  ListView.separated(
          itemBuilder: (context,index) =>defultTaskItem(tasks[index],doneOnPressed: ()
          {
            Map task = tasks[index];
            AppCubit.getInstance(context).updateDataInDB(status: 'done', id: task['id']);
          },
            archiveOnPressed: ()
            {
              Map task = tasks[index];
              AppCubit.getInstance(context).updateDataInDB(status: 'archive', id: task['id']);
            }
          ),
          separatorBuilder: (context,index) =>Padding(
            padding: const EdgeInsetsDirectional.only(start: 10.0),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey,
            ),
          ),
          itemCount: tasks.length,
        ) ;
      },
      listener: (context,state){},
    );
  }
}
