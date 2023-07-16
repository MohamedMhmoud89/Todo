import 'package:flutter/material.dart';
import 'package:todo/ui/home/settings/settings_tab.dart';
import 'package:todo/ui/home/todos_list/add_task_bottom_sheet.dart';
import 'package:todo/ui/home/todos_list/todos_list_tab.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  // bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffDFECDB),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('To Do List'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        shape: StadiumBorder(side: BorderSide(color: Colors.white, width: 4)),
        child: //isChecked? Icon(Icons.check_sharp,size: 35,):Icon(Icons.add,size: 35,),
            Icon(Icons.add, size: 35),
        onPressed: () {
          setState(() {
            // isChecked = !isChecked;
            showAddTaskSheet();
            // if(isChecked==true){}
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            selectedIndex = index;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
                size: 35,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  size: 35,
                ),
                label: "")
          ],
        ),
      ),
      body: tabs[selectedIndex],
    );
  }

  void showAddTaskSheet() {
    showModalBottomSheet(
        context: context,
        builder: (buildContext) {
          return AddTaskBottomSheet();
        });
  }

  var tabs = [TodosListTab(), SettingsTab()];
}
