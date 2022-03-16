//// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_string_interpolations, avoid_function_literals_in_foreach_calls, empty_catches
//
//import 'dart:async';
//
//import 'package:expansion_tile_card/expansion_tile_card.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:path/path.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:gdwl/models/subtask_model.dart';
//import 'package:gdwl/models/task_model.dart';
//import 'package:gdwl/services/exceptions.dart';
//import 'package:gdwl/shared/cubit/states.dart';
//import 'package:gdwl/view/screens/mytasks_screen.dart';
//
//import '../constants.dart';
//
//class AppCubit extends Cubit<AppStates> {
//  AppCubit() : super(AppInitialState());
//
//  static AppCubit get(context) => BlocProvider.of(context);
//
//  List<Widget> screens = [
//    MyTasksScreen(),
////    WorkTasksScreen(),
//  ];
//
//  List<Tab> listNames = [
//    Tab(
//      text: 'My Tasks',
//    ),
//  ];
//
//  var taskNameController = TextEditingController();
//  var taskDetailsController = TextEditingController();
//  var taskDateController = TextEditingController();
//  var taskTimeController = TextEditingController();
//
//
//  bool bottomSheetShown = false;
//  IconData fabIcon = Icons.edit;
//  bool isExpansionOpen = false;
//
//  void changeBottomSheetState(bool isShow, IconData icon) {
//    bottomSheetShown = isShow;
//    fabIcon = icon;
//    emit(AppChangeBottomSheetState());
//  }
//
//  int subTasksCounter = 0;
//
//  void increaseSubTasks() {
//    subTasksCounter++;
//    emit(AppIncreaseSubTasksState());
//  }
//
//  void decreaseSubTasks() {
//    subTasksCounter--;
//    emit(AppDecreaseSubTasksState());
//  }
//
//  AppDecreaseSubTasksStateDatabase? _db;
//
//  List<DatabaseTask> _tasks =[];
//  final _tasksStreamController = StreamController<List<DatabaseTask>>.broadcast();
//
//  List<DatabaseSubTask> _subTasks =[];
//  final _subTasksStreamController = StreamController<List<DatabaseSubTask>>.broadcast();
//
//  Future<void> cacheTasks() async {
//    final allTasks = await getAllTasks();
//    _tasks = allTasks.toList();
//    _tasksStreamController.add(_tasks);
//  }
//
//  Future<void> cacheSubTasks() async {
//    final allSubTasks = await getAllSubTasks();
//    _subTasks = allSubTasks.toList();
//    _subTasksStreamController.add(_subTasks);
//  }
//
//  Future<DatabaseTask> getOrCreateTask({required int id , required String name , required String details , required String date , required String time}) async {
//    try{
//      final task = getTask(id: id);
//      return task;
//    }on CouldNotFindTask {
//      final createdTask = await createTask(name: name, details: details, date: date, time: time);
//      return createdTask;
//    } catch (e){
//      rethrow;
//    }
//  }
//
//  Future<DatabaseSubTask> getOrCreateSubTask({required DatabaseTask parent , required int id , required String name , required String details , required String date , required String time}) async {
//    try{
//      final subTask = getSubTask(id: id);
//      return subTask;
//    }on CouldNotFindTask {
//      final createdSubTask = await createSubTask(name: name, details: details, date: date, time: time, parent: parent);
//      return createdSubTask;
//    } catch (e){
//      rethrow;
//    }
//  }
//
//  Future<DatabaseSubTask> updateSubTask({required DatabaseSubTask subTask , required String name , required String details , required String date , required String time}) async {
//    await ensureDbIsOpen();
//    final db = _getDatabaseOrThrow();
//
//    await getSubTask(id: subTask.id);
//
//    final updatesCount = await db.update(subTasksTable, {
//      nameColumn: name,
//      detailsColumn:details,
//      dateColumn:date,
//      timeColumn:time,
//    });
//
//    if(updatesCount == 0){
//      throw CouldNotUpdateSubTask();
//    }else{
//      final updatedSubTask = await getSubTask(id: subTask.id);
//      _subTasks.removeWhere((subTask) => subTask.id == updatedSubTask.id);
//      _subTasks.add(updatedSubTask);
//      _subTasksStreamController.add(_subTasks);
//      return updatedSubTask;
//    }
//  }
//
//  Future<Iterable<DatabaseSubTask>> getAllSubTasks() async {
//    await ensureDbIsOpen();
//    final db = _getDatabaseOrThrow();
//    final subTasks = await db.query(subTasksTable);
//
//    return subTasks.map((subTaskRow) => DatabaseSubTask.fromRow(subTaskRow));
//  }
//
//  Future<DatabaseSubTask> getSubTask({required int id}) async {
//    await ensureDbIsOpen();
//    final db = _getDatabaseOrThrow();
//    final subTasks = await db.query(
//      subTasksTable,
//      limit: 1,
//      where: 'id = ?',
//      whereArgs: [id],
//    );
//    if(subTasks.isEmpty) {
//      throw CouldNotFindSubTask();
//    }else{
//      final subTask =  DatabaseSubTask.fromRow(subTasks.first);
//      _subTasks.removeWhere((subTask) => subTask.id == id);
//      _subTasks.add(subTask);
//      _subTasksStreamController.add(_subTasks);
//      return subTask;
//    }
//  }
//
//  Future<void> deleteSubTask({required int id}) async {
//    await ensureDbIsOpen();
//    final db = _getDatabaseOrThrow();
//
//    final deletedCount = await db.delete(
//      subTasksTable,
//      where: 'id = ?',
//      whereArgs: [id],
//    );
//    if(deletedCount == 0){
//      throw CouldNotDeleteSubTask();
//    }else{
//      _subTasks.removeWhere((subTask) => subTask.id == id);
//      _subTasksStreamController.add(_subTasks);
//    }
//  }
//
//  Future<DatabaseSubTask> createSubTask({required DatabaseTask parent , required String name , required String details , required String date , required String time}) async {
//    await ensureDbIsOpen();
//    final db = _getDatabaseOrThrow();
//
//    final dbTask = await getTask(id: parent.id);
//    if(dbTask != parent){
//      throw CouldNotFindTask();
//    }
//
//    //create subTask
//    final subTaskId = await db.insert(subTasksTable, {
//      taskIdColumn: parent.id,
//      nameColumn: name,
//      detailsColumn: details,
//      dateColumn: date,
//      timeColumn: time,
//      statusColumn: 'new',
//    });
//
//    final subTask = DatabaseSubTask(
//      id: subTaskId,
//      name: name,
//      details: details,
//      date: date,
//      time: time,
//      status: 'new',
//      taskId: parent.id,
//    );
//    _subTasks.add(subTask);
//    _subTasksStreamController.add(_subTasks);
//    return subTask;
//  }
//
//  Future<DatabaseTask> updateTask({required DatabaseTask task , required String name , required String details , required String date , required String time}) async {
//    await ensureDbIsOpen();
//    final db = _getDatabaseOrThrow();
//
//    await getTask(id: task.id);
//
//    final updatesCount = await db.update(tasksTable, {
//      nameColumn: name,
//      detailsColumn:details,
//      dateColumn:date,
//      timeColumn:time,
//    });
//
//    if(updatesCount == 0){
//      throw CouldNotUpdateTask();
//    }else{
//      final updatedTask = await getTask(id: task.id);
//      _tasks.removeWhere((task) => task.id == updatedTask.id);
//      _tasks.add(updatedTask);
//      _tasksStreamController.add(_tasks);
//      return updatedTask;
//    }
//  }
//
//  Future<Iterable<DatabaseTask>> getAllTasks() async {
//    await ensureDbIsOpen();
//    final db = _getDatabaseOrThrow();
//    final tasks = await db.query(tasksTable);
//
//    return tasks.map((taskRow) => DatabaseTask.fromRow(taskRow));
//  }
//
//  Future<DatabaseTask> getTask({required int id}) async {
//    await ensureDbIsOpen();
//    final db = _getDatabaseOrThrow();
//
//    final tasks = await db.query(
//      tasksTable,
//      limit: 1 ,
//      where: 'id = ?' ,
//      whereArgs: [id],
//    );
//
//    if(tasks.isEmpty){
//      throw CouldNotFindTask();
//    }else{
//      final task =  DatabaseTask.fromRow(tasks.first);
//      _tasks.removeWhere((task) => task.id == id);
//      _tasks.add(task);
//      _tasksStreamController.add(_tasks);
//      return task;
//    }
//  }
//
//  Future<DatabaseTask> createTask({required String name , required String details , required String date , required String time}) async {
//    await ensureDbIsOpen();
//    final db = _getDatabaseOrThrow();
//
//    final taskId = await db.insert(tasksTable, {
//      nameColumn: name,
//      detailsColumn: details,
//      dateColumn: date,
//      timeColumn: time,
//      statusColumn: 'new',
//    });
//
//    final task = DatabaseTask(
//      id: taskId,
//      name: name,
//      details: details,
//      date: date,
//      time: time,
//      status: 'new',
//    );
//
//    _tasks.add(task);
//    _tasksStreamController.add(_tasks);
//    return task;
//  }
//
//  Future<void> deleteTask({required int id}) async {
//    await ensureDbIsOpen();
//    final db = _getDatabaseOrThrow();
//    final deletedCount = await db.delete(
//      tasksTable ,
//      where: 'id = ?' ,
//      whereArgs: [id],
//    );
//    if(deletedCount == 0){
//      throw CouldNotDeleteTask();
//    }else{
//      _tasks.removeWhere((task) => task.id == id);
//      _tasksStreamController.add(_tasks);
//    }
//  }
//
//  Database _getDatabaseOrThrow(){
//    final db = _db;
//    if(db == null){
//      throw DatabaseIsNotOpen();
//    }else{
//      return db;
//    }
//  }
//
//  Future<void> close() async {
//    final db = _db;
//    if(db == null) {
//      throw DatabaseIsNotOpen();
//    }else{
//      db.close();
//      _db = null;
//    }
//  }
//
//  Future<void> ensureDbIsOpen() async {
//    try {
//      await open();
//    } on DatabaseAlreadyOpenException {
//      // empty
//    }
//  }
//
//  Future<void> open() async {
//    if (_db != null) {
//      throw DatabaseAlreadyOpenException();
//    }
//    try {
//      final docsPath = await getApplicationDocumentsDirectory();
//      final dbPath = join(docsPath.path, dbName);
//      final db = await openDatabase(dbPath);
//      _db = db;
//
//      //create tasks table
//      await db.execute(createTaskTable);
//      await cacheTasks();
//
//      //create subTasks table
//      await db.execute(createSubTaskTable);
//      await cacheSubTasks();
//
//    } on MissingPlatformDirectoryException {
//      throw UnableToGetDocumentDirectory();
//    }
//  }
//}