// class _TreePageState extends State<TreePage> {
//   TreeViewController _controller;
//   @override
//   void initState() {
//     super.initState();
//     ///The controller must be initialized when the treeView create
//     _controller = TreeViewController();
//   }
// }

import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/http_service/http_service.dart';
import 'package:flutter_complete_guide/models/models.dart';
import 'package:list_treeview/list_treeview.dart';


class TreeNodeData extends NodeData {
  TreeNodeData({this.label, this.color, this.name, this.id, this.code, this.shortName}) : super();

  /// Other properties that you want to define
  final String label;
  final Color color;
  final String name;
  final String id;
  final String code;
  final String shortName;

  String property1;
  String property2;
  String property3;
}

class TreePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TreePageState();
  }
}

class _TreePageState extends State<TreePage>
    with SingleTickerProviderStateMixin {
  TreeViewController _controller;
  bool _isSuccess;
  List<OrganisationUnit> organisationUnits = [];
  List<Color> _colors = [];
  @override
  void initState() {
    super.initState();

    ///The controller must be initialized when the treeView create
    _controller = TreeViewController();
    // Map ouMap = jsonDecode("{'id':'123','name':'National','label':'National','shortName':'National','code':'code'}");
    // var organisationUnit = OrganisationUnit.fromJson(ouMap);
    // organisationUnits.add(organisationUnit);
    for (int i = 0; i < 100; i++) {
      if (randomColor() != null) {
        _colors.add(randomColor());
      }
    }
    ///Data may be requested asynchronously
    getData();
  }

  void getData() async {
    print('start get data');
    _isSuccess = false;
    await Future.delayed(Duration(seconds: 2));

    var ouDetails = await getOrganisationUnit();
    var orgUnitChildren = ouDetails[0]['children'];
    var ouTree = TreeNodeData(
        id: ouDetails[0]['id'],
        name: ouDetails[0]['name'],
        label: ouDetails[0]['name'],
        color: Color.fromARGB(255, 0, 139, 69),
        shortName: ouDetails[0]['shortName'],
        code: ouDetails[0]['code']
    );
    for (var childOu in orgUnitChildren) {
      var child = TreeNodeData(
          id: childOu['id'],
          name: childOu['name'],
          label: childOu['name'],
          color: Color.fromARGB(255, 0, 139, 69),
          shortName: childOu['shortName'],
          code: childOu['code']
      );
      ouTree.addChild(child);
    }

    /// set data
    _controller.treeData([ouTree]);
    print('set treeData succeeded');

    setState(() {
      _isSuccess = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color getColor(int level) {
    return _colors[level % _colors.length];
  }

  Color randomColor() {
    int r = Random.secure().nextInt(200);
    int g = Random.secure().nextInt(200);
    int b = Random.secure().nextInt(200);
    return Color.fromARGB(255, r, g, b);
  }


  void getSubUnits(TreeNodeData item) async {
    var ouChildren = await getOrganisationUnitChildren(item.id);
    print('ouChildren');
    print(ouChildren);
    for (var childOu in ouChildren) {
      var child = TreeNodeData(
          id: childOu['id'],
          name: childOu['name'],
          label: childOu['name'],
          color: Color.fromARGB(255, 0, 139, 69),
          shortName: childOu['shortName'],
          code: childOu['code']
      );
      // childItems.addChild(child);
      _controller.insertAtRear(item,child);
    }
    // _controller.insertAtFront(dataNode, newNode);
    // _controller.insertAtRear(dataNode, newNode);
    // _controller.insertAtIndex(1, dataNode, newNode);
  }

  void delete(dynamic item) {
    _controller.removeItem(item);
  }

  void select(dynamic item) {
    _controller.selectItem(item);
  }

  void selectAllChild(dynamic item) {
    print("ITEM");
    print(item);
    _controller.selectAllChild(item);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isSuccess ? getBody() : getProgressView(),
    );
  }

  Widget getProgressView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget getBody() {
    return ListTreeView(
      shrinkWrap: false,
      padding: EdgeInsets.all(0),
      itemBuilder: (BuildContext context, NodeData data) {
        TreeNodeData item = data;
//              double width = MediaQuery.of(context).size.width;
        double offsetX = item.level * 18.0;
        return Container(
          height: 55,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: offsetX),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: InkWell(
                          splashColor: Colors.amberAccent.withOpacity(1),
                          highlightColor: Colors.red,
                          onTap: () {
                            print("EXPAND");
                            print(data.isExpand);
                            // selectAllChild(item);
                            // if (item.isExpand) {
                            //   getSubUnits(item);
                            // }
                          },
                          child: data.isExpand
                              ? Icon(
                            Icons.arrow_drop_down,
                            size: 30,
                            color: Color(0xFFFF7F50),

                          )
                              : Icon(
                            Icons.arrow_right,
                            size: 20,
                          ),
                        ),
                      ),
                      Container(
                        child: InkWell(
                            onTap: () {
                              selectAllChild(item);
                              print('########################################');
                              print(data.isExpand);
                              getSubUnits(item);
                            },
                          child: OuTreeNode(nodeItem: item,),
                        ),
                      ),
//                          Text(
//                            '${item.label}',
//                            style: TextStyle(color: item.color),
//                          ),
                    ],
                  ),
                ),
              ),
              // Visibility(
              //   visible: item.isExpand,
              //   child: InkWell(
              //     onTap: () {
              //       getSubUnits(item);
              //     },
              //     child: Icon(
              //       Icons.arrow_drop_down,
              //       size: 30,
              //     ),
              //   ),
              // )
            ],
          ),
        );
      },
      onTap: (NodeData data) {
        print('index = ${data.index}');
      },
      onLongPress: (data) {
        delete(data);
      },
      controller: _controller,
    );
  }
}

class OuTreeNode extends StatelessWidget {
  OuTreeNode({this.nodeItem});
  final TreeNodeData nodeItem;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(nodeItem.name,style: TextStyle(
          fontSize: 15)),
    );
  }
}
