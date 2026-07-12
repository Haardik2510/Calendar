import 'package:hive/hive.dart';

class CalendarModel {
  String id;
  String name;
  int colorValue; // stored as int (Color.value)
  bool isVisible;

  CalendarModel({
    required this.id,
    required this.name,
    required this.colorValue,
    this.isVisible = true,
  });
}

class CalendarModelAdapter extends TypeAdapter<CalendarModel> {
  @override
  final int typeId = 0;

  @override
  CalendarModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return CalendarModel(
      id: fields[0] as String,
      name: fields[1] as String,
      colorValue: fields[2] as int,
      isVisible: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CalendarModel obj) {
    writer.writeByte(4);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.name);
    writer.writeByte(2);
    writer.write(obj.colorValue);
    writer.writeByte(3);
    writer.write(obj.isVisible);
  }
}
