// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:smartnotes/actions/actions.dart';
import 'package:smartnotes/models/models.dart';
import 'package:smartnotes/selectors/selectors.dart';
import 'package:smartnotes/repository/file_storage.dart';
import 'package:smartnotes/repository/repository.dart';

List<Middleware<AppState>> createStoreTodosMiddleware([
  TodosRepository repository = const TodosRepository(
    fileStorage: const FileStorage(
      'redux_sample_app_',
      getApplicationDocumentsDirectory,
    ),
  ),
]) {
  final saveTodos = _createSaveTodos(repository);
  final loadTodos = _createLoadTodos(repository);

  return combineTypedMiddleware([
    new MiddlewareBinding<AppState, LoadTodosAction>(loadTodos),
    new MiddlewareBinding<AppState, AddTodoAction>(saveTodos),
    new MiddlewareBinding<AppState, ClearCompletedAction>(saveTodos),
    new MiddlewareBinding<AppState, ToggleAllAction>(saveTodos),
    new MiddlewareBinding<AppState, UpdateTodoAction>(saveTodos),
    new MiddlewareBinding<AppState, TodosLoadedAction>(saveTodos),
    new MiddlewareBinding<AppState, DeleteTodoAction>(saveTodos),
  ]);
}

Middleware<AppState> _createSaveTodos(TodosRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    repository.saveTodos(
      todosSelector(store.state).map((todo) => todo.toEntity()).toList(),
    );
  };
}

Middleware<AppState> _createLoadTodos(TodosRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    repository.loadTodos().then(
      (todos) {
        store.dispatch(
          new TodosLoadedAction(
            todos.map(Todo.fromEntity).toList(),
          ),
        );
      },
    ).catchError((_) => store.dispatch(new TodosNotLoadedAction()));

    next(action);
  };
}
