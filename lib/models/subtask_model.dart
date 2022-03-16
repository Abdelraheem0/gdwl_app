
class SubTaskModel {
  int? id;
  String? name;
  String? details;
  String? date;
  String? time;
  String? status;
  int? taskId;

  SubTaskModel(
      {
        this.id,
        this.name,
        this.details,
        this.date,
        this.time,
        this.status,
        this.taskId,
      });

  SubTaskModel.fromMap(Map<String , dynamic> map) {
    id = map['id'];
    name = map['name'];
    details = map['details'];
    date = map['date'];
    time = map['time'];
    status = map['status'];
    taskId = map['task_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name' : name,
      'details' : details,
      'date' : date,
      'time' : time,
      'status' : status,
      'task_id' : taskId,
    };
  }
}