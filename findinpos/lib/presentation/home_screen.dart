// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:smartnotes/routers/routers.dart';
import 'package:smartnotes/containers/active_tab.dart';
import 'package:smartnotes/containers/extra_actions_container.dart';
import 'package:smartnotes/containers/filter_selector.dart';
import 'package:smartnotes/containers/filtered_todos.dart';
import 'package:smartnotes/containers/stats.dart';
import 'package:smartnotes/containers/tab_selector.dart';
import 'package:smartnotes/localization.dart';
import 'package:smartnotes/models/models.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen() : super(key: ArchSampleKeys.homeScreen);

  @override
  Widget build(BuildContext context) {
    return new ActiveTab(
      builder: (BuildContext context, AppTab activeTab) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text(ReduxLocalizations.of(context).appTitle),
            actions: [
              new FilterSelector(visible: activeTab == AppTab.todos),
              new ExtraActionsContainer(),
            ],
          ),
          body: activeTab == AppTab.todos ? new FilteredTodos() : new Stats(),
          floatingActionButton: new FloatingActionButton(
            key: ArchSampleKeys.addTodoFab,
            onPressed: () {
              Navigator.pushNamed(context, ArchSampleRoutes.addTodo);
            },
            child: new Icon(Icons.add),
            tooltip: ReduxLocalizations.of(context).addTodo,
          ),
          bottomNavigationBar: new TabSelector(),
        );
      },
    );
  }
}
