import 'package:flutter/material.dart';
import 'package:momopay/screens/login.dart';
import 'package:momopay/services/authService.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
        appBar: AppBar(title: Text("Register page")),
        body: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Text(
                'Momo pay Demo app',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 30),
              )),
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Text(
                'Sign Up',
                style: TextStyle(fontSize: 20),
              )),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontStyle: FontStyle.italic),
                  ),
                  child: Text('Sign up'),
                  onPressed: () async {
                    print(emailController.text);
                    print(passwordController.text);
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();

                    bool result = await authService.signUp(email, password);

                    if (result) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    } else {
                      final snackBar =
                          SnackBar(content: Text("Unable to sign up"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  })),
          Container(
              child: Row(children: <Widget>[
            Text("Already have an account?"),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontStyle: FontStyle.italic),
              ),
              child: Text(
                'Sign In',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            )
          ])),
        ])));
  }
}
