import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sell_it/scoped-models/main.dart';
//import './products.dart';

class AuthPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }


}


class _AuthPageState extends State<AuthPage>{

  String email;
  String password;
  bool acceptTerms = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  DecorationImage _buildBackgroundImage(){
    return DecorationImage(
      image: AssetImage('assets/background.jpg'),
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop)
    );
  }

  Widget _buildEmailTextField(){
      return TextFormField(
          decoration: InputDecoration(labelText: "Email", filled: true, fillColor: Colors.white),
          keyboardType: TextInputType.emailAddress,
          validator: (String value){
            if(value != "ema@gmail.com"){
              return "You entered a wrong email address";
            }
            return null;
          },
          onSaved: (String value){           
              email = value;
          },
      );
  }

  Widget _buildPasswordTextField(){
    return TextFormField(
      decoration: InputDecoration(labelText: "Password", filled: true, fillColor: Colors.white),
      obscureText: true,
      validator: (String value){
        if(value != "ema"){
          return "you entered a wrong password";
        }
        return null;
      },
      onSaved: (String value){
          password = value;
      },
    );
  }

  Widget _buildAcceptSwitch(){
      return SwitchListTile(
        value: acceptTerms,
        title: Text("Accept Terms"),
        onChanged: (bool value){
          setState((){
            acceptTerms = value;
          });
        },
      );
  }

  void _submitForm(Function login){
    if(!_formKey.currentState.validate() || !acceptTerms){
      return;
    }
    _formKey.currentState.save(); 
    login(email, password);
    Navigator.pushReplacementNamed(context, 'products'); 

  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 500.0 : deviceWidth * 0.95;
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            image: _buildBackgroundImage()
          ),
          child: Center(
            child: SingleChildScrollView(
            child: Container(
                width: targetWidth,
                child: Form(
                  key: _formKey,
                  child: Column(
                  children: <Widget>[
                  _buildEmailTextField(),
                  SizedBox(height: 10.0),
                  _buildPasswordTextField(),
                  SizedBox(height: 10.0),
                  _buildAcceptSwitch(),
                  SizedBox(height: 10.0),
                  ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
                    return  RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("Login"),
                      onPressed: () => _submitForm(model.login)
                    ) ; 
                  })
                 
                ],
              ))
            )
          )
          )
        )
    );
  
  }
}