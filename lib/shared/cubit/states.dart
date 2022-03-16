abstract class AppStates {}

class AppInitialState extends AppStates {}

class CreateDatabaseState extends AppStates {}

class AppInsertListToDatabase extends AppStates {}

class AppInsertTasksToDatabase extends AppStates {}

class AppInsertSubTasksToDatabase extends AppStates {}

class GetListsFromDatabaseState extends AppStates {}

class DeleteListFromDatabaseState extends AppStates {}

class GetTasksFromDatabaseState extends AppStates {}

class GetTasksByListIdFromDatabaseState extends AppStates {}

class AppGetSubTasksFromDatabase extends AppStates {}

class AppUpdateTaskStatusInDatabase extends AppStates {}

class AppUpdateSubTaskStatusInDatabase extends AppStates {}

class AppUpdateTaskDataInDatabase extends AppStates {}

class UpdateListState extends AppStates {}

class AppUpdateSubTaskDataInDatabase extends AppStates {}

class DeleteTaskFromDatabaseState extends AppStates {}

class DeleteAllCompletedTaskFromDatabaseState extends AppStates {}

class AppDeleteSubTasksDatabase extends AppStates {}

//class AppGetTasksFromDatabaseLoading extends AppStates {}

class AppChangeBottomSheetState extends AppStates {}

class AppIncreaseSubTasksState extends AppStates {}

class AppDecreaseSubTasksState extends AppStates {}

class ChangeCurrentTabIndexState extends AppStates {}

class ChangeDoneBtnColorState extends AppStates {}