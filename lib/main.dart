import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:convert';
import 'package:http/http.dart';



void main() {
  runApp(MaterialApp(
    home: IfscDecoded(),
  ));
}
class IfscDecoded extends StatefulWidget {
  const IfscDecoded({Key? key}) : super(key: key);

  @override
  State<IfscDecoded> createState() => _IfscDecodedState();
}

class _IfscDecodedState extends State<IfscDecoded> {
  late String IfscCode;
  String bankname='Your Bank';
  String address='';
  String contact='';
  String baselink = 'https://ifsc.razorpay.com/';
  final myController = TextEditingController();

  launchDialer(String number) async {
    String url = 'tel:' + number;
    try{
      await launch(url);
    } catch(e) {
      throw 'Application unable to open dialer.';
    }
  }
  void getDetails(IfscCode) async{
    Response response = await get(Uri.parse('https://ifsc.razorpay.com/$IfscCode'));
    Map data = jsonDecode(response.body);
    setState(() {
      try{
        bankname=data['BRANCH'];
        contact=data['CONTACT'];
        address=data['ADDRESS'];
      }
      catch(e){
        bankname='Not Able to fetch';
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[800],
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          title: Text(
              'IFSC Decoder'
          ),
          centerTitle: true,
          titleSpacing: 1.0,
        ),
        body:Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.0,),
              TextField(
                controller: myController,
                decoration: InputDecoration(
                  hintText: 'Enter your IFSC Code here',
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  border: OutlineInputBorder(),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: () {
                      IfscCode = myController.text.toString();
                      if (IfscCode.length != 11) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("Enter Valid IFSC"),
                            );
                          },
                        );
                      }
                      else{
                        getDetails(IfscCode);
                      }
                    },
                    child: Text(
                      'Submit'
                    ),

                ),
              ),
              SizedBox(
                height: 100.0,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  bankname,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey[200]
                  ),
                ),
              ),
                Text(
                  address,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.yellow[800]
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextButton(
                  child:(
                    Text(contact,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey[200],
                      ),
                    )
                  ),
                  onPressed: () async{
                    await launchDialer(contact);
                  },
                ),
              ),
            ],
          ),

        )
    );
  }

}

