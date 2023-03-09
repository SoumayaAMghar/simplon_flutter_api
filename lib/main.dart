import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/services/briefs_service.dart';
import 'package:myapp/views/brief_list.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => BriefsService());
}

void main() {
  setupLocator();
  runApp(App());
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BriefList(),
    );
  }
}
