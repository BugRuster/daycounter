// File: lib/models/countdown_event.dart
import 'package:hive/hive.dart';

part 'countdown_event.g.dart';

@HiveType(typeId: 0)
class CountdownEvent extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime targetDate;

  @HiveField(2)
  String? description;

  CountdownEvent({
    required this.title,
    required this.targetDate,
    this.description,
  });
}