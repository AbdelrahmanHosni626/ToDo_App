import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/layout/cubit/cubit.dart';
import 'package:todo_app/layout/cubit/states.dart';
import 'package:todo_app/shared/components/components.dart';

class ToDoLayoutScreen extends StatelessWidget {
  ToDoLayoutScreen({Key? key}) : super(key: key);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: const Text('Todo'),
            ),
            body: ConditionalBuilder(
              condition: true,
              builder: (context) => TodoCubit.get(context)
                  .bottomScreens[TodoCubit.get(context).currentIndex],
              fallback: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (TodoCubit.get(context).isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    TodoCubit.get(context)
                        .insertToDataBase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text,
                    )
                        .then((value) {
                      Navigator.pop(context);
                      TodoCubit.get(context).changeBottomSheet(
                        isShow: false,
                        icon: Icons.edit,
                      );
                    });
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                    controller: titleController,
                                    type: TextInputType.text,
                                    prefix: Icons.text_fields_outlined,
                                    label: 'Task Title',
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'Title must not be empty';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    prefix: Icons.access_time_outlined,
                                    label: 'Task Time',
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'Time must not be empty';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context);
                                        print(value.format(context));
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    prefix: Icons.date_range_outlined,
                                    label: 'Task Date',
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'Date must not be empty';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2030-12-30'),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                        print(DateFormat.yMMMd().format(value));
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    TodoCubit.get(context).changeBottomSheet(
                      isShow: false,
                      icon: Icons.edit,
                    );
                  });
                  TodoCubit.get(context).changeBottomSheet(
                    isShow: true,
                    icon: Icons.add,
                  );
                }
              },
              child: Icon(
                TodoCubit.get(context).fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: (int index) {
                TodoCubit.get(context).changeBottomNavBar(index);
              },
              currentIndex: TodoCubit.get(context).currentIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'New',
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
            ),
          ),
        );
      },
    );
  }
}
