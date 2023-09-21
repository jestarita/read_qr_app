import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) {
    runApp(const MaterialApp(home: MyHome()));
  });
}

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Demo Home Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return const QRViewExample();
              },
            );
          },
          child: const Text('Scan qr code'),
        ),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String name = "";
  String lastName = "";
  String age = "";
  String division = "";
  String gender = "";
  String urlImage = "";
  Widget imageAvatar = const CircleAvatar(
    // or any widget that use imageProvider like (PhotoView)
    backgroundImage: AssetImage('assets/avatar.png'),
    radius: 50,
  );

  bool error = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: columnsModal(context)),
        Row(
          children: [
            const Spacer(),
            SizedBox(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  color: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 22),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.white, fontSize: 13.0),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget columnsModal(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: cameraScanner(context),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: detailPlayer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget detailPlayer() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          const Text('Player Detail',
              style: TextStyle(color: Colors.black, fontSize: 49)),
          const SizedBox(
            height: 15,
          ),
          imageAvatar,
          const SizedBox(
            height: 28,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  const Text(
                    'First Name:',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    name,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  const Text(
                    'Last Name:',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    lastName,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  const Text(
                    'Gender:',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    gender,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  const Text(
                    'Age:',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    age,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  const Text(
                    'Division:',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    division,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cameraScanner(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(child: _buildQrView(context)),
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 600.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: const Color.fromARGB(255, 255, 17, 0),
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen(
      (scanData) {
        _setPlayerData(scanData);
      },
      onError: (error) {
        print('error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The qr code is not valid')),
        );
      },
      onDone: () {},
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void _setPlayerData(Barcode? data) {
    try {
      var stringJson = data?.code ?? "";
      var resultDecode = jsonDecode(stringJson);
      setState(() {
        name = resultDecode['first_name'];
        lastName = resultDecode['last_name'];
        age = resultDecode['age'].toString();
        division = resultDecode['division_season'];
        gender = resultDecode['sex'];
        urlImage = resultDecode['photo_url'];
        try {
          imageAvatar = CircleAvatar(
          backgroundImage: NetworkImage(urlImage),
          radius: 50,
        );
        } catch (e) {
           imageAvatar = const CircleAvatar(
          // or any widget that use imageProvider like (PhotoView)
          backgroundImage: AssetImage('assets/avatar.png'),
          radius: 50,
        );
        }

      });
    } catch (e) {
      setState(() {
        name = '';
        lastName = '';
        age = '';
        division = '';
        gender = '';
        urlImage = '';
        imageAvatar = const CircleAvatar(
          // or any widget that use imageProvider like (PhotoView)
          backgroundImage: AssetImage('assets/avatar.png'),
          radius: 50,
        );
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
