const dbName = 'gdwl.db';
const listTable = 'lists';
const tasksTable = 'tasks';
const subTasksTable = 'subTasks';
const idColumn = 'id';
const taskIdColumn = 'taskId';
const nameColumn = 'name';
const detailsColumn = 'details';
const dateColumn = 'date';
const timeColumn = 'time';
const statusColumn = 'status';
const createListTable = '''
      CREATE TABLE IF NOT EXISTS "$listTable" (
	          "id"	INTEGER NOT NULL,
	          "name"	TEXT NOT NULL,
	          PRIMARY KEY("id" AUTOINCREMENT));''';
const createTaskTable = '''
      CREATE TABLE IF NOT EXISTS "$tasksTable" (
	          "id"	INTEGER NOT NULL,
	          "name"	TEXT,
	          "details"	TEXT,
	          "date"	TEXT,
	          "time"	TEXT,
	          "status"	TEXT DEFAULT 'new',
	          "list_id"	INTEGER NOT NULL,
	          FOREIGN KEY("list_id") REFERENCES "$listTable"("id"),
	          PRIMARY KEY("id" AUTOINCREMENT));''';
const createSubTaskTable = ''' 
      CREATE TABLE IF NOT EXISTS "$subTasksTable" (
	          "id"	INTEGER NOT NULL,
	          "name"	TEXT NOT NULL,
	          "details"	TEXT,
	          "date"	TEXT,
	          "time"	TEXT,
	          "status"	TEXT DEFAULT 'new',
	          "task_id"	INTEGER NOT NULL,
	          FOREIGN KEY("task_id") REFERENCES "$tasksTable"("id"),
	          PRIMARY KEY("id" AUTOINCREMENT));''';
