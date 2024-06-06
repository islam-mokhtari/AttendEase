// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously, sized_box_for_whitespace, avoid_print, avoid_unnecessary_containers


import 'package:bubbles/database/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';



class QrCodeScanning extends StatefulWidget {
  @override
  State<QrCodeScanning> createState() => _QrCodeScanningState();
}

class _QrCodeScanningState extends State<QrCodeScanning> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrCodeResult;
  bool _isLoading = false;
  bool _isDialogLoading = false;
  // String? _seanceID = null ;
  String appUserID = "";

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
        _isDialogLoading = true;
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
        _isDialogLoading = true;
      });
      
      String seanceId = code;

      try {
        var results = await _dbHelper.getSeanceById(seanceId);

        

        if (results.isNotEmpty) {
          setState(() {
          _isLoading = false;
          _isDialogLoading = false;
        });

          // print(results);

          Navigator.pushNamed(
            context,
            '/fingerPrintScanning',
            arguments: {
              'appUserID': appUserID,
              'seanceId': seanceId,
              'moduleName': results.first['module'],
              'seanceType': results.first['seanceType'],
              'responsibleProf': results.first['lastName'],
              'startTime': results.first['startTime'],
              'endTime': results.first['endTime'],
            },
          );
        } else {
          setState(() {
          _isLoading = false;
          _isDialogLoading = false;
        });
          _showErrorMessage('Error in QR Code. This Seance is not registered in the database.');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          _isDialogLoading = false;
        });
        _showErrorMessage('Error: $e');
      }
    }
    else{
      setState(() {
        _isLoading = false;
        _isDialogLoading = false;
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
                _isDialogLoading = false;
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



    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Colors.orange.shade900,
            Colors.orange.shade800,
            Colors.orange.shade400,
          ]),
        ),
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
                    Text(
                      "Scan QR code",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 50,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _isLoading? 
                          Container(
                           child: const Center(
                            child: CircularProgressIndicator(),
                           ), 
                          )
                          : Icon(
                            Icons.qr_code_scanner_rounded,
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
                        ),
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: ElevatedButton(
                                // onPressed: () async {
                                //   Navigator.pushNamed(
                                //     context,
                                //     '/fingerPrintScanning',
                                //     arguments: {
                                //       'seanceId': 'seaneID-test',
                                //       'moduleName': 'test name',
                                //       'seanceType': 'test type',
                                //       'responsibleProf': 'test respProf',
                                //       'startTime': null,
                                //       'endTime': null,
                                //     },
                                //   );
                                // },
                                onPressed: () async {
                                  await _showQRScanner();

                                  setState(() {});

                                  _processQRCode(qrCodeResult);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange[800],
                                ),
                                child: const Text(
                                  "Scan",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
            content: Container(
              height: 300, 
              child: _isDialogLoading 
                    ? const Center(
                        child:  CircularProgressIndicator(),
                      )
                    : QRView(
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
