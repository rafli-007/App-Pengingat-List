import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pengingat_list/common/constants.dart';
import 'package:get/get.dart';
import 'package:pengingat_list/dataaccess/task.dart';
import 'package:pengingat_list/model/task.dart';
import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart';
import 'package:intl/intl.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage>
    with TickerProviderStateMixin {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController showSelectedDate = TextEditingController();
  final TaskDataAccess dataAccess = TaskDataAccess();

  TabController? tabController;

  List<Task> listTasks = <Task>[].obs;

  String? selectedCategory;
  DateTime? selectedDate;

  formattedDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: categories.length, vsync: this);
    getData(category: categories[0]);
  }

  saveTask() async {
    await dataAccess.insert(
      Task(
        title: titleController.text,
        category: selectedCategory ?? 'Others',
        done: 0,
        taskDate: formattedDate(selectedDate!),
      ),
    );
  }

  getData({String? category}) async {
    List<Task> result;
    if (category == null || category.isEmpty) {
      result = await dataAccess.getAll();
    } else {
      result = await dataAccess.getAllByCategory(category);
    }

    listTasks.clear();
    listTasks.addAll(result);
  }

  deleteTask(int id) async {
    await dataAccess.delete(id);
  }

  updateTask(Task task) async {
    await dataAccess.update(task);
  }

  checked(int done) => done == 0 ? false : true;

  toggleTask(bool checked) => checked ? 1 : 0;

  void _save() {
    saveTask();
    resetForm();
    Navigator.pop(context);
  }

  resetForm() {
    setState(() {
      titleController.clear();
      selectedCategory = null;
      selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    getData(category: categories[tabController!.index]);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: DefaultTabController(
            length: 5,
            child: Column(
              children: <Widget>[
                ButtonsTabBar(
                    backgroundColor: Colors.blue,
                    controller: tabController,
                    unselectedBackgroundColor: Colors.blue[100],
                    unselectedLabelStyle:
                        const TextStyle(color: Colors.black54),
                    radius: 16,
                    contentPadding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                    labelStyle: const TextStyle(color: Colors.white),
                    onTap: (pageNumber) {
                      getData(category: categories[pageNumber]);
                    },
                    tabs: List.generate(categories.length,
                        (index) => Tab(text: categories[index]))),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: tabController,
                    children: List.generate(
                      categories.length,
                      (index) => Obx(() => todoListItem(listTasks)),
                    ),
                  ),
                ),
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          resetForm();
          showTaskForm();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  todoListItem(List<Task> data) {
    return SizedBox(
      height: Size.infinite.height,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          final item = data[index];
          return Column(
            children: [
              const SizedBox(height: 10),
              Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      spacing: 10,
                      onPressed: (context) {
                        showCalendar();
                      },
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.calendar_month,
                      label: 'Date',
                    ),
                    SlidableAction(
                      spacing: 10,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                      onPressed: (context) {
                        setState(() {
                          deleteTask(item.id!);
                        });
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.save,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                      onTap: () {
                        titleController.text = item.title;
                        selectedCategory = item.category;
                        selectedDate = DateTime.tryParse(item.taskDate);
                        showSelectedDate.text = item.taskDate;
                        showTaskDetail(item);
                      },
                      trailing: Checkbox(
                        value: checked(item.done),
                        onChanged: (value) {
                          setState(() {
                            final status = toggleTask(!checked(item.done));
                            updateTask(item..done = status);
                          });
                        },
                      ),
                      title: Text(item.title)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  showTaskDetail(Task item) {
    showSlideDialog(
        context: context,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                categoriesWidget(currentTask: item),
                TextField(
                  controller: titleController,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    setState(() {
                      updateTask(item..title = value);
                    });
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 20),
                  ),
                ),
                ListTile(
                  onTap: () {
                    showCalendar(currentTask: item);
                  },
                  leading: const Icon(Icons.calendar_month),
                  title: const Text(dueDate),
                  trailing: SizedBox(
                    width: 100,
                    child: TextField(
                      enabled: false,
                      controller: showSelectedDate,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  showTaskForm() {
    showModalBottomSheet(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      enableDrag: true,
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
          padding: EdgeInsets.fromLTRB(
              15, 15, 15, MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 56,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16)),
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      hintText: 'Input new task here',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 20)),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  categoriesWidget(),
                  calendar(),
                  IconButton(onPressed: _save, icon: const Icon(Icons.send)),
                ],
              ),
            ],
          )),
    );
  }

  categoriesWidget({Task? currentTask}) => Container(
        height: 35,
        width: 125,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: DropdownButtonFormField(
          items: categories.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCategory = value;
              if (currentTask != null) {
                updateTask(currentTask..category = selectedCategory!);
              }
            });
          },
          menuMaxHeight: 200,
          icon: const Icon(Icons.arrow_drop_down),
          borderRadius: BorderRadius.circular(10),
          value: selectedCategory ?? 'Others',
          decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 10)),
        ),
      );

  showCalendar({Task? currentTask}) {
    showDialog(
      context: context,
      builder: (context) => Column(
        children: [
          DatePickerDialog(
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(DateTime.now().year - 1, DateTime.now().month,
                  DateTime.now().day),
              lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month,
                  DateTime.now().day)),
        ],
      ),
    ).then((date) {
      setState(() {
        if (date != null) {
          if (currentTask != null) {
            showSelectedDate.text = formattedDate(date);
            updateTask(currentTask..taskDate = formattedDate(date));
          }
          selectedDate = date;
        }
      });
    });
  }

  calendar() => IconButton(
        onPressed: showCalendar,
        icon: const Icon(Icons.calendar_month),
      );
}
