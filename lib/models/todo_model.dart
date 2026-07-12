import 'package:hive/hive.dart';

class TodoModel {
  String id;
  String title;
  bool isDone;
  int sortOrder;

  TodoModel({
    required this.id,
    required this.title,
    this.isDone = false,
    this.sortOrder = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isDone': isDone,
        'sortOrder': sortOrder,
      };
}

class TodoModelAdapter extends TypeAdapter<TodoModel> {
  @override
  final int typeId = 3;

  @override
  TodoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return TodoModel(
      id: fields[0] as String,
      title: fields[1] as String,
      isDone: fields[2] as bool,
      sortOrder: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TodoModel obj) {
    writer.writeByte(4);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.title);
    writer.writeByte(2);
    writer.write(obj.isDone);
    writer.writeByte(3);
    writer.write(obj.sortOrder);
  }
}
