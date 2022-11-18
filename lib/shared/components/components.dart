import 'package:flutter/material.dart';
import 'package:todo_app/layout/cubit/cubit.dart';

Widget defaultFormField({
  required TextEditingController controller,
  FormFieldValidator<String>? validate,
  required TextInputType type,
  bool isPassword = false,
  bool isClickable = true,
  VoidCallback? onTap,
  ValueChanged<String>? onChange,
  ValueChanged<String>? onSubmit,
  String? label,
  required IconData prefix,
  IconData? suffix,
  VoidCallback? suffixPressed,
}) =>
    TextFormField(
      controller: controller,
      validator: validate,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onTap: onTap,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () {
                  suffixPressed!();
                },
                icon: Icon(suffix),
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(
        model['id'].toString(),
      ),
      onDismissed: (direction)
      {
        TodoCubit.get(context).deleteDatabase(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                '${model['time']}',
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            IconButton(
              onPressed: () {
                TodoCubit.get(context)
                    .updateDatabase(status: 'done', id: model['id']);
              },
              icon: const Icon(
                Icons.check_box_outlined,
              ),
              color: Colors.green,
            ),
            IconButton(
              onPressed: () {
                TodoCubit.get(context)
                    .updateDatabase(status: 'archived', id: model['id']);
              },
              icon: const Icon(
                Icons.archive,
              ),
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );


Widget itemFallBack() => Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 250,
        height: 250,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage(
              'assets/images/jarjeer.jpg',
            ),
          ),
        ),
      ),
      const Text('ملقتش داتا جبتلك جرجير', style: TextStyle(
        fontSize: 30.0,
      ),),
    ],
  ),
);