import 'package:hive/hive.dart';

class EventModel {
  String id;
  String calendarId;
  String title;
  DateTime date;
  int colorValue;
  String fontFamily; // e.g. 'Outfit', 'Pacifico'
  int? stickerCodePoint; // IconData.codePoint

  EventModel({
    required this.id,
    required this.calendarId,
    required this.title,
    required this.date,
    required this.colorValue,
    this.fontFamily = 'Outfit',
    this.stickerCodePoint,
  });
}

class EventModelAdapter extends TypeAdapter<EventModel> {
  @override
  final int typeId = 1;

  @override
  EventModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return EventModel(
      id: fields[0] as String,
      calendarId: fields[1] as String,
      title: fields[2] as String,
      date: DateTime.parse(fields[3] as String),
      colorValue: fields[4] as int,
      fontFamily: fields[5] as String? ?? 'Outfit',
      stickerCodePoint: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, EventModel obj) {
    writer.writeByte(7);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.calendarId);
    writer.writeByte(2);
    writer.write(obj.title);
    writer.writeByte(3);
    writer.write(obj.date.toIso8601String());
    writer.writeByte(4);
    writer.write(obj.colorValue);
    writer.writeByte(5);
    writer.write(obj.fontFamily);
    writer.writeByte(6);
    writer.write(obj.stickerCodePoint);
  }
}
