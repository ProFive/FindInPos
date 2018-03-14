import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smartnotes/routers/routers.dart';
import 'package:redux/redux.dart';
import 'package:smartnotes/actions/actions.dart';
import 'package:smartnotes/containers/add_todo.dart';
import 'package:smartnotes/localization.dart';
import 'package:smartnotes/middleware/store_todos_middleware.dart';
import 'package:smartnotes/models/models.dart';
import 'package:smartnotes/presentation/home_screen.dart';
import 'package:smartnotes/reducers/app_state_reducer.dart';
import 'package:smartnotes/theme.dart';

void main() => runApp(new SmartNotesApp());

class SmartNotesApp extends StatelessWidget {
  final store = new Store<AppState>(
    appReducer,
    initialState: new AppState.loading(),
    middleware: createStoreTodosMiddleware(),
  );

  SmartNotesApp();

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: ReduxLocalizations.of(context).appTitle,
        theme: ArchSampleTheme.theme,
        localizationsDelegates: [
          new ReduxLocalizationsDelegate(),
        ],
        routes: {
          ArchSampleRoutes.home: (context) {
            return new StoreBuilder<AppState>(
              onInit: (store) => store.dispatch(new LoadTodosAction()),
              builder: (context, store) {
                return new HomeScreen();
              },
            );
          },
          ArchSampleRoutes.addTodo: (context) {
            return new AddTodo();
          },
        },
      ),
    );
  }
}

