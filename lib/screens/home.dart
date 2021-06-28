import 'package:flutter/material.dart';
import 'package:hover_ussd/hover_ussd.dart';
import 'package:momopay/screens/login.dart';
import 'package:momopay/services/authService.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HoverUssd _hoverUssd = HoverUssd();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        actions: [
          IconButton(
              onPressed: () async {
                final result = await authService.signOut();
                if (result) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                } else {
                  final snackBar =
                      SnackBar(content: Text("Unable to Sign out"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Row(
          children: [
            TextButton(
              onPressed: () {
                _hoverUssd.sendUssd(actionId: "d0f4bcc3", extras: {});
              },
              child: Text("Start Trasaction"),
            ),
            StreamBuilder(
              stream: _hoverUssd.onTransactiontateChanged,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == TransactionState.succesfull) {
                  return Text("succesfull");
                } else if (snapshot.data == TransactionState.waiting) {
                  return Text("pending");
                } else if (snapshot.data == TransactionState.failed) {
                  return Text("failed");
                }
                return Text("no transaction");
              },
            ),
          ],
        ),
      ),
    );
  }
}
