import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:task_app/model/task.dart';

import 'widget/new_task.dart';
import 'widget/task_list.dart';
import 'widget/task_section.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Task> _task = [];

  void _addNewTask(String taskTitle, DateTime taskDate, IconData taskIcon) {
    var newTask = Task(
      id: DateTime.now().toString(),
      icon: taskIcon,
      title: taskTitle,
      date: taskDate,
    );
    setState(() {
      _task.add(newTask);
    });
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return NewTask(
          addNewTask: _addNewTask,
        );
      },
    );
  }

  void _deleteTask(String id) {
    setState(() {
      _task.removeWhere((element) {
        return element.id == id;
      });
    });
  }

  var _showTaskBox = false;

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLandscape)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Show Task List',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Switch(
                        value: _showTaskBox,
                        onChanged: (val) {
                          setState(() {
                            _showTaskBox = val;
                          });
                        },
                      ),
                      const Text(
                        'Show Task Box',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                if (!isLandscape)
                  SizedBox(
                    height: (MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top) *
                        0.3,
                    child: TaskSection(
                      tasks: _task,
                    ),
                  ),
                if (!isLandscape)
                  const Text(
                    'Pending',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                if (!isLandscape)
                  SizedBox(
                    height: (MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top) *
                        0.5,
                    width: double.infinity,
                    child: TaskList(
                      task: _task,
                      deleteTask: _deleteTask,
                    ),
                  ),
                if (isLandscape)
                  _showTaskBox
                      ? SizedBox(
                          height: (MediaQuery.of(context).size.height -
                                  MediaQuery.of(context).padding.top) *
                              0.66,
                          child: TaskSection(
                            tasks: _task,
                          ),
                        )
                      : SizedBox(
                          height: (MediaQuery.of(context).size.height -
                                  MediaQuery.of(context).padding.top) *
                              0.5,
                          width: double.infinity,
                          child: TaskList(
                            task: _task,
                            deleteTask: _deleteTask,
                          ),
                        ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 197, 196, 196),
        child: const Icon(Icons.add),
        onPressed: () {
          _showBottomSheet(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
