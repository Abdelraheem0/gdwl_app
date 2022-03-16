class ListModel {
  int? id;
  String? name;

  ListModel({
    this.id,
    this.name
  });

  ListModel.fromMap(Map<String , dynamic> map) {
     id = map['id'];
     name = map['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name' : name,
    };
  }
}