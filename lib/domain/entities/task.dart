import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int? id;
  final String title;
  final bool isDone;

  const Task({this.id, required this.title, required this.isDone});

  Task copyWith({int? id, String? title, bool? isDone}) {
    return Task(id: id ?? this.id, title: title ?? this.title, isDone: isDone ?? this.isDone);
  }

  @override
  List<Object?> get props => [
        title,
        isDone,
      ];
}
