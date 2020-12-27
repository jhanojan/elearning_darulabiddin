import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'mainMenu.dart';

void main() {

  runApp(MaterialApp(
    home: Login(),
    debugShowCheckedModeBanner: false,
  ));
}
class Login extends StatefulWidget {
  String email,password;
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus {notSignIn, signIn}

class _LoginState extends State<Login> {

  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String email,password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide(){
    setState(() {
      _secureText = !_secureText;
    });
  }
  check(){
    final form = _key.currentState;
    if(form.validate()){
      form.save();
      login();
      //print("$email, $password");
    }
  }
  login() async {
    print("$email, $password");
    final response = await http.post("https://rpt.darulabidin.com/api/login/cek_login", body:{
      "username" : email,
      "password" : password,
    });
    final data = jsonDecode(response.body);
    bool error = data['error'];
    String message = data['message'];
    if(!error){
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(error);
      });
      print(message);
    }else{
      print(message);
    }
  }
  savePref(bool error) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setBool("error", false);
      preferences.commit();
    });
  }
  var error;
  getPref() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      error = preferences.getBool("error");
      _loginStatus = !error ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  signOut() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setBool("error", true);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    switch(_loginStatus){
      case LoginStatus.notSignIn:

    return Scaffold(
      appBar: new AppBar(
        title : new Text("Darul Abidin"),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(15),
          children: <Widget>[
            TextFormField(
              validator: (e){
                if(e.isEmpty){
                  return "Please Insert Username";
                }
              },
              onSaved: (e)=> email = e,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextFormField(
              validator: (e){
                if(e.isEmpty){
                  return "Please Provide Password";
                }
              },
              obscureText: _secureText,
              onSaved: (e)=> password = e,
              decoration: InputDecoration(
                    labelText: "Password",
                  suffixIcon: IconButton(
                    onPressed: showHide,
                    icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility),
                  )
              ),
            ),
            MaterialButton(
                onPressed: () {
                  check();
                },
                child: Text("Login"),
            )
          ],
        ),
      ),
    );
    break;
      case LoginStatus.signIn:
        return MainMenu(signOut);
        break;
    }
  }

}


