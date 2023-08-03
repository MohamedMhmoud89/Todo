import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/database/model/task.dart';
import 'package:todo/database/my_database.dart';
import 'package:todo/my_date_utils.dart';
import 'package:todo/providers/auth_provider.dart';
import 'package:todo/ui/home/todos_list/task_item.dart';

class TodosListTab extends StatefulWidget {
  @override
  State<TodosListTab> createState() => _TodosListTabState();
}

class _TodosListTabState extends State<TodosListTab> {
  //List<Task>tasksList = [];
  DateTime selectedDate = DateTime.now();
  DateTime foucasedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    //  if(tasksList.isEmpty)
    //  readTasksFromDB();
    return Container(
      child: Column(
        children: [
          TableCalendar(
            focusedDay: foucasedDate,
            firstDay: DateTime.now().subtract(Duration(days: 365)),
            lastDay: DateTime.now().add(Duration(days: 365)),
            calendarFormat: CalendarFormat.week,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDate = selectedDay;
                this.foucasedDate =
                    focusedDay; // update `_focusedDay` here as well
              });
            },
            calendarStyle: CalendarStyle(),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot<Task>>(
                  stream: MyDataBase.getTasksRealTimeUpdate(
                      authProvider.currentUser?.id ?? "",
                      MyDateUtils.dateOnly(selectedDate)
                          .millisecondsSinceEpoch),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: Color(0xff5D9CEC),
                      ));
                    }
                    var tasksList =
                        snapshot.data?.docs.map((doc) => doc.data()).toList();
                    if (tasksList?.isEmpty == true) {
                      return Center(
                          child: Text("You don't have any tasks yet"));
                    }
                    return ListView.builder(
                      itemBuilder: (_, index) {
                        return TaskItem(tasksList![index]);
                      },
                      itemCount: tasksList?.length ?? 0,
                    );
                  }))
        ],
      ),
    );
  }

//readTasksFromDB() async {
// var authProvider = Provider.of<AuthProvider>(context, listen: false);
// var res = await MyDataBase.getTasks(authProvider.currentUser?.id ?? '');
// //tasksList = res.docs.map((docSnapshot) => docSnapshot.data()).toList();
// setState(() {});
}
//tasksList.isEmpty ? Center(child: CircularProgressIndicator(color: Color(0xff5D9CEC),)):
// ListView.builder(itemBuilder: (buildContext,index){
// return TaskItem(tasksList[index]);
// },itemCount: tasksList.length,)
