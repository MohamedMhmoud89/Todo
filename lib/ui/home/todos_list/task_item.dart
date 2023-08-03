import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/model/task.dart';
import 'package:todo/database/my_database.dart';
import 'package:todo/providers/auth_provider.dart';
import 'package:todo/ui/dialog_utils.dart';
import 'package:todo/ui/edit_task/edit_task.dart';

class TaskItem extends StatefulWidget {
  Task task;

  TaskItem(this.task);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Container(
      margin: EdgeInsets.all(10),
      child: Slidable(
        startActionPane:
            ActionPane(extentRatio: .40, motion: DrawerMotion(), children: [
          widget.task.isDone ?? false
              ? SlidableAction(
                  onPressed: (buildContext) {
                    deleteTask();
                  },
                  backgroundColor: Color(0xffEC4B4B),
                  icon: Icons.delete,
                  label: 'Delete',
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      topLeft: Radius.circular(15)),
                )
              : SlidableAction(
                  onPressed: (buildContext) {
                    deleteTask();
                  },
                  backgroundColor: Color(0xffEC4B4B),
                  icon: Icons.delete,
                  label: 'Delete',
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      topLeft: Radius.circular(15)),
                ),
          SlidableAction(
            onPressed: (buildContext) {
              Navigator.pushNamed(context, EditTask.routeName,
                  arguments: widget.task);
            },
            backgroundColor: Color(0xff5D9CEC),
            icon: Icons.edit,
            label: 'Edit',
          ),
        ]),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: widget.task.isDone ?? false
                      ? Color(0xff61E757)
                      : Color(0xff5D9CEC),
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 70,
                width: 7,
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.task.title}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: widget.task.isDone ?? false
                            ? Color(0xff61E757)
                            : Color(0xff5D9CEC)),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text('${widget.task.desc}')
                ],
              )),
              SizedBox(
                width: 15,
              ),
              widget.task.isDone ?? false
                  ? Text(
                      'Done!',
                      style: TextStyle(
                          fontSize: 22,
                          color: Color(0xff61E757),
                          fontWeight: FontWeight.bold),
                    )
                  : InkWell(
                      onTap: () {
                        widget.task.isDone = true;
                        authProvider.EditTask(widget.task);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 21.6, vertical: 7.4),
                        decoration: BoxDecoration(
                            color: widget.task.isDone ?? false
                                ? Color(0xff61E757)
                                : Color(0xff5D9CEC),
                            borderRadius: BorderRadius.circular(10)),
                        height: 34,
                        width: 69,
                        child: Image.asset('assets/images/Icon_check.png'),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  void deleteTask() {
    DialogUtils.showMessage(context, 'Do you want delete this task',
        postActionName: 'Yes', postAction: () {
      deleteTaskFromDB();
    }, negActionName: 'No');
  }

  void deleteTaskFromDB() async {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await MyDataBase.deleteTask(
          authProvider.currentUser?.id ?? '', widget.task.id ?? '');
      Fluttertoast.showToast(
          msg: "Task Deleted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xff5D9CEC),
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      DialogUtils.showMessage(context, 'Something went wrong ${e.toString()}');
    }
  }
}
