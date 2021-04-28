import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sslcommerz_flutter/model/SSLCAdditionalInitializer.dart';
import 'package:sslcommerz_flutter/model/SSLCCustomerInfoInitializer.dart';
import 'package:sslcommerz_flutter/model/SSLCEMITransactionInitializer.dart';
import 'package:sslcommerz_flutter/model/SSLCSdkType.dart';
import 'package:sslcommerz_flutter/model/SSLCShipmentInfoInitializer.dart';
import 'package:sslcommerz_flutter/model/SSLCTransactionInfoModel.dart';
import 'package:sslcommerz_flutter/model/SSLCommerzInitialization.dart';
import 'package:sslcommerz_flutter/model/SSLCurrencyType.dart';
import 'package:sslcommerz_flutter/model/sslproductinitilizer/General.dart';
import 'package:sslcommerz_flutter/model/sslproductinitilizer/SSLCProductInitializer.dart';
import 'package:sslcommerz_flutter/sslcommerz.dart';
import 'payment/ssl_commerz.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _key = GlobalKey<FormState>();
  double _amount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('SSL Commerz'),
          ),
          body: Form(
            key: _key,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(

                   keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(8.0))),
                      hintText: "Amount"
                    ),
                    validator: (value){
                     if(value.isEmpty){
                       return "Please Enter Amount";
                     }
                     return null;
                    },
                    onSaved: (value){
                     _amount = double.parse(value);
                    },
                  ),
                ),

                FlatButton(
                    onPressed: () async{
                      if(_key.currentState.validate()){
                        _key.currentState.save();
                        print("Amount: $_amount");
                        var result = await EasySSLCommerz(amount: _amount).payNow();
                        if (result is PlatformException) {
                          print("the response is: " + result.message + " code: " + result.code);
                        } else {
                          SSLCTransactionInfoModel model = result as SSLCTransactionInfoModel;
                          print("SSLCTransactionInfoModel: $model");
                        }

                      }
                    },
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Pay Now', style: TextStyle(fontSize: 20.0)),
                    )
                )
              ],
            ),
          )),
    );
  }
}