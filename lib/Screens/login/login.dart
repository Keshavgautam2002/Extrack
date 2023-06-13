import 'package:expense_app/Screens/homePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final auth = FirebaseAuth.instance;
  bool isLogging = false;

  SignIn()
  async{
    setState(() {
      isLogging = true;
    });
    GoogleSignIn signIn = GoogleSignIn();
    GoogleSignInAccount? account = await signIn.signIn();
    if(account != null)
      {
        GoogleSignInAuthentication authentication = await account.authentication;
        OAuthCredential credential = await GoogleAuthProvider.credential(
          idToken: authentication.idToken,accessToken: authentication.accessToken
        );
        UserCredential res = await auth.signInWithCredential(credential);
        User? user = res.user;
        print("Welcome ${user!.displayName}");
        if(res != null)
          {
            setState(() {
              isLogging = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully Logged in",style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
          }
      }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Occured while sing in",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,));
      setState(() {
        isLogging = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLogging ? Center(child: CircularProgressIndicator(),) : Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset("assets/image/Expanse.png",height: 200,width: 200,)),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                SignIn();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15)

                ),
                padding: EdgeInsets.symmetric(vertical: 7,horizontal: 15),
                margin: EdgeInsets.all(7),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset("assets/image/google.png",height: 35,width: 35,),
                    SizedBox(width: 10,),
                    Text("Sign in with google",style: TextStyle(
                      fontSize: 16,fontWeight: FontWeight.bold
                    ),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
