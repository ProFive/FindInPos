// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:smartnotes/actions/actions.dart';
import 'package:smartnotes/models/models.dart';
import 'package:smartnotes/presentation/todo_list.dart';
import 'package:smartnotes/selectors/selectors.dart';

class FilteredTodos extends StatelessWidget {
  FilteredTodos({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return new TodoList(
          todos: vm.todos,
          onCheckboxChanged: vm.onCheckboxChanged,
          onRemove: vm.onRemove,
          onUndoRemove: vm.onUndoRemove,
        );
      },
    );
  }
}

class _ViewModel {
  final List<Todo> todos;
  final bool loading;
  final Function(Todo, bool) onCheckboxChanged;
  final Function(Todo) onRemove;
  final Function(Todo) onUndoRemove;

  _ViewModel({
    @required this.todos,
    @required this.loading,
    @required this.onCheckboxChanged,
    @required this.onRemove,
    @required this.onUndoRemove,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      todos: filteredTodosSelector(
        todosSelector(store.state),
        activeFilterSelector(store.state),
      ),
      loading: store.state.isLoading,
      onCheckboxChanged: (todo, complete) {
        store.dispatch(new UpdateTodoAction(
          todo.id,
          todo.copyWith(complete: !todo.complete),
        ));
      },
      onRemove: (todo) {
        store.dispatch(new DeleteTodoAction(todo.id));
      },
      onUndoRemove: (todo) {
        store.dispatch(new AddTodoAction(todo));
      },
    );
  }
}
