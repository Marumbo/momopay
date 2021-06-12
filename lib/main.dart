import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:momopay/screens/home.dart';
import 'package:momopay/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:momopay/screens/register.dart';
import 'package:momopay/services/authService.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    return MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (_) => AuthService(),
          ),
        ],
        child: MaterialApp(
          title: 'MomoPay demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: firebaseUser != null ? HomeScreen() : LoginScreen(),
        ));
  }
}
