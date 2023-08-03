import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/model/task.dart';
import 'package:todo/database/my_database.dart';
import 'package:todo/my_date_utils.dart';
import 'package:todo/providers/auth_provider.dart';
import 'package:todo/ui/components/custom_form_feild.dart';
import 'package:todo/ui/dialog_utils.dart';

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
                      ?.copyWith(fontSize: 15, color: Color(0xffA9A9A9))),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Color(0xff5D9CEC)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void addTask() async {
    if (formKey.currentState?.validate() == false) {
      return;
    }
    //show loading
    DialogUtils.showLoadingDialog(context, 'Loading...');
    //add task to db
    Task task = Task(
      title: titleController.text,
      desc: descriptionController.text,
      dateTime: MyDateUtils.dateOnly(selectedDate),
    );
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    await MyDataBase.addTask(authProvider.currentUser?.id ?? "", task);
    DialogUtils.hideDialog(context);
    Navigator.pop(context);
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
