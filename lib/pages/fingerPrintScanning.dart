// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bubbles/database/db_helper.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FingerPrintScanning(),
    ));

class FingerPrintScanning extends StatefulWidget {
  @override
  State<FingerPrintScanning> createState() => _FingerPrintScanningState();
}

class _FingerPrintScanningState extends State<FingerPrintScanning> {

  String appUserID = "";

  String responsibleProf = "";

  String seanceId = "";

  String moduleName = "";

  String seanceType = "";

  String startTime = "";

  String endTime = "";

  String studentLastName = "" ;


  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrCodeResult;
  bool _isLoading = false;

  final DBHelper _dbHelper = DBHelper();

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCodeResult = scanData.code;
        _isLoading = true;
      });
      controller.pauseCamera();
      Navigator.of(context).pop();
      });
  }

  void _processQRCode(String? code) async {
    if (code != null) {
      setState(() {
        _isLoading = true;
      });
      String? studentIdQrCode = code;
      try {
        var results = await _dbHelper.getStudentByCardID(studentID: studentIdQrCode);
        if (results.isNotEmpty){


          var studentID = results.first['studentID'];
          var tmpStudentLastName = results.first['lastName'];

          bool alreadyPresent = await _dbHelper.checkStudentPresence(seanceId, studentID);

          if (alreadyPresent){
            _showErrorMessage('The student already registered to Seance!');
          }
          else {
            bool succ = await _dbHelper.markStudentPresence(seanceId, studentID, appUserID);
            if (succ){
              setState(() {
                _isLoading = false;
                studentLastName = tmpStudentLastName;
              });
              Navigator.pushNamed(
                context,
                '/successfulRegistration',
                arguments: {
                  'studentLastName': studentLastName,
              },);
            }
            else {
              setState(() {
                _isLoading = false;
              });

              _showErrorMessage('Error in Registering Student in the database.');
            }
          }





        }
        else {
           _showErrorMessage('Error in Registering Student. No Student in the database.');
        }

        
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showErrorMessage('Error: $e');
      }
    }
    else{
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan Failed'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isLoading = false;
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    ).then((_) {
      if (controller != null) {
        controller!.resumeCamera();
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;


    
    appUserID = arguments['appUserID'];
    responsibleProf = arguments['responsibleProf'];
    seanceId = arguments['seanceId'];
    moduleName = arguments['moduleName'];
    seanceType = arguments['seanceType'];
    startTime = DateFormat('yyyy-MM-dd HH:mm').format(arguments['startTime']);
    endTime = DateFormat('yyyy-MM-dd HH:mm').format(arguments['endTime']);
    // startTime = 'test-start-time' ;
    // endTime = 'test-end-time' ;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
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
               Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      // "Register your attendance",
                      "Seance details",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(60),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                color: Colors.amber,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Module name',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Flexible(child: Text(moduleName, overflow: TextOverflow.ellipsis,)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                color: Colors.amber,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Module type',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(seanceType),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                color: Colors.amber,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Responsible prof',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      // RichText(text: responsibleProf),
                                      Text(responsibleProf),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                color: Colors.amber,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Start time',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(startTime),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                color: Colors.amber,
                                child:  Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'End time',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(endTime),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            _isLoading? 
                            CircularProgressIndicator()
                            : Icon(
                                Icons.fingerprint,
                                size: 100,
                                color: Colors.orange[800],
                              ),
                            const SizedBox(
                              height: 50,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Navigator.pushNamed(
                                //     context, '/successfulRegistration');
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange[800]),
                              child: const Text(
                                "Scan",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await _showQRScanner();
                                setState(() {});
                                _processQRCode(qrCodeResult);

                              },
                              child: Text(
                                "Can't use fingerprint? Use student card QR code.",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _showQRScanner() {
    return showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) {
          return AlertDialog(
            content: SizedBox(
              height: 300, 
              child: 
                     QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
            ),
          );
        },
      ),
    ).then((_) {
      if (controller != null) {
        controller!.resumeCamera();
      }
    });
  }




}
