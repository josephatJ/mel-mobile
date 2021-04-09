


import 'package:flutter/cupertino.dart';

class OrganisationUnit {
  String id;
  String name;
  String label;
  Color color;
  String shortName;
  String code;
   OrganisationUnit(this.id, this.name, this.label, this.shortName,this.code);

   OrganisationUnit.fromJson(Map<String, dynamic> json)
       : id = json['id'],name = json['name'], label =json['label'], color = json['color'],shortName =json['shortName'],code = json['code'];
   Map<String, dynamic> toJson() => {
     'id': id,
     'name': name,
     'label': label,
     'color': color,
     'shortName': shortName,
     'code': code
   };
}

