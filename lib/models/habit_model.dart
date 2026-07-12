import 'package:hive/hive.dart';

class HabitModel {
  String id;
  String name;
  int iconCodePoint;
  List<String> completedDates; // ISO8601 date strings (yyyy-MM-dd)

  HabitModel({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    List<String>? completedDates,
  }) : completedDates = completedDates ?? [];

  bool isCompletedOn(DateTime date) {
    final key = _dateKey(date);
    return completedDates.contains(key);
  }

  void toggleDate(DateTime date) {
    final key = _dateKey(date);
    if (completedDates.contains(key)) {
      completedDates.remove(key);
    } else {
      completedDates.add(key);
    }
  }

  int get currentStreak {
    if (completedDates.isEmpty) return 0;
    final sorted = completedDates.toList()..sort((a, b) => b.compareTo(a));
    int streak = 0;
    DateTime check = DateTime.now();
    for (int i = 0; i < sorted.length; i++) {
      final dateStr = _dateKey(check);
      if (sorted.contains(dateStr)) {
        streak++;
        check = check.subtract(const Duration(days: 1));
      } else if (i == 0) {
        // Today not completed yet, check from yesterday
        check = check.subtract(const Duration(days: 1));
        final yesterdayStr = _dateKey(check);
        if (sorted.contains(yesterdayStr)) {
          streak++;
          check = check.subtract(const Duration(days: 1));
        } else {
          break;
        }
      } else {
        break;
      }
    }
    return streak;
  }

  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

class HabitModelAdapter extends TypeAdapter<HabitModel> {
  @override
  final int typeId = 2;

  @override
  HabitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return HabitModel(
      id: fields[0] as String,
      name: fields[1] as String,
      iconCodePoint: fields[2] as int,
      completedDates: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, HabitModel obj) {
    writer.writeByte(4);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.name);
    writer.writeByte(2);
    writer.write(obj.iconCodePoint);
    writer.writeByte(3);
    writer.write(obj.completedDates);
  }
}
