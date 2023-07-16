import 'package:flutter/material.dart';
import 'package:todo/my_date_utils.dart';
import 'package:todo/ui/components/custom_form_feild.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var titleController = TextEditingController();

  var descriptionController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Text('Add new Task',
                style: Theme.of(context).textTheme.headlineMedium),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    CustomFormField(
                        controller: titleController,
                        label: '      enter your task',
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please enter task title';
                          }
                        }),
                    CustomFormField(
                      controller: descriptionController,
                      label: '      Task description',
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter task description';
                        }
                      },
                      lines: 5,
                    ),
                  ],
                )),
            Text('Task Date',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 19)),
            SizedBox(
              height: 12,
            ),
            InkWell(
              onTap: () {
                showTaskDatePicker();
              },
              child: Text(MyDateUtils.formatTaskDate(selectedDate),
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontSize: 15)),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      addTask();
                    },
                    child: Text('Add Task'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void addTask() {
    if (formKey.currentState?.validate() == false) {
      return;
    }
  }

  var selectedDate = DateTime.now();

  void showTaskDatePicker() async {
    var date = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (date == null) return;
    selectedDate = date;
    setState(() {});
  }
}
