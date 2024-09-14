import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
final _firebase =FirebaseAuth.instance;
class AuthScreen extends StatefulWidget{
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}
class _AuthScreenState extends State<AuthScreen>{
  var _enteredemail ='';
    var _enteredpassword ='';


  final _form= GlobalKey<FormState>();
  var _islogin=true;
  void _submit() async{
    final isvalid =_form.currentState!.validate();
    if(!isvalid){
return;
    }
      _form.currentState!.save();
      if(_islogin){

      }else{
        try{
      final UserCredentials =await  _firebase.createUserWithEmailAndPassword(email: _enteredemail, password: _enteredpassword);
        print(UserCredentials);
        } on FirebaseAuthException catch(error){
          if(error.code == 'email-already-in-use'){
          }
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(error.message ?? 'Authentication failed'),  // Proper content
    ),
  );
        }
      }
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin:const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin:const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key:_form,
                      child:
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email Address',                           
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator:(value) {
                            if(value==null || value.trim().isEmpty || !value.contains('@')){
                              return 'please enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (Value) {
                            _enteredemail=Value!;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Password',                           
                          ),
                        obscureText:true, //يسوي هايد للباس اذا جيت تكتبه 
                        validator:(value) {
                            if(value==null || value.trim().length<6  ){
                              return 'password must be more than 6 Characters';
                            }
                            return null;
                          },
                          onSaved: (Value) {
                            _enteredpassword=Value!;
                          },
                        ),
                        SizedBox(height: 12,),
                        ElevatedButton(
                          onPressed: (){
                            _submit();
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primaryContainer),
                           child: Text(_islogin?'Login':'Signup'),),
                           TextButton(onPressed: (){
                            setState(() {
                              _islogin=!_islogin;
                            });
                           },
                            child: Text(_islogin ?'Create an account' :'I already have an account'),),

                      ],
                    )
                    ),
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}