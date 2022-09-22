import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:momopay/screens/login.dart';
import 'package:momopay/services/authService.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final numberController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void dispose() {
    numberController.dispose();
    amountController.dispose();
    super.dispose();
  }

  // ignore: must_call_super
  void initState() {
    numberController.text = "";
    amountController.text = "";
  }

  static const platform = MethodChannel('samples.flutter.dev/battery');
// Get battery level.
  String _batteryLevel = 'Unknown battery level.';

  String phoneNumber = "";
  String amount = "";

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  static const _hover = const MethodChannel('momopay.mw/hover');
  String _ActionResponse = 'Waiting for Response...';

  Future<dynamic> sendMoneyNumber(phoneNumber, amount) async {
    var sendMap = <String, dynamic>{
      'phoneNumber': phoneNumber,
      'amount': amount,
    };
// response waits for result from java code
    String response = "";
    try {
      final String result =
          await _hover.invokeMethod('sendMoneyNumber', sendMap);
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }
    setState(() {
      _ActionResponse = response;
    });
  }

  Future<dynamic> sendMoneyMerchant(phoneNumber, amount) async {
    var sendMap = <String, dynamic>{
      'phoneNumber': phoneNumber,
      'amount': amount,
    };
// response waits for result from java code
    String response = "";
    try {
      final String result =
          await _hover.invokeMethod('sendMoneyMerchant', sendMap);
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }
    setState(() {
      _ActionResponse = response;
    });
  }

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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: Text('Get Battery Level'),
                onPressed: _getBatteryLevel,
              ),
              Text("Battery level: $_batteryLevel"),
              SizedBox(height: 100),
              TextField(
                controller: numberController,
                decoration:
                    InputDecoration(hintText: 'Merchant or Person Number'),
                onChanged: (value) {
                  phoneNumber = value;
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: amountController,
                decoration: InputDecoration(hintText: 'Payment amount'),
                onChanged: (value) {
                  amount = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  child: Text("Pay Person"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      textStyle: MaterialStateProperty.all(
                          TextStyle(color: Colors.white))),
                  onPressed: () async {
                    sendMoneyNumber(phoneNumber, amount);
                  }),
              SizedBox(height: 20),
              ElevatedButton(
                  child: Text("Pay Merchant"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      textStyle: MaterialStateProperty.all(
                          TextStyle(color: Colors.white))),
                  onPressed: () {
                    sendMoneyMerchant(phoneNumber, amount);
                  }),
              SizedBox(height: 200),
              Text("Payment state: $_ActionResponse"),
            ],
          ),
        ),
      ),
    );
  }
}
