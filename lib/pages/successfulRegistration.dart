// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SuccessfulRegistration(),
    ));

class SuccessfulRegistration extends StatefulWidget {
  @override
  State<SuccessfulRegistration> createState() => _SuccessfulRegistrationState();
}

class _SuccessfulRegistrationState extends State<SuccessfulRegistration> {

  String studentLastName = '';



  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    studentLastName = arguments['studentLastName'];
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.orange.shade900,
          Colors.orange.shade800,
          Colors.orange.shade400
        ])),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 80,
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                      ]),
                ),
                Container(
                                  decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(60))),
                                  child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(children: <Widget>[
                  const SizedBox(
                    height: 50,
                  ),
                  Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 130,
                          color: Colors.orange[800],
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 200,
                  ),
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Color.fromRGBO(225, 95, 27, .3),
                      //     blurRadius: 20,
                      //     offset: Offset(0, 10),
                      //   )
                      // ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "$studentLastName attendance has been registered successfully",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ]),
                                  ),
                                )
              ]),
        ),
      ),
    );
  }
}
