import 'package:moor_flutter/moor_flutter.dart';

part 'db.g.dart';

class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get desc => text()();
  TextColumn get date => text()();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
}

@UseMoor(tables: [Todos])
class MyDatabase extends _$MyDatabase {
  MyDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;

  /* database interface functions */
  // get all todos from the database
  Future<List<Todo>> getAllTodos() =>
      (select(todos)..orderBy([(t) => OrderingTerm(expression: t.date)])).get();
  // return a stream of todos from the database
  Stream<List<Todo>> watchAllTodos() =>
      (select(todos)..orderBy([(t) => OrderingTerm(expression: t.date)]))
          .watch();
  Future<Todo> getTodoWithId(int id) =>
      (select(todos)..where((task) => task.id.equals(id))).getSingle();
  // insert a new todo to the database
  Future<int> insertTodo(Todo todo) => into(todos).insert(todo);
  // update a todo in the database
  Future updateTodo(Todo todo) => update(todos).replace(todo);
  // deletes a todo in the database
  Future deleteTodo(Todo todo) => delete(todos).delete(todo);
}
