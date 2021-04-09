
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/dataentry/dataentry.home.dart';
import 'package:flutter_complete_guide/login/login.dart';
import 'package:flutter_complete_guide/reports/reports.home.dart';
import 'package:flutter_complete_guide/resources/resources.home.dart';
import 'package:flutter_treeview/generated/i18n.dart';
import 'package:flutter_treeview/tree_view.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';



class HomePage extends StatefulWidget {
  HomePage({Key key, this.authToken, this.baseUrl}) : super(key: key);
  final String authToken;
  final String baseUrl;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentTitle = 'Data entry';
  String currentModuleId = 'entry';
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text(currentTitle),),
      body: Container(
        child: currentModuleId == 'entry' ? DataEntryHome(): currentModuleId == 'reports' ? ReportsHome(): ResourcesHome(),
      ),
      drawer: Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 130,
          child: DrawerHeader(
            child: Text('Menu'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
        ),
        ListTile(
          title: Text('Data entry'),
          onTap: () {
            setState(() {
              currentTitle = 'Data entry';
              currentModuleId = 'entry';
            });
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Reports'),
          onTap: () {
            setState(() {
              currentTitle = 'Reports';
              currentModuleId = 'reports';
            });
            Navigator.pop(context);
          },
        ),ListTile(
          title: Text('Resources'),
          onTap: () {
            setState(() {
              currentTitle = 'Resources';
              currentModuleId = 'resources';
            });
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Logout'),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => LoginPage()));
          },
        ),
      ],
    ),
    ),
    );
  }
}

