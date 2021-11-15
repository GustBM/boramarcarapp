import 'package:flutter/material.dart';

import 'package:boramarcarapp/screens/schedule/schedule_leisure_screen.dart';
import 'package:boramarcarapp/screens/schedule/schedule_work_screen.dart';

class SchedueleScreen extends StatefulWidget {
  static const routeName = '/schedule';

  @override
  _SchedueleScreenState createState() => _SchedueleScreenState();
}

class _SchedueleScreenState extends State<SchedueleScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  late TabBar tab;
  void initState() {
    controller = TabController(length: 2, vsync: this, initialIndex: 0);
    tab = TabBar(
        controller: controller,
        tabs: <Tab>[
          Tab(icon: new Icon(Icons.work)),
          Tab(icon: new Icon(Icons.work_off))
        ],
        indicatorSize: TabBarIndicatorSize.tab);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text('Horários'),
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          bottom: new TabBar(controller: controller, tabs: <Tab>[
            Tab(icon: new Icon(Icons.work)),
            Tab(icon: new Icon(Icons.beach_access)),
          ])),
      body: new TabBarView(controller: controller, children: <Widget>[
        ScheduleWorkScreen(),
        ScheduleLeisureScreen(),
      ]),
    );
  }
}
