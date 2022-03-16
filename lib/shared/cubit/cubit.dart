// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_string_interpolations, avoid_function_literals_in_foreach_calls


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdwl/models/list_model.dart';
import 'package:gdwl/models/subtask_model.dart';
import 'package:gdwl/models/task_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gdwl/shared/constants.dart';
import 'package:gdwl/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

//  List<Widget> screens = [
//    MyTasksScreen(),
////    WorkTasksScreen(),
//  ];
  var taskNameController = TextEditingController();
  var taskDetailsController = TextEditingController();
  var taskDateController = TextEditingController();
  var taskTimeController = TextEditingController();

  var subTaskNameController = TextEditingController();
  var subTaskDetailsController = TextEditingController();
  var subTaskDateController = TextEditingController();
  var subTaskTimeController = TextEditingController();


  bool bottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  bool isExpansionOpen = false;

  void changeBottomSheetState(bool isShow, IconData icon) {
    bottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  int subTasksCounter = 0;

  void increaseSubTasks() {
    subTasksCounter++;
    emit(AppIncreaseSubTasksState());
  }

  void decreaseSubTasks() {
    subTasksCounter--;
    emit(AppDecreaseSubTasksState());
  }

  int currentTabIndex = 1;
  void changeTabControllerIndex(int index){
    currentTabIndex = index;
    print(currentTabIndex);
    emit(ChangeCurrentTabIndexState());
  }



   final dbName = 'gdwl';
   final dbVersion = 1;

   Database? db;
   List lists = [];
   List newTasks = [];
   List doneTasks = [];
   List newSubTasks = [];
   List doneSubTasks = [];

   initDatabase() async {

        final docsPath = await getApplicationDocumentsDirectory();
        final dbPath = join(docsPath.path, dbName);

        openDatabase(dbPath , version: dbVersion ,
          onCreate: (Database database , int version) async {
          print('database created successfully');

            // create lists table
          database.execute(createListTable).then((value){
              print('list table created successfully');
              database.transaction((txn){
                return txn.rawInsert('INSERT INTO $listTable(name) VALUES("My tasks")');
              });
          }).catchError((error){
              print('error while creating list table ${error.toString()}');
          });

          // create tasks table
          database.execute(createTaskTable).then((value){
            print('tasks table created successfully');
          }).catchError((error){
            print('error while creating tasks table ${error.toString()}');
          });

          database.execute(createSubTaskTable).then((value){
            print('subTasks table created successfully');
          }).catchError((error){
            print('error while creating subTasks table ${error.toString()}');
          });

          },onOpen: (db){
            print('database opened');
            getAllLists(db);
            getAllTasks(db);
            getAllSubTasks(db);
          },
        ).then((value){
          db = value;
          emit(CreateDatabaseState());
        }).catchError((error){
          print('error while opening database ${error.toString()}');
        });
  }

   Future<int> insertList (ListModel list) async {
    return await db!.insert(listTable, list.toJson()).then((value){
      print('List inserted successfully');
      getAllLists(db!);
      return value;
    });
  }

   Future<int> insertTask (TaskModel task) async {
    return await db!.insert(tasksTable, task.toJson()).then((value){
      print('Task has inserted successfully');
      getAllTasks(db!);
      emit(AppInsertTasksToDatabase());
      return value;
    });
  }

   Future<int> insertSubTask (SubTaskModel subTask) async {
    return await db!.insert(subTasksTable, subTask.toJson()).then((value){
      print('SubTask has inserted successfully');
      getAllSubTasks(db!);
      emit(AppInsertSubTasksToDatabase());
      return value;
    });
  }

   getAllLists(Database database) async {
     lists = [];
     database.rawQuery('SELECT * FROM $listTable').then((value){
       value.forEach((list) {
         lists.add(list);

         print('Lists: $lists');
         emit(GetListsFromDatabaseState());
       });
     });
  }

   getAllTasks(Database database)  {
     newTasks = [];
     doneTasks = [];

     database.rawQuery('SELECT * FROM $tasksTable').then((value){
       value.forEach((task) {
         if(task['status'] == 'new'){
           newTasks.add(task);
         }else{
           doneTasks.add(task);
         }

         print('New tasks: $newTasks');
         print('Done tasks: $doneTasks');
         emit(GetTasksFromDatabaseState());
       });
     });
  }

  getAllSubTasks(Database database)  {
    newSubTasks = [];
    doneSubTasks = [];

    database.rawQuery('SELECT * FROM $subTasksTable').then((value){
      value.forEach((subTask) {
        if(subTask['status'] == 'new'){
          newSubTasks.add(subTask);
        }else{
          doneSubTasks.add(subTask);
        }

        print('New SubTasks: $newSubTasks');
        print('Done SubTasks: $doneSubTasks');
        emit(AppGetSubTasksFromDatabase());
      });
    });
  }

//   getTasksByListId(int listId)  {
//     newTasks = [];
//     doneTasks = [];
//
//     db!.rawQuery('''
//     SELECT * FROM $tasksTable
//     WHERE list_id = ?
//     ''' , [listId]).then((value){
//       value.forEach((task) {
//
//         if(task['status'] == 'new'){
//           newTasks.add(task);
//         }else{
//           doneTasks.add(task);
//         }
//
//         print('New tasks: $newTasks');
//         print('Done tasks: $doneTasks');
//         emit(GetTasksByListIdFromDatabaseState());
//       });
//     });
//    }

//  Future<List<TaskModel>> getAllTasks() async {
//     var allRows = await db!.query(tasksTable);
//     List<TaskModel> tasks =
//         allRows.map((task) => TaskModel.fromMap(task)).toList();
//     return tasks;
//  }

//  Future<int> deleteList (ListModel list) async {
//
//     return await db!.delete(listTable , where: 'id = ?' , whereArgs: [list.id]).then((value){
//       print('List deleted successfully');
//       getAllLists(db!);
//       emit(DeleteListFromDatabaseState());
//       return value;
//     });
//
//  }

//  Future<int> deleteTask (TaskModel task) async {
//
//     return await db!.delete(tasksTable , where: 'id = ?' , whereArgs: [task.id]).then((value){
//       print('Task deleted successfully');
//       getAllTasks(db!);
//       emit(DeleteTaskFromDatabaseState());
//       return value;
//     });
//
//  }

  void deleteList(int id){
    db!.rawDelete(
      'DELETE FROM $listTable WHERE id = ?',
      [id],
    ).then((value){
      getAllLists(db!);
      emit(DeleteListFromDatabaseState());
    });
  }

  void deleteTask(int id){
    db!.rawDelete(
      'DELETE FROM $tasksTable WHERE id = ?',
      [id],
    ).then((value){
      getAllTasks(db!);
      emit(DeleteTaskFromDatabaseState());
    });
  }

  void deleteSubTask(int id){
    db!.rawDelete(
      'DELETE FROM $subTasksTable WHERE id = ?',
      [id],
    ).then((value){
      getAllSubTasks(db!);
      emit(AppDeleteSubTasksDatabase());
    });
  }

    void deleteAllCompletedTasks(){
      db!.rawDelete(
        'DELETE FROM $tasksTable WHERE status = ?',
        ['done']
      ).then((value){
        getAllTasks(db!);
        emit(DeleteAllCompletedTaskFromDatabaseState());
      });
    }

//  Future<int> updateList (ListModel list) async {
//    return await db!.update(listTable, list.toJson() , where: 'id = ?' , whereArgs: [list.id]);
//  }

  void updateList(String name , int id){
    db!.rawUpdate(
      'UPDATE $listTable SET name = ?  WHERE id = ?',
      ['$name', '$id'],
    ).then((value){
      getAllLists(db!);
      emit(UpdateListState());
    });
  }

//  Future<int> updateTask (TaskModel task) async {
//    return await db!.update(tasksTable, task.toJson() , where: 'id = ?' , whereArgs: [task.id]);
//  }

  void updateTaskStatus(String status , int id ){
    db!.rawUpdate(
      'UPDATE $tasksTable SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value){
      getAllTasks(db!);
      emit(AppUpdateTaskStatusInDatabase());
    });
  }

  void updateSubTaskStatus(String status , int id ){
    db!.rawUpdate(
      'UPDATE $subTasksTable SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value){
      getAllSubTasks(db!);
      emit(AppUpdateSubTaskStatusInDatabase());
    });
  }

  void updateTaskData(String name , String details , String date , String time , int id){
    db!.rawUpdate(
      'UPDATE $tasksTable SET name = ? , details = ? , date = ? , time = ? WHERE id = ?',
      ['$name', '$details' , '$date' , '$time' , '$id'],
    ).then((value){
      getAllTasks(db!);
      emit(AppUpdateTaskDataInDatabase());
    });
  }

  void updateSubTaskData(String name , String details , String date , String time , int id){
    db!.rawUpdate(
      'UPDATE $subTasksTable SET name = ? , details = ? , date = ? , time = ? WHERE id = ?',
      ['$name', '$details' , '$date' , '$time' , '$id'],
    ).then((value){
      getAllSubTasks(db!);
      emit(AppUpdateSubTaskDataInDatabase());
    });
  }

}