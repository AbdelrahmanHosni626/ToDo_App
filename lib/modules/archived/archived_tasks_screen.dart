import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/cubit/states.dart';

import '../../layout/cubit/cubit.dart';
import '../../shared/components/components.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: ConditionalBuilder(
            condition: TodoCubit.get(context).archivedTasks.isNotEmpty,
            builder: (BuildContext context) => ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
                  buildTaskItem(TodoCubit.get(context).archivedTasks[index], context),
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                ),
                child: Divider(),
              ),
              itemCount: TodoCubit.get(context).archivedTasks.length,
            ),
            fallback: (BuildContext context) => itemFallBack(),
          ),
        );
      },
    );
  }
}
