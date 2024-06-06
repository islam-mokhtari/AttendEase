import 'package:flutter/material.dart';
import 'pages/fingerPrintScanning.dart';
import 'pages/loginPage.dart';
import 'pages/qrCodeScanning.dart';
import 'pages/successfulRegistration.dart';

main() => {
  
  runApp(App())
};

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {

    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/loginPage',
      routes: {
        '/loginPage': (context) => LoginPage(),
        '/qrCodeScanning': (context) => QrCodeScanning(),
        '/fingerPrintScanning': (context) => FingerPrintScanning(),
        '/successfulRegistration': (context) => SuccessfulRegistration(),
      },
    );
  }
}
