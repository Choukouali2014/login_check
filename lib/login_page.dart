import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget{

   @override
  State<StatefulWidget> createState()=> new _LoginPageState();


}

enum FormType{
  login,
  register
}
  class _LoginPageState extends State<LoginPage>{

  final formKey = new GlobalKey<FormState>();

     String _email;
     String _password;
     FormType _formType =  FormType.login;
     bool validateAndSave(){
        final form = formKey.currentState;
        if(form.validate()){
          form.save();
         return true;
        }
        return false;
     }

    void validateAndSubmit() async{
       if(validateAndSave()){
         try{
           if(_formType == FormType.login){
             FirebaseUser user = await  FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
             print('Signed in : ${user.uid}');
             formKey.currentState.reset();
           }else{
             FirebaseUser user = await  FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
             print('Registered user : ${user.uid}');
           }

         }catch(e){
           print('Error : $e');
         }



       }
    }
    void moveToRegiter(){
      formKey.currentState.reset();
       setState(() {
         _formType = FormType.register;
       });

    }
    void moveToLogin(){

       setState(() {
         _formType = FormType.login;
       });

    }

    @override
    Widget build(BuildContext context) {
       return new Scaffold(
         appBar: new AppBar(title: new Text('Flutter Login'),
         ),
         body: new Container(
           padding: EdgeInsets.all(16.0),
           child: new Form(
             key: formKey,
               child: new Column(
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: buildInputs() + buildButtons(),
               )
           )
         ),
       );
    }
    List<Widget> buildInputs(){
      return [
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Email'),
          validator: (val) => val.isEmpty ? 'Email can t be empty' : null,
          onSaved: (val) => _email=val,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Password'),
          obscureText: true,
          validator: (val) => val.isEmpty ? 'Password can t be empty' : null,
          onSaved: (val) => _password=val,
        )
      ];


    }

      List<Widget> buildButtons(){
        if( _formType == FormType.login){
          return [
            new RaisedButton(
              child: new Text('Login', style: new TextStyle(fontSize: 20.0,color: Colors.blue)),
              onPressed: validateAndSubmit,
            ),
            new FlatButton(
                onPressed: moveToRegiter,
                child: new Text('Create an account', style: new TextStyle(fontSize: 20.0))
            )
          ];
        }else{
          return [
          new RaisedButton(
            child: new Text('Create an account', style: new TextStyle(fontSize: 20.0,color: Colors.blue)),
            onPressed: validateAndSubmit,
          ),
        new FlatButton(
        onPressed: moveToLogin,
        child: new Text('Have an account ? Login', style: new TextStyle(fontSize: 20.0))
        )
          ];
        }

      }
   }
