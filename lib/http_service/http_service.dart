import 'dart:convert';

import 'package:flutter_complete_guide/models/models.dart';
import 'package:http/http.dart' as http;

class LoginService {
}
const BASEURL = 'https://play.dhis2.org/2.35.3/';
// Future<http.Response> getOrganisationUnit() {
//   return http.get(Uri.https());
// }

getOrganisationUnit() async {
  final response = await http.get(
    BASEURL + 'api/organisationUnits.json?fields=id,name,level,code,shortName,children[id,name,code,level,shortName]&&level=1',headers: <String, String>{'authorization': 'Basic YWRtaW46ZGlzdHJpY3Q='},
  );
  Map<String, dynamic> responseMap = json.decode(response.body);
  print(responseMap['organisationUnits']);
  return responseMap['organisationUnits'];
}

getOrganisationUnitChildren(id) async {
  final response = await http.get(
    BASEURL + 'api/organisationUnits/' + id+ '.json?fields=id,name,level,children[id,name,code,level,shortName]',headers: <String, String>{'authorization': 'Basic YWRtaW46ZGlzdHJpY3Q='},
  );
  Map<String, dynamic> responseMap = json.decode(response.body);
  print(responseMap['children']);
  return responseMap['children'];
}

