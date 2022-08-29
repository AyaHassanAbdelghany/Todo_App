import 'package:flutter/material.dart';

Widget defultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required IconData prefix,
  required FormFieldValidator functionValidator,
  bool isPassword = false,
  IconData? sufix ,
  VoidCallback? sufixOnPressed ,
  GestureTapCallback? onTap,

}){
  return  TextFormField(
    obscureText: isPassword,
    controller: controller,
    keyboardType: type,
    onTap: onTap,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        prefix,
      ),
      suffixIcon: sufix!=null ? IconButton(
          onPressed: sufixOnPressed ,
          icon :Icon(sufix)) : null,
      border:  OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.black12
          )
      ),
      labelStyle:  TextStyle(
        color: Colors.black,
      ),
    ),
    validator: functionValidator,
  );
}

Widget defultTaskItem(Map task){
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40.0,
          child: Text(
            '${task['time']}',
            style: TextStyle(
              color: Colors.white,
                fontSize:16.0,

            ),
          ),
          backgroundColor: Colors.indigoAccent,
        ),
        SizedBox(
          width: 20.0,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${task['title']}',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${task['date']}',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}