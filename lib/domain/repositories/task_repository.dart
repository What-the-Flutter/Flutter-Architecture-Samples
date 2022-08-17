import '../../data/data_sources/database_data_source.dart';
import '../entities/task.dart';

class TaskRepository {
  final DatabaseDataSource _db;

  TaskRepository(this._db);

  Future<List<Task>> get tasks => _db.getTasks();

  Future<void> update(Task task) async => _db.updateTask(task);

  Future<void> delete(Task task) async => _db.deleteTask(task.id!);

  Future<Task> add(Task task) async => _db.createTask(task);
}
