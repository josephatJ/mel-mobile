
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/home/home.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';




class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = '';
  String password =  '';
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool failedToLogin = false;
  ProgressDialog progressDialog;
  String createBasicAuthToken(username, password) {
    return 'Basic ' + convert.base64Encode(utf8.encode('$username:$password'));
  }

  login(String basicAuth) async {
    progressDialog.show();
    // Response response = await get('https://api.somewhere.io',
    // headers: <String, String>{'authorization': basicAuth});
    final url = Uri.http('play.dhis2.org', '2.35.3/api/me');

    final response = await http.get(
      'https://play.dhis2.org/2.35.3/api/me.json',headers: <String, String>{'authorization': 'Basic YWRtaW46ZGlzdHJpY3Q='},
    );
    print(response.statusCode);
    Map<String, dynamic> responseMap = json.decode(response.body);
    if (response.statusCode == 200) {
      setState((){
        failedToLogin = false;
      });
      progressDialog.hide();
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => HomePage(authToken: basicAuth, baseUrl: 'https://play.dhis2.org/2.35.3', )));
      // return responseMap;
    } else {
      setState((){
        failedToLogin = true;
      });
      progressDialog.hide();
    }
    // await http.get(url, headers: <String, String>{'authorization': basicAuth})
    //     .then((response) {
    //       print(response.body);
    //   Map<String, dynamic> responseMap = json.decode(response.body);
    //   if(response.statusCode == 200) {
    //     print("hetete");
    //   }
    //   else {
    //     if(responseMap.containsKey("message")) print('dkjsdjsd');
    //   }
    // }).catchError((err) {
    //   print("ererre");
    //   print(err);
    // });
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context);
    progressDialog.style(
        message: 'Authenticating ....',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w500)
    );
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 200,
                      child: Image.asset('./../assets/icons8_face_with_tears_of_joy_64.png')),
                ),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      hintText: 'Enter username'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                      errorText: failedToLogin ? 'Failed to login': null,
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password')
                ),
              ),
              FlatButton(
                onPressed: (){
                  //TODO FORGOT PASSWORD SCREEN GOES HERE
                },
                child: Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: FlatButton(
                  onPressed: () {
                    print('Put logic to get data here');
                    var basicAuthToken = createBasicAuthToken('username', 'password');
                    login(basicAuthToken);
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 130,
              ),
              Text('New User? Contact MEL Administrator')
            ],
          ),
        ),
    );
  }
}


