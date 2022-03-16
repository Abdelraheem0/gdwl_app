// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, prefer_typing_uninitialized_variables, avoid_returning_null_for_void, non_constant_identifier_names, prefer_is_empty, sized_box_for_whitespace, unnecessary_import, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdwl/models/task_model.dart';
import 'package:gdwl/view/screens/edit_list_screen.dart';
import 'package:gdwl/view/screens/mytasks_screen.dart';
import 'package:intl/intl.dart';
import 'package:gdwl/shared/cubit/cubit.dart';
import 'package:gdwl/shared/cubit/states.dart';
import 'package:gdwl/view/screens/createlist_screen.dart';
import 'package:gdwl/view/widgets/default_textfield.dart';

class LayoutScreen extends StatefulWidget {
  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int currentTab = 0;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  var pageController = PageController();

  int tabIndex = 0;

  Color deleteListTextColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
      AppCubit cubit = AppCubit.get(context);
      if (state is AppInsertTasksToDatabase) {
        cubit.taskNameController.text = '';
        cubit.taskDetailsController.text = '';
        cubit.taskDateController.text = '';
        cubit.taskTimeController.text = '';
//        cubit.getTasksByListId(cubit.lists[currentTab]['id']);
        Navigator.pop(context);
      }
    }, builder: (context, state) {
      AppCubit cubit = AppCubit.get(context);
      List selectedIndex = [currentTab];
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Text(
            'Tasks',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateNewList()));
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                )),
          ],
        ),
        body: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.blue,
                  height: MediaQuery.of(context).size.height / 27,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final isSelected = selectedIndex.contains(index);
                        return InkWell(
                          onTap: () {
                            print(cubit.lists[index]['name']);
                            setState(() {
                              currentTab = index;
                              if (isSelected == false) {
                                selectedIndex.clear();
                                selectedIndex.add(index);
                              }
                            });
                            pageController.animateToPage(currentTab,
                                duration: Duration(microseconds: 400),
                                curve: Curves.fastOutSlowIn);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              children: [
                                Text(
                                  cubit.lists[index]['name'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 9,
                                  height:
                                      MediaQuery.of(context).size.height / 170,
                                  decoration: ShapeDecoration(
                                    shape: StadiumBorder(),
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: cubit.lists.length),
                ),
              ],
            ),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (int index) {
                  final isSelected = selectedIndex.contains(index);
                  setState(() {
                    currentTab = index;
                    if (isSelected == false) {
                      selectedIndex.clear();
                      selectedIndex.add(index);
                    }
                    print('${cubit.lists[index]['name']} >> $index');
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyTasksScreen(listId: cubit.lists[index]['id']),
                  );
                },
                itemCount: cubit.lists.length,
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 32.0,
          child: FloatingActionButton(
            onPressed: () {
              if (cubit.bottomSheetShown) {
                final task = TaskModel(
                  name: cubit.taskNameController.text,
                  details: cubit.taskDetailsController.text,
                  date: cubit.taskDateController.text,
                  time: cubit.taskTimeController.text,
                  status: 'new',
                  listId: cubit.lists[currentTab]['id'],
                );
                cubit.insertTask(task);
              } else {
                scaffoldKey.currentState!
                    .showBottomSheet((context) => Container(
                          color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 40.0, right: 20.0, left: 20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DefaultTextField(
                                    hintText: 'New task',
                                    controller: cubit.taskNameController,
                                    onTap: () {},
                                    prefixIcon: Icons.title,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'please add task name';
                                      }
                                      return null;
                                    },
                                  ),
                                  DefaultTextField(
                                    hintText: 'Details',
                                    controller: cubit.taskDetailsController,
                                    prefixIcon: Icons.dehaze,
                                    onTap: () {},
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      DefaultTextField(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        hintText: 'Date',
                                        controller: cubit.taskDateController,
                                        prefixIcon: Icons.calendar_today,
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2022-03-16'),
                                          ).then((value) {
                                            cubit.taskDateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      DefaultTextField(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        hintText: 'Time',
                                        controller: cubit.taskTimeController,
                                        prefixIcon: Icons.watch_later_outlined,
                                        onTap: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) {
                                            cubit.taskTimeController.text =
                                                value!.format(context);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                    .closed
                    .then((value) {
                  cubit.changeBottomSheetState(false, Icons.edit);
                });
                cubit.changeBottomSheetState(true, Icons.add);
              }
            },
            child: Icon(
              cubit.fabIcon,
              color: Colors.white,
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.blue,
          height: MediaQuery.of(context).size.height / 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                              color: Colors.blue,
                              constraints: BoxConstraints(
                                maxHeight: double.infinity,
                              ),
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    cubit.lists.isNotEmpty
                                        ? Column(
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(
                                                  maxHeight: cubit
                                                              .lists.length <
                                                          5
                                                      ? double.infinity
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          5,
                                                ),
                                                width: double.infinity,
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemBuilder:
                                                      (context, index)
                                                      {
                                                        return Container(
                                                          decoration: BoxDecoration(
                                                            color: currentTab == index
                                                                ? Colors.white24
                                                                : Colors.transparent,
                                                            borderRadius: BorderRadius.circular(50.0),
                                                          ),
                                                          child: ListTile(
                                                          onTap: () {
                                                            pageController
                                                                .animateToPage(
                                                                index,
                                                                duration: Duration(
                                                                    microseconds:
                                                                    400),
                                                                curve: Curves
                                                                    .fastOutSlowIn);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          title: Text(
                                                            cubit.lists[index]
                                                            ['name'],
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 16.0,
                                                            ),
                                                          ),
                                                      ),
                                                        );
                                                        },
                                                  separatorBuilder: (context , index) => SizedBox(height: 5.0,),
                                                  itemCount: cubit.lists.length,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Divider(
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                            ],
                                          )
                                        : SizedBox.shrink(),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CreateNewList()));
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 3.0,
                                          ),
                                          Text(
                                            'Create New List',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                  },
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                              color: Colors.blue,
                              height: MediaQuery.of(context).size.height / 3,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {

                                      },
                                      child: Column(
                                        children: [
                                          Text(
                                            'Sort by',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          Text(
                                            'My order',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Divider(
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditList(
                                              listName: cubit.lists[currentTab]
                                                  ['name'],
                                              listId: cubit.lists[currentTab]
                                                  ['id'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Rename List',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if(cubit.lists[currentTab]['id'] != 1)
                                          {
                                            cubit.deleteList(
                                                cubit.lists[currentTab]['id']);
                                            currentTab--;
                                          }else{
                                          return ;
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Delete list',
                                            style: TextStyle(
                                              color: cubit.lists[currentTab]['id'] == 1
                                                  ? Colors.grey[400]
                                                  : Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          Text(
                                            'Default list can\'t be deleted ',
                                            style: TextStyle(
                                              color: cubit.lists[currentTab]['id'] == 1
                                                  ? Colors.grey[400]
                                                  : Colors.white,
                                              fontSize: 10.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        cubit.deleteAllCompletedTasks();
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Delete all complete tasks',
                                        style: TextStyle(
                                          color: cubit.doneTasks.length == 0
                                              ? Colors.grey[400]
                                              : Colors.white,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                              ),
                            ));
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
      );
    });
  }
}
