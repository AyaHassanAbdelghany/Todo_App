import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required IconData prefix,
  required FormFieldValidator functionValidator,
  bool isPassword = false,
  IconData? sufix,
  VoidCallback? sufixOnPressed,
  GestureTapCallback? onTap,

}) {
  return TextFormField(
    obscureText: isPassword,
    controller: controller,
    keyboardType: type,
    onTap: onTap,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        prefix,
      ),
      suffixIcon: sufix != null ? IconButton(
          onPressed: sufixOnPressed,
          icon: Icon(sufix)) : null,
      border: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.black12
          )
      ),
      labelStyle: TextStyle(
        color: Colors.black,
      ),
    ),
    validator: functionValidator,
  );
}

Widget buildTaskItem(Map task, BuildContext context) =>
    Dismissible(
        key: Key(task['id'].toString()),
        child: Padding(
          padding: const EdgeInsets.all(10.0), child: Row
          (
          children: [
            CircleAvatar
              (
              radius: 40.0
              ,
              child: Text
                ('${task['time']}',
                style: TextStyle
                  (
                  color: Colors.white, fontSize: 16.0
                  ,
                )
                ,
              )
              ,
              backgroundColor: Colors.lightBlue,)
            ,
            SizedBox
              (
              width: 20.0
              ,
            )
            ,
            Expanded
              (
              child: Column
                (
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment
                    .start,
                children: [
                  Text
                    ('${task['title']}'
                    ,
                    style: TextStyle
                      (
                      fontSize: 20.0
                      ,
                      fontWeight: FontWeight.bold,)
                    ,
                  )
                  ,
                  Text
                    ('${task['date']}'
                    ,
                    style: TextStyle
                      (
                      fontSize: 16.0
                      ,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox
              (
              width: 20.0
              ,
            )
            ,
            IconButton
              (
                onPressed: (){
                  AppCubit.getInstance(context).updateDataInDB(status: 'done', id: task['id']);
                }
                , icon: Icon
              (
              Icons.check_box, color: Colors.green,)
            )
            ,
            IconButton
              (
                onPressed: (){
                  AppCubit.getInstance(context).updateDataInDB(status: 'archive', id: task['id']);

                }
                , icon: Icon
              (
              Icons.archive, color: Colors.black54,
            )
            ),

          ],
        ),
        ),
      onDismissed: (direction){
        AppCubit.getInstance(context).deleteDataFromDB(id:task['id']);
      },

);

Widget tasksBuilder({required List<Map> tasks}){
  return ConditionalBuilder(
    condition: tasks.length >0 ,
    builder: (context) =>ListView.separated(
      itemBuilder: (context,index) =>buildTaskItem(tasks[index],context),
      separatorBuilder: (context,index) =>Padding(
        padding: const EdgeInsetsDirectional.only(start: 10.0),
        child: Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey,
        ),
      ),
      itemCount: tasks.length,
    ),
    fallback:(context) => Center(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              color: Colors.grey,
              size: 50.0,
            ),
            Text(
              'No Tasks, Please add some tasks',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    ) ,
  ) ;
}

