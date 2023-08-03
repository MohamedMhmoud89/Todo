import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/model/task.dart';
import 'package:todo/my_date_utils.dart';
import 'package:todo/providers/auth_provider.dart';
import 'package:todo/ui/components/custom_form_feild.dart';
import 'package:todo/ui/home/home_screen.dart';

class EditTask extends StatefulWidget {
  static const String routeName = 'edit';

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController? titleController;
  TextEditingController? descController;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Task task = ModalRoute.of(context)?.settings.arguments as Task;
    if (titleController == null || descController == null) {
      titleController = TextEditingController(text: task.title);
      descController = TextEditingController(text: task.desc);
    }
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              AppBar(
                title: Text('To Do List'),
                flexibleSpace: SizedBox(height: height * 0.25),
              ),
            ],
          ),
          Positioned(
              top: height * 0.15,
              child: Container(
                  width: width * 0.9,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(children: [
                      Text(
                        'Edit Task',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(
                        height: height * 0.1,
                      ),
                      CustomFormField(
                          controller: titleController!,
                          label: 'Title',
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Please enter task title';
                            }
                          }),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      CustomFormField(
                        controller: descController!,
                        label: 'Description',
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please enter task description';
                          }
                        },
                        lines: 5,
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Text('Task Date',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 19)),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      InkWell(
                        onTap: () {
                          showTaskDatePicker();
                        },
                        child: Text(MyDateUtils.formatTaskDate(selectedDate),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                    fontSize: 15, color: Color(0xffA9A9A9))),
                      ),
                      SizedBox(
                        height: height * 0.08,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  task.title = titleController?.text;
                                  task.desc = descController?.text;
                                  task.dateTime =
                                      MyDateUtils.dateOnly(selectedDate);
                                  authProvider.EditTask(task);
                                  Navigator.pop(context, HomeScreen.routeName);
                                  Fluttertoast.showToast(
                                      msg: "Task Edited",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Color(0xff5D9CEC),
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              },
                              child: Text('Save Changes'),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  backgroundColor: Color(0xff5D9CEC)),
                            ),
                            SizedBox(
                              height: height * 0.08,
                            ),
                          ],
                        ),
                      ),
                    ]),
                  )))
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    titleController?.dispose();
    descController?.dispose();
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
